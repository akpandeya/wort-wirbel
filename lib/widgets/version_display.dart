import 'package:flutter/material.dart';
import '../services/version_service.dart';

/// Widget to display application version information
class VersionDisplay extends StatelessWidget {
  final bool showPrefix;
  final TextStyle? textStyle;
  final Color? color;

  const VersionDisplay({
    super.key,
    this.showPrefix = true,
    this.textStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final version = showPrefix
        ? VersionService.getVersionDisplay()
        : VersionService.getAppVersion();

    final isDevelopment = VersionService.isDevelopmentVersion();

    return Text(
      version,
      style: textStyle?.copyWith(
        color: color ?? (isDevelopment ? Colors.orange : Colors.grey),
      ) ?? TextStyle(
        fontSize: 12,
        color: color ?? (isDevelopment ? Colors.orange : Colors.grey),
      ),
    );
  }
}
