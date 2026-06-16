import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

/// Ergonomic accessors used throughout the UI.
extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Simple responsive breakpoints.
  bool get isTablet => screenWidth >= 600;
  bool get isLargeTablet => screenWidth >= 900;

  /// Grid columns for the home feature grid.
  int get featureGridColumns {
    if (screenWidth >= 900) return 4;
    if (screenWidth >= 600) return 3;
    return 2;
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 0–100 score → an encouraging band label.
String scoreBand(int score) {
  if (score >= 90) return 'Legendary';
  if (score >= 80) return 'Glowing';
  if (score >= 70) return 'Strong';
  if (score >= 60) return 'Bright';
  if (score >= 50) return 'Balanced';
  return 'Rising';
}
