import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';

/// Wordmark + glyph used in app bars and onboarding.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.fontSize = 22, this.showGlyph = true});

  final double fontSize;
  final bool showGlyph;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showGlyph) ...<Widget>[
          Container(
            width: fontSize * 1.4,
            height: fontSize * 1.4,
            decoration: const BoxDecoration(
              gradient: AppGradients.aura,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome,
                color: Colors.white, size: fontSize * 0.85),
          ),
          const SizedBox(width: 10),
        ],
        ShaderMask(
          shaderCallback: (Rect bounds) =>
              AppGradients.aura.createShader(bounds),
          child: Text(
            'Dream AI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
