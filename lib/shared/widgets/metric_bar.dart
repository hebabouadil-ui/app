import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';

/// A labeled animated progress bar for a single result metric (0–100).
class MetricBar extends StatelessWidget {
  const MetricBar({
    super.key,
    required this.label,
    required this.value,
    this.gradientName = 'aura',
  });

  final String label;
  final int value;
  final String gradientName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label, style: theme.textTheme.bodyMedium),
              Text('$value',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: value / 100),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (BuildContext context, double v, _) {
                    return FractionallySizedBox(
                      widthFactor: v.clamp(0.0, 1.0),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: AppGradients.byName(gradientName),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
