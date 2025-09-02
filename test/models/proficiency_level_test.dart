import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/models/proficiency_level.dart';

void main() {
  group('ProficiencyLevel', () {
    group('fromString', () {
      test('should parse all CEFR levels correctly', () {
        expect(ProficiencyLevel.fromString('A1'), equals(ProficiencyLevel.a1));
        expect(ProficiencyLevel.fromString('A2'), equals(ProficiencyLevel.a2));
        expect(ProficiencyLevel.fromString('B1'), equals(ProficiencyLevel.b1));
        expect(ProficiencyLevel.fromString('B2'), equals(ProficiencyLevel.b2));
        expect(ProficiencyLevel.fromString('C1'), equals(ProficiencyLevel.c1));
        expect(ProficiencyLevel.fromString('C2'), equals(ProficiencyLevel.c2));
      });

      test('should be case insensitive', () {
        expect(ProficiencyLevel.fromString('a1'), equals(ProficiencyLevel.a1));
        expect(ProficiencyLevel.fromString('b2'), equals(ProficiencyLevel.b2));
        expect(ProficiencyLevel.fromString('c1'), equals(ProficiencyLevel.c1));
      });

      test('should return null for unknown values', () {
        expect(ProficiencyLevel.fromString('UNKNOWN'), isNull);
        expect(ProficiencyLevel.fromString('D1'), isNull);
        expect(ProficiencyLevel.fromString(''), isNull);
      });

      test('should handle null input', () {
        expect(ProficiencyLevel.fromString(null), isNull);
      });
    });

    group('toDisplayString', () {
      test('should convert to display string representation', () {
        expect(ProficiencyLevel.a1.toDisplayString(), equals('A1'));
        expect(ProficiencyLevel.a2.toDisplayString(), equals('A2'));
        expect(ProficiencyLevel.b1.toDisplayString(), equals('B1'));
        expect(ProficiencyLevel.b2.toDisplayString(), equals('B2'));
        expect(ProficiencyLevel.c1.toDisplayString(), equals('C1'));
        expect(ProficiencyLevel.c2.toDisplayString(), equals('C2'));
      });

      test('should be consistent with fromString', () {
        for (final level in ProficiencyLevel.values) {
          final display = level.toDisplayString();
          expect(ProficiencyLevel.fromString(display), equals(level));
        }
      });
    });

    group('ordering', () {
      test('should follow logical CEFR progression', () {
        final levels = [
          ProficiencyLevel.a1,
          ProficiencyLevel.a2,
          ProficiencyLevel.b1,
          ProficiencyLevel.b2,
          ProficiencyLevel.c1,
          ProficiencyLevel.c2,
        ];

        for (int i = 0; i < levels.length; i++) {
          expect(levels[i].index, equals(i));
        }
      });
    });
  });
}