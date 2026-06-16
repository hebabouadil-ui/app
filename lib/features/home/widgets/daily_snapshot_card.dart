import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/daily_prediction.dart';
import '../../../providers/predictions_provider.dart';

/// Hero card on the home screen summarizing today's prediction.
class DailySnapshotCard extends ConsumerWidget {
  const DailySnapshotCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DailyPrediction p = ref.watch(todayPredictionProvider);
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => context.go(AppRoutes.predictions),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppGradients.dusk,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(l10n.homeTodaySnapshot,
                    style: context.textTheme.titleMedium
                        ?.copyWith(color: Colors.white)),
                const Spacer(),
                Text(p.moodEmoji, style: const TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                _BigStat(value: p.overall, label: l10n.predMood.split(' ').first),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      _MiniStat(label: l10n.predLuck, value: p.luck),
                      _MiniStat(label: l10n.predEnergy, value: p.energy),
                      _MiniStat(
                          label: l10n.predProductivity, value: p.productivity),
                      _MiniStat(label: l10n.predSocial, value: p.social),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.format_quote_rounded, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(p.message,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({required this.value, required this.label});
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('$value',
              style: context.textTheme.headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          Text(label,
              style:
                  context.textTheme.labelSmall?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 84,
            child: Text(label,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: Colors.white70)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$value',
              style: context.textTheme.labelSmall
                  ?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
