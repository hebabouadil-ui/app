import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';

/// A full-screen backdrop wash that adapts to light/dark. Place behind page
/// content for the signature "dreamy" look.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark ? AppGradients.darkBackdrop : AppGradients.lightBackdrop,
      ),
      child: child,
    );
  }
}
