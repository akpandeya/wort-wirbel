import 'package:flutter/foundation.dart';

/// Service to manage application version information
class VersionService {
  static const String _fallbackVersion = '1.0.0';

  /// Get the application version from build-time configuration
  static String getAppVersion() {
    // This will be injected at build time via --dart-define=APP_VERSION
    const String buildVersion = String.fromEnvironment('APP_VERSION');

    if (buildVersion.isNotEmpty) {
      return buildVersion;
    }

    // Fallback to pubspec version in debug mode
    if (kDebugMode) {
      return '$_fallbackVersion-debug';
    }

    return _fallbackVersion;
  }

  /// Get version display string for UI
  static String getVersionDisplay() {
    final version = getAppVersion();
    return 'v$version';
  }

  /// Check if running a development version
  static bool isDevelopmentVersion() {
    final version = getAppVersion();
    return version.contains('debug') || version.contains('development');
  }
}
