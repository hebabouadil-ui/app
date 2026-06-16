import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_gradients.dart';

/// A soft, glowing animated orb used as a hero/decorative element on
/// onboarding and result screens. Pure code — no asset dependency.
class AuraOrb extends StatelessWidget {
  const AuraOrb({
    super.key,
    this.size = 200,
    this.gradientName = 'aura',
    this.child,
  });

  final double size;
  final String gradientName;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = AppGradients.byName(gradientName);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Glow halo
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppGradients.byName(gradientName)
                      .colors
                      .first
                      .withValues(alpha: 0.5),
                  blurRadius: 60,
                  spreadRadius: 10,
                ),
              ],
            ),
          )
              .animate(onPlay: (AnimationController c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.92, 0.92),
                end: const Offset(1.04, 1.04),
                duration: 2600.ms,
                curve: Curves.easeInOut,
              )
              .shimmer(duration: 2600.ms, color: Colors.white24),
          if (child != null) child!,
        ],
      ),
    );
  }
}
