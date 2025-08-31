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
      // This test would need to be run with different build configurations
      // For now, we test the logic with debug mode
      final isDev = VersionService.isDevelopmentVersion();

      // In debug mode, should return true
      expect(isDev, isTrue);
    });

    test('should handle empty version gracefully', () {
      // Act
      final version = VersionService.getAppVersion();

      // Assert
      expect(version, isNotEmpty);
      expect(version, isNotNull);
    });
  });
}
