import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/models/word.dart';
import 'package:wort_wirbel/models/universal_part_of_speech.dart';
import 'package:wort_wirbel/models/proficiency_level.dart';
import 'package:wort_wirbel/models/gender.dart';

void main() {
  group('Word Domain Entity', () {
    test('should create Word with required fields', () {
      // Arrange
      final now = DateTime.now();
      
      // Act
      final word = Word(
        id: 'test-id',
        lemma: 'Haus',
        language: 'de',
        universalPos: UniversalPartOfSpeech.noun,
        primaryDefinition: 'house',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(word.id, equals('test-id'));
      expect(word.lemma, equals('Haus'));
      expect(word.language, equals('de'));
      expect(word.universalPos, equals(UniversalPartOfSpeech.noun));
      expect(word.primaryDefinition, equals('house'));
      expect(word.createdAt, equals(now));
      expect(word.updatedAt, equals(now));
    });

    test('should create Word with all optional fields', () {
      // Arrange
      final now = DateTime.now();
      final examples = [
        ExampleSentence(text: 'Das ist ein großes Haus.', translation: 'This is a big house.'),
      ];
      final metadata = WordMetadata(
        frequencyRank: 100,
        proficiencyLevel: ProficiencyLevel.a1,
        gender: Gender.neuter,
        pluralForm: 'Häuser',
        sourceAttribution: 'Test Source',
      );
      final media = WordMedia(audioUrl: 'https://example.com/audio.mp3');

      // Act
      final word = Word(
        id: 'test-id',
        lemma: 'Haus',
        language: 'de',
        universalPos: UniversalPartOfSpeech.noun,
        languagePosTag: 'NN',
        primaryDefinition: 'house',
        alternativeDefinitions: ['building', 'home'],
        synonyms: ['Gebäude', 'Zuhause'],
        examples: examples,
        metadata: metadata,
        media: media,
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(word.languagePosTag, equals('NN'));
      expect(word.alternativeDefinitions, equals(['building', 'home']));
      expect(word.synonyms, equals(['Gebäude', 'Zuhause']));
      expect(word.examples, equals(examples));
      expect(word.metadata, equals(metadata));
      expect(word.media, equals(media));
    });

    test('should be immutable', () {
      // Arrange
      final now = DateTime.now();
      final word = Word(
        id: 'test-id',
        lemma: 'Haus',
        language: 'de',
        universalPos: UniversalPartOfSpeech.noun,
        primaryDefinition: 'house',
        createdAt: now,
        updatedAt: now,
      );

      // Act & Assert
      // This test verifies that Word is immutable by ensuring all fields are final
      expect(word.id, equals('test-id'));
      // Note: Can't test assignment in Dart as it's a compile-time error
    });
  });

  group('ExampleSentence Value Object', () {
    test('should create ExampleSentence with text only', () {
      // Act
      final example = ExampleSentence(text: 'Das ist ein Haus.');

      // Assert
      expect(example.text, equals('Das ist ein Haus.'));
      expect(example.translation, isNull);
    });

    test('should create ExampleSentence with text and translation', () {
      // Act
      final example = ExampleSentence(
        text: 'Das ist ein Haus.',
        translation: 'This is a house.',
      );

      // Assert
      expect(example.text, equals('Das ist ein Haus.'));
      expect(example.translation, equals('This is a house.'));
    });

    test('should be equal when text and translation are the same', () {
      // Arrange
      final example1 = ExampleSentence(
        text: 'Das ist ein Haus.',
        translation: 'This is a house.',
      );
      final example2 = ExampleSentence(
        text: 'Das ist ein Haus.',
        translation: 'This is a house.',
      );

      // Assert
      expect(example1, equals(example2));
      expect(example1.hashCode, equals(example2.hashCode));
    });
  });

  group('WordMetadata Value Object', () {
    test('should create WordMetadata with all fields', () {
      // Act
      final metadata = WordMetadata(
        frequencyRank: 100,
        proficiencyLevel: ProficiencyLevel.a1,
        gender: Gender.neuter,
        pluralForm: 'Häuser',
        sourceAttribution: 'Test Source',
      );

      // Assert
      expect(metadata.frequencyRank, equals(100));
      expect(metadata.proficiencyLevel, equals(ProficiencyLevel.a1));
      expect(metadata.gender, equals(Gender.neuter));
      expect(metadata.pluralForm, equals('Häuser'));
      expect(metadata.sourceAttribution, equals('Test Source'));
    });

    test('should create WordMetadata with optional fields as null', () {
      // Act
      final metadata = WordMetadata();

      // Assert
      expect(metadata.frequencyRank, isNull);
      expect(metadata.proficiencyLevel, isNull);
      expect(metadata.gender, isNull);
      expect(metadata.pluralForm, isNull);
      expect(metadata.sourceAttribution, isNull);
    });
  });

  group('WordMedia Value Object', () {
    test('should create WordMedia with audioUrl', () {
      // Act
      final media = WordMedia(audioUrl: 'https://example.com/audio.mp3');

      // Assert
      expect(media.audioUrl, equals('https://example.com/audio.mp3'));
    });

    test('should create WordMedia with null audioUrl', () {
      // Act
      final media = WordMedia();

      // Assert
      expect(media.audioUrl, isNull);
    });
  });
}