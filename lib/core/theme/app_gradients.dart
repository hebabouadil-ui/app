import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable gradients. Each feature has its own signature gradient so cards and
/// share images feel distinct and recognizable.
abstract final class AppGradients {
  static const LinearGradient aura = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.violet, AppColors.magenta, AppColors.cyan],
  );

  static const LinearGradient dusk = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.indigo, AppColors.violet],
  );

  static const LinearGradient sunrise = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.amber, AppColors.coral, AppColors.pink],
  );

  static const LinearGradient ocean = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.cyan, AppColors.teal],
  );

  static const LinearGradient romance = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.pink, AppColors.coral],
  );

  static const LinearGradient royal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.indigo, AppColors.magenta],
  );

  /// Background wash for the dark scaffold.
  static const RadialGradient darkBackdrop = RadialGradient(
    center: Alignment(-0.6, -0.9),
    radius: 1.6,
    colors: [Color(0xFF211C46), AppColors.darkBackground],
  );

  /// Background wash for the light scaffold.
  static const RadialGradient lightBackdrop = RadialGradient(
    center: Alignment(-0.6, -0.9),
    radius: 1.6,
    colors: [Color(0xFFFFFFFF), AppColors.lightBackground],
  );

  /// Maps a gradient name (stored with each feature/result) to a gradient.
  static LinearGradient byName(String name) {
    switch (name) {
      case 'aura':
        return aura;
      case 'dusk':
        return dusk;
      case 'sunrise':
        return sunrise;
      case 'ocean':
        return ocean;
      case 'romance':
        return romance;
      case 'royal':
        return royal;
      default:
        return aura;
    }
  }
}
