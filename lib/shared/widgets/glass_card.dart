import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Frosted-glass style card used across the app. On dark backgrounds it shows a
/// subtle translucent fill + border; on light it falls back to the surface.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.gradient,
    this.borderRadius,
    this.blur = 14,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final BorderRadius radius =
        borderRadius ?? BorderRadius.circular(AppTheme.radius);

    final Widget content = Padding(padding: padding, child: child);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Ink(
              decoration: BoxDecoration(
                gradient: gradient,
                color: gradient != null
                    ? null
                    : (isDark
                        ? AppColors.glassLight
                        : Theme.of(context).colorScheme.surface),
                borderRadius: radius,
                border: Border.all(
                  color: isDark
                      ? AppColors.glassBorder
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
