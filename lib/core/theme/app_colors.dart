import 'package:flutter/material.dart';

/// Centralized color palette for Dream AI.
///
/// The brand leans into a dreamy, "aura" aesthetic: deep indigo backgrounds
/// with vibrant violet → pink → cyan accents.
abstract final class AppColors {
  // Brand accents
  static const Color violet = Color(0xFF7C5CFF);
  static const Color indigo = Color(0xFF5B6CFF);
  static const Color pink = Color(0xFFFF6BD6);
  static const Color magenta = Color(0xFFE85CFF);
  static const Color cyan = Color(0xFF49E0FF);
  static const Color teal = Color(0xFF2DE0C0);
  static const Color amber = Color(0xFFFFC85C);
  static const Color coral = Color(0xFFFF7A6B);

  // Semantic
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFF87171);

  // Dark surfaces
  static const Color darkBackground = Color(0xFF0C0A1F);
  static const Color darkSurface = Color(0xFF161334);
  static const Color darkSurfaceHigh = Color(0xFF211C46);
  static const Color darkOnSurface = Color(0xFFEDEBFF);
  static const Color darkOnSurfaceMuted = Color(0xFF9A95C7);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF6F4FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFEDE9FF);
  static const Color lightOnSurface = Color(0xFF1B1736);
  static const Color lightOnSurfaceMuted = Color(0xFF6B6694);

  // Glass overlay used for cards on gradient backgrounds.
  static const Color glassLight = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);
}
