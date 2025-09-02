import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/models/universal_part_of_speech.dart';

void main() {
  group('UniversalPartOfSpeech', () {
    group('fromString', () {
      test('should parse standard POS tags correctly', () {
        expect(UniversalPartOfSpeech.fromString('NOUN'), equals(UniversalPartOfSpeech.noun));
        expect(UniversalPartOfSpeech.fromString('VERB'), equals(UniversalPartOfSpeech.verb));
        expect(UniversalPartOfSpeech.fromString('ADJ'), equals(UniversalPartOfSpeech.adjective));
        expect(UniversalPartOfSpeech.fromString('ADV'), equals(UniversalPartOfSpeech.adverb));
        expect(UniversalPartOfSpeech.fromString('PRON'), equals(UniversalPartOfSpeech.pronoun));
        expect(UniversalPartOfSpeech.fromString('DET'), equals(UniversalPartOfSpeech.determiner));
        expect(UniversalPartOfSpeech.fromString('PREP'), equals(UniversalPartOfSpeech.preposition));
        expect(UniversalPartOfSpeech.fromString('CONJ'), equals(UniversalPartOfSpeech.conjunction));
        expect(UniversalPartOfSpeech.fromString('INTJ'), equals(UniversalPartOfSpeech.interjection));
        expect(UniversalPartOfSpeech.fromString('NUM'), equals(UniversalPartOfSpeech.numeral));
        expect(UniversalPartOfSpeech.fromString('ABBR'), equals(UniversalPartOfSpeech.abbreviation));
        expect(UniversalPartOfSpeech.fromString('OTHER'), equals(UniversalPartOfSpeech.other));
      });

      test('should parse alternative forms correctly', () {
        expect(UniversalPartOfSpeech.fromString('ADJECTIVE'), equals(UniversalPartOfSpeech.adjective));
        expect(UniversalPartOfSpeech.fromString('ADVERB'), equals(UniversalPartOfSpeech.adverb));
        expect(UniversalPartOfSpeech.fromString('PRONOUN'), equals(UniversalPartOfSpeech.pronoun));
        expect(UniversalPartOfSpeech.fromString('DETERMINER'), equals(UniversalPartOfSpeech.determiner));
        expect(UniversalPartOfSpeech.fromString('PREPOSITION'), equals(UniversalPartOfSpeech.preposition));
        expect(UniversalPartOfSpeech.fromString('CONJUNCTION'), equals(UniversalPartOfSpeech.conjunction));
        expect(UniversalPartOfSpeech.fromString('INTERJECTION'), equals(UniversalPartOfSpeech.interjection));
        expect(UniversalPartOfSpeech.fromString('NUMERAL'), equals(UniversalPartOfSpeech.numeral));
        expect(UniversalPartOfSpeech.fromString('ABBREVIATION'), equals(UniversalPartOfSpeech.abbreviation));
      });

      test('should be case insensitive', () {
        expect(UniversalPartOfSpeech.fromString('noun'), equals(UniversalPartOfSpeech.noun));
        expect(UniversalPartOfSpeech.fromString('Verb'), equals(UniversalPartOfSpeech.verb));
        expect(UniversalPartOfSpeech.fromString('adj'), equals(UniversalPartOfSpeech.adjective));
      });

      test('should default to other for unknown values', () {
        expect(UniversalPartOfSpeech.fromString('UNKNOWN'), equals(UniversalPartOfSpeech.other));
        expect(UniversalPartOfSpeech.fromString('invalid'), equals(UniversalPartOfSpeech.other));
        expect(UniversalPartOfSpeech.fromString(''), equals(UniversalPartOfSpeech.other));
      });

      test('should handle null input', () {
        expect(UniversalPartOfSpeech.fromString(null), equals(UniversalPartOfSpeech.other));
      });
    });

    group('toCanonicalString', () {
      test('should convert to canonical string representation', () {
        expect(UniversalPartOfSpeech.noun.toCanonicalString(), equals('NOUN'));
        expect(UniversalPartOfSpeech.verb.toCanonicalString(), equals('VERB'));
        expect(UniversalPartOfSpeech.adjective.toCanonicalString(), equals('ADJ'));
        expect(UniversalPartOfSpeech.adverb.toCanonicalString(), equals('ADV'));
        expect(UniversalPartOfSpeech.pronoun.toCanonicalString(), equals('PRON'));
        expect(UniversalPartOfSpeech.determiner.toCanonicalString(), equals('DET'));
        expect(UniversalPartOfSpeech.preposition.toCanonicalString(), equals('PREP'));
        expect(UniversalPartOfSpeech.conjunction.toCanonicalString(), equals('CONJ'));
        expect(UniversalPartOfSpeech.interjection.toCanonicalString(), equals('INTJ'));
        expect(UniversalPartOfSpeech.numeral.toCanonicalString(), equals('NUM'));
        expect(UniversalPartOfSpeech.abbreviation.toCanonicalString(), equals('ABBR'));
        expect(UniversalPartOfSpeech.other.toCanonicalString(), equals('OTHER'));
      });

      test('should be consistent with fromString', () {
        for (final pos in UniversalPartOfSpeech.values) {
          final canonical = pos.toCanonicalString();
          expect(UniversalPartOfSpeech.fromString(canonical), equals(pos));
        }
      });
    });
  });
}