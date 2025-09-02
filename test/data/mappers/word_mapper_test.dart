import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/data/mappers/word_mapper.dart';
import 'package:wort_wirbel/data/dtos/word_dto.dart';
import 'package:wort_wirbel/data/errors/word_errors.dart';
import 'package:wort_wirbel/models/word.dart';
import 'package:wort_wirbel/models/universal_part_of_speech.dart';
import 'package:wort_wirbel/models/proficiency_level.dart';
import 'package:wort_wirbel/models/gender.dart';

void main() {
  group('WordMapper', () {
    group('fromDto', () {
      test('should map minimal valid DTO to Word', () {
        // Arrange
        final dto = WordDto(
          id: 'test-id',
          lemma: 'Haus',
          lang: 'de',
          pos: 'NOUN',
          defs: ['house'],
          updated: DateTime(2024, 1, 15),
        );

        // Act
        final word = WordMapper.fromDto(dto);

        // Assert
        expect(word.id, equals('test-id'));
        expect(word.lemma, equals('Haus'));
        expect(word.language, equals('de'));
        expect(word.universalPos, equals(UniversalPartOfSpeech.noun));
        expect(word.primaryDefinition, equals('house'));
        expect(word.updatedAt, equals(DateTime(2024, 1, 15)));
        expect(word.createdAt, isA<DateTime>());
      });

      test('should map complete DTO to Word with all fields', () {
        // Arrange
        final dto = WordDto(
          id: 'test-id',
          lemma: 'Haus',
          lang: 'de',
          pos: 'NOUN',
          posTag: 'NN',
          defs: ['house', 'building', 'home'],
          synonyms: ['Gebäude', 'Zuhause', 'Wohnung'],
          examples: [
            ExampleDto(text: 'Das ist ein großes Haus.', tr: 'This is a big house.'),
            ExampleDto(text: 'Wir kaufen ein Haus.'),
          ],
          freqRank: 100,
          cefr: 'A1',
          gender: 'N',
          plural: 'Häuser',
          audio: 'https://example.com/audio.mp3',
          src: 'Test Dictionary',
          updated: DateTime(2024, 1, 15),
        );

        // Act
        final word = WordMapper.fromDto(dto);

        // Assert
        expect(word.id, equals('test-id'));
        expect(word.lemma, equals('Haus'));
        expect(word.language, equals('de'));
        expect(word.universalPos, equals(UniversalPartOfSpeech.noun));
        expect(word.languagePosTag, equals('NN'));
        expect(word.primaryDefinition, equals('house'));
        expect(word.alternativeDefinitions, equals(['building', 'home']));
        expect(word.synonyms, equals(['Gebäude', 'Zuhause', 'Wohnung']));
        expect(word.examples?.length, equals(2));
        expect(word.examples?[0].text, equals('Das ist ein großes Haus.'));
        expect(word.examples?[0].translation, equals('This is a big house.'));
        expect(word.examples?[1].text, equals('Wir kaufen ein Haus.'));
        expect(word.examples?[1].translation, isNull);
        expect(word.metadata?.frequencyRank, equals(100));
        expect(word.metadata?.proficiencyLevel, equals(ProficiencyLevel.a1));
        expect(word.metadata?.gender, equals(Gender.neuter));
        expect(word.metadata?.pluralForm, equals('Häuser'));
        expect(word.metadata?.sourceAttribution, equals('Test Dictionary'));
        expect(word.media?.audioUrl, equals('https://example.com/audio.mp3'));
        expect(word.updatedAt, equals(DateTime(2024, 1, 15)));
      });

      test('should apply normalization rules correctly', () {
        // Arrange - Test various normalization scenarios
        final dto = WordDto(
          id: '  test-id  ',  // Should trim
          lemma: '  Haus  ',    // Should trim
          lang: '  DE  ',       // Should trim and lowercase
          pos: 'unknown',       // Should map to OTHER
          defs: ['  house  ', '  HOUSE  ', 'building', ''],  // Should dedupe and trim
          synonyms: ['  Gebäude  ', 'Gebäude', 'GEBÄUDE', '', 'Very long synonym that exceeds the maximum length of 64 characters allowed'], // Should dedupe and filter
          examples: [
            ExampleDto(text: '  Example text  ', tr: '  Translation  '),  // Should trim
            ExampleDto(text: '', tr: 'Invalid'),  // Should be filtered out
            ExampleDto(text: 'Valid text', tr: ''),  // Translation should be null
          ],
          freqRank: -5,         // Should be null (must be positive)
          plural: 'Haus',       // Should be null (equals lemma)
          audio: 'http://example.com/audio.mp3',  // Should be null (not https)
        );

        // Act
        final word = WordMapper.fromDto(dto);

        // Assert
        expect(word.id, equals('test-id'));
        expect(word.lemma, equals('Haus'));
        expect(word.language, equals('de'));
        expect(word.universalPos, equals(UniversalPartOfSpeech.other));
        expect(word.primaryDefinition, equals('house'));
        expect(word.alternativeDefinitions, equals(['building'])); // Deduplicated
        expect(word.synonyms, equals(['Gebäude'])); // Deduplicated and filtered
        expect(word.examples?.length, equals(2));
        expect(word.examples?[0].text, equals('Example text'));
        expect(word.examples?[0].translation, equals('Translation'));
        expect(word.examples?[1].text, equals('Valid text'));
        expect(word.examples?[1].translation, isNull);
        expect(word.metadata?.frequencyRank, isNull);
        expect(word.metadata?.pluralForm, isNull);
        expect(word.media?.audioUrl, isNull);
      });

      test('should handle missing optional fields gracefully', () {
        // Arrange
        final dto = WordDto(
          id: 'test-id',
          lemma: 'Haus',
          defs: ['house'],
        );

        // Act
        final word = WordMapper.fromDto(dto);

        // Assert
        expect(word.language, equals('de')); // Default
        expect(word.universalPos, equals(UniversalPartOfSpeech.other)); // Default
        expect(word.languagePosTag, isNull);
        expect(word.alternativeDefinitions, isNull);
        expect(word.synonyms, isNull);
        expect(word.examples, isNull);
        expect(word.metadata, isNull);
        expect(word.media, isNull);
        expect(word.updatedAt, isA<DateTime>()); // Fallback to now
      });

      test('should throw WordValidationError for missing required fields', () {
        // Test missing ID (empty string)
        expect(
          () => WordMapper.fromDto(WordDto(id: '', lemma: 'test', defs: ['def'])),
          throwsA(isA<WordValidationError>().having((e) => e.field, 'field', 'id')),
        );

        // Test missing lemma (empty string)
        expect(
          () => WordMapper.fromDto(WordDto(id: 'test', lemma: '', defs: ['def'])),
          throwsA(isA<WordValidationError>().having((e) => e.field, 'field', 'lemma')),
        );

        // Test missing definitions
        expect(
          () => WordMapper.fromDto(WordDto(id: 'test', lemma: 'test')),
          throwsA(isA<WordValidationError>().having((e) => e.field, 'field', 'primaryDefinition')),
        );

        // Test empty definitions
        expect(
          () => WordMapper.fromDto(WordDto(id: 'test', lemma: 'test', defs: [])),
          throwsA(isA<WordValidationError>().having((e) => e.field, 'field', 'primaryDefinition')),
        );
      });

      test('should apply synonym constraints correctly', () {
        // Arrange - Test max 10 synonyms with 64 char limit
        final synonyms = List.generate(15, (i) => 'synonym$i'); // 15 synonyms
        synonyms.add('This is a very long synonym that definitely exceeds the sixty-four character limit'); // Too long
        
        final dto = WordDto(
          id: 'test-id',
          lemma: 'test',
          defs: ['definition'],
          synonyms: synonyms,
        );

        // Act
        final word = WordMapper.fromDto(dto);

        // Assert
        expect(word.synonyms?.length, equals(10)); // Limited to 10
        expect(word.synonyms?.every((s) => s.length <= 64), isTrue); // All within length limit
      });
    });

    group('toDto', () {
      test('should map Word to DTO correctly', () {
        // Arrange
        final now = DateTime(2024, 1, 15);
        final word = Word(
          id: 'test-id',
          lemma: 'Haus',
          language: 'de',
          universalPos: UniversalPartOfSpeech.noun,
          languagePosTag: 'NN',
          primaryDefinition: 'house',
          alternativeDefinitions: ['building', 'home'],
          synonyms: ['Gebäude', 'Zuhause'],
          examples: [
            ExampleSentence(text: 'Das ist ein Haus.', translation: 'This is a house.'),
          ],
          metadata: WordMetadata(
            frequencyRank: 100,
            proficiencyLevel: ProficiencyLevel.a1,
            gender: Gender.neuter,
            pluralForm: 'Häuser',
            sourceAttribution: 'Test Dictionary',
          ),
          media: WordMedia(audioUrl: 'https://example.com/audio.mp3'),
          createdAt: now,
          updatedAt: now,
        );

        // Act
        final dto = WordMapper.toDto(word);

        // Assert
        expect(dto.id, equals('test-id'));
        expect(dto.lemma, equals('Haus'));
        expect(dto.lang, equals('de'));
        expect(dto.pos, equals('NOUN'));
        expect(dto.posTag, equals('NN'));
        expect(dto.defs, equals(['house', 'building', 'home']));
        expect(dto.synonyms, equals(['Gebäude', 'Zuhause']));
        expect(dto.examples?.length, equals(1));
        expect(dto.examples?[0].text, equals('Das ist ein Haus.'));
        expect(dto.examples?[0].tr, equals('This is a house.'));
        expect(dto.freqRank, equals(100));
        expect(dto.cefr, equals('A1'));
        expect(dto.gender, equals('N'));
        expect(dto.plural, equals('Häuser'));
        expect(dto.audio, equals('https://example.com/audio.mp3'));
        expect(dto.src, equals('Test Dictionary'));
        expect(dto.updated, equals(now));
      });

      test('should handle minimal Word correctly', () {
        // Arrange
        final now = DateTime(2024, 1, 15);
        final word = Word(
          id: 'test-id',
          lemma: 'Haus',
          language: 'de',
          universalPos: UniversalPartOfSpeech.noun,
          primaryDefinition: 'house',
          createdAt: now,
          updatedAt: now,
        );

        // Act
        final dto = WordMapper.toDto(word);

        // Assert
        expect(dto.id, equals('test-id'));
        expect(dto.lemma, equals('Haus'));
        expect(dto.lang, equals('de'));
        expect(dto.pos, equals('NOUN'));
        expect(dto.defs, equals(['house']));
        expect(dto.posTag, isNull);
        expect(dto.synonyms, isNull);
        expect(dto.examples, isNull);
        expect(dto.freqRank, isNull);
        expect(dto.cefr, isNull);
        expect(dto.gender, isNull);
        expect(dto.plural, isNull);
        expect(dto.audio, isNull);
        expect(dto.src, isNull);
        expect(dto.updated, equals(now));
      });
    });

    group('round-trip mapping', () {
      test('should maintain data integrity through DTO -> Word -> DTO conversion', () {
        // Arrange
        final originalDto = WordDto(
          id: 'test-id',
          lemma: 'Haus',
          lang: 'de',
          pos: 'NOUN',
          posTag: 'NN',
          defs: ['house', 'building'],
          synonyms: ['Gebäude'],
          examples: [
            ExampleDto(text: 'Das ist ein Haus.', tr: 'This is a house.'),
          ],
          freqRank: 100,
          cefr: 'A1',
          gender: 'N',
          plural: 'Häuser',
          audio: 'https://example.com/audio.mp3',
          src: 'Test Dictionary',
          updated: DateTime(2024, 1, 15),
        );

        // Act
        final word = WordMapper.fromDto(originalDto);
        final resultDto = WordMapper.toDto(word);

        // Assert key fields are preserved (some internal processing may occur)
        expect(resultDto.id, equals(originalDto.id));
        expect(resultDto.lemma, equals(originalDto.lemma));
        expect(resultDto.lang, equals(originalDto.lang));
        expect(resultDto.pos, equals(originalDto.pos));
        expect(resultDto.defs?[0], equals(originalDto.defs?[0])); // Primary definition
        expect(resultDto.freqRank, equals(originalDto.freqRank));
        expect(resultDto.cefr, equals(originalDto.cefr));
        expect(resultDto.gender, equals(originalDto.gender));
        expect(resultDto.plural, equals(originalDto.plural));
        expect(resultDto.audio, equals(originalDto.audio));
      });
    });
  });
}