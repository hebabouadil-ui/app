import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography built on Google Fonts so no font binaries need to be bundled.
///
/// `Sora` is used for display/headings (geometric, modern) and `Inter` for
/// body copy (highly legible at small sizes).
abstract final class AppTypography {
  static TextTheme textTheme(Color onSurface, Color muted) {
    final TextTheme base = ThemeData.light().textTheme;
    final TextTheme display = GoogleFonts.soraTextTheme(base);
    final TextTheme body = GoogleFonts.interTextTheme(base);

    return TextTheme(
      displayLarge: display.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: onSurface,
        letterSpacing: -1,
      ),
      displayMedium: display.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: onSurface,
        letterSpacing: -0.5,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      headlineSmall: display.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleLarge: display.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleMedium: body.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: body.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      bodyLarge: body.bodyLarge?.copyWith(color: onSurface, height: 1.5),
      bodyMedium: body.bodyMedium?.copyWith(color: onSurface, height: 1.5),
      bodySmall: body.bodySmall?.copyWith(color: muted, height: 1.4),
      labelLarge: body.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
        letterSpacing: 0.2,
      ),
      labelMedium: body.labelMedium?.copyWith(color: muted),
      labelSmall: body.labelSmall?.copyWith(color: muted, letterSpacing: 0.4),
    );
  }
}
