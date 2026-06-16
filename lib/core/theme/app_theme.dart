import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Builds the light and dark [ThemeData] for the app.
abstract final class AppTheme {
  static const double radius = 22;
  static const double radiusSmall = 14;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color onSurface =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final Color muted =
        isDark ? AppColors.darkOnSurfaceMuted : AppColors.lightOnSurfaceMuted;

    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.violet,
      onPrimary: Colors.white,
      secondary: AppColors.pink,
      onSecondary: Colors.white,
      tertiary: AppColors.cyan,
      onTertiary: const Color(0xFF06283D),
      error: AppColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest:
          isDark ? AppColors.darkSurfaceHigh : AppColors.lightSurfaceHigh,
      outline: muted.withValues(alpha: 0.4),
    );

    final TextTheme textTheme = AppTypography.textTheme(onSurface, muted);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: onSurface,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.violet,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size.fromHeight(56),
          side: BorderSide(color: muted.withValues(alpha: 0.4)),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.violet),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        labelStyle: textTheme.labelMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.violet,
        unselectedItemColor: muted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.surfaceContainerHighest,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.violet),
      dividerTheme: DividerThemeData(
        color: muted.withValues(alpha: 0.15),
        space: 1,
      ),
    );
  }
}
