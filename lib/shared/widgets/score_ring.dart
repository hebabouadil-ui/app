import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';

/// Animated circular gauge showing a 0–100 score with a gradient sweep.
class ScoreRing extends StatelessWidget {
  const ScoreRing({
    super.key,
    required this.score,
    this.size = 160,
    this.gradientName = 'aura',
    this.label,
    this.emoji,
  });

  final int score;
  final double size;
  final String gradientName;
  final String? label;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score / 100),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: value,
              gradient: AppGradients.byName(gradientName),
              trackColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (emoji != null)
                    Text(emoji!, style: TextStyle(fontSize: size * 0.18)),
                  Text(
                    '${(value * 100).round()}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: size * 0.28,
                    ),
                  ),
                  if (label != null)
                    Text(label!, style: theme.textTheme.labelMedium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.gradient,
    required this.trackColor,
  });

  final double progress;
  final Gradient gradient;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.width / 2) - 10;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    const double startAngle = -math.pi / 2;
    final double sweep = 2 * math.pi * progress;

    final Paint track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);
    canvas.drawArc(rect, startAngle, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.gradient != gradient;
}
