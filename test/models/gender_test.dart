import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/models/gender.dart';

void main() {
  group('Gender', () {
    group('fromString', () {
      test('should parse standard gender values correctly', () {
        expect(Gender.fromString('M'), equals(Gender.masculine));
        expect(Gender.fromString('F'), equals(Gender.feminine));
        expect(Gender.fromString('N'), equals(Gender.neuter));
        expect(Gender.fromString('COMMON'), equals(Gender.common));
      });

      test('should parse full gender names correctly', () {
        expect(Gender.fromString('MASCULINE'), equals(Gender.masculine));
        expect(Gender.fromString('FEMININE'), equals(Gender.feminine));
        expect(Gender.fromString('NEUTER'), equals(Gender.neuter));
      });

      test('should be case insensitive', () {
        expect(Gender.fromString('m'), equals(Gender.masculine));
        expect(Gender.fromString('f'), equals(Gender.feminine));
        expect(Gender.fromString('n'), equals(Gender.neuter));
        expect(Gender.fromString('common'), equals(Gender.common));
      });

      test('should return null for unknown values', () {
        expect(Gender.fromString('UNKNOWN'), isNull);
        expect(Gender.fromString('X'), isNull);
        expect(Gender.fromString(''), isNull);
      });

      test('should handle null input', () {
        expect(Gender.fromString(null), isNull);
      });
    });

    group('toCanonicalString', () {
      test('should convert to canonical string representation', () {
        expect(Gender.masculine.toCanonicalString(), equals('M'));
        expect(Gender.feminine.toCanonicalString(), equals('F'));
        expect(Gender.neuter.toCanonicalString(), equals('N'));
        expect(Gender.common.toCanonicalString(), equals('COMMON'));
      });

      test('should be consistent with fromString for canonical values', () {
        for (final gender in Gender.values) {
          final canonical = gender.toCanonicalString();
          expect(Gender.fromString(canonical), equals(gender));
        }
      });
    });

    group('toDisplayString', () {
      test('should convert to display string with German articles', () {
        expect(Gender.masculine.toDisplayString(), equals('der (m.)'));
        expect(Gender.feminine.toDisplayString(), equals('die (f.)'));
        expect(Gender.neuter.toDisplayString(), equals('das (n.)'));
        expect(Gender.common.toDisplayString(), equals('common'));
      });

      test('should provide useful display format for German learners', () {
        // These strings should include the definite article to help learners
        expect(Gender.masculine.toDisplayString(), contains('der'));
        expect(Gender.feminine.toDisplayString(), contains('die'));
        expect(Gender.neuter.toDisplayString(), contains('das'));
      });
    });

    group('German article mapping', () {
      test('should provide correct definite articles for German nouns', () {
        // This tests the German-specific functionality
        expect(Gender.masculine.toDisplayString(), startsWith('der'));
        expect(Gender.feminine.toDisplayString(), startsWith('die'));
        expect(Gender.neuter.toDisplayString(), startsWith('das'));
      });
    });
  });
}