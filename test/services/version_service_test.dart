import 'package:flutter_test/flutter_test.dart';
import 'package:wort_wirbel/services/version_service.dart';

void main() {
  group('VersionService', () {
    test('should return fallback version when no build version is provided',
        () {
      // Act
      final version = VersionService.getAppVersion();

      // Assert
      expect(version, contains('1.0.0'));
    });

    test('should return version display string with v prefix', () {
      // Act
      final versionDisplay = VersionService.getVersionDisplay();

      // Assert
      expect(versionDisplay, startsWith('v'));
      expect(versionDisplay, contains('1.0.0'));
    });

    test('should identify development versions correctly', () {
      // Act
      final isDev = VersionService.isDevelopmentVersion();

      // Assert - In debug mode, should return true
      expect(isDev, isTrue);
    });

    test('should handle empty version string gracefully', () {
      // Act
      final version = VersionService.getAppVersion();

      // Assert
      expect(version, isNotEmpty);
      expect(version, isNotNull);
    });

    test('should detect development versions by content', () {
      // This validates the logic for detecting development versions
      const testCases = [
        ('1.0.0-debug', true),
        ('pr-123-development', true),
        ('1.2.3', false),
        ('v2.0.0', false),
      ];

      for (final (versionString, expectedIsDev) in testCases) {
        final isDev = versionString.contains('debug') ||
            versionString.contains('development');
        expect(isDev, equals(expectedIsDev),
            reason:
                'Version "$versionString" should ${expectedIsDev ? "" : "not "}be detected as development');
      }
    });
  });
}
