import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/daily_prediction.dart';
import '../../providers/predictions_provider.dart';
import '../../providers/service_providers.dart';
import '../../shared/widgets/disclaimer_banner.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/metric_bar.dart';
import '../../shared/widgets/section_header.dart';

class PredictionsScreen extends ConsumerStatefulWidget {
  const PredictionsScreen({super.key});

  @override
  ConsumerState<PredictionsScreen> createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends ConsumerState<PredictionsScreen> {
  final ScreenshotController _shot = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(analyticsServiceProvider).logScreen('predictions'));
  }

  Future<void> _share(DailyPrediction p) async {
    final Uint8List? bytes =
        await _shot.capture(pixelRatio: 3, delay: const Duration(milliseconds: 40));
    if (bytes == null || !mounted) return;
    final bool ok = await ref.read(shareServiceProvider).shareImage(
          bytes: bytes,
          text: 'My Dream AI forecast today: ${p.moodLabel} ${p.moodEmoji} '
              '(luck ${p.luck}/100). What\'s yours? #DreamAI',
        );
    if (ok && mounted) {
      ref.read(analyticsServiceProvider).logShare('daily_prediction', 'sheet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final DailyPrediction today = ref.watch(todayPredictionProvider);
    final List<DailyPrediction> upcoming =
        ref.watch(upcomingPredictionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.predictionsTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              Screenshot(
                controller: _shot,
                child: _HeroCard(prediction: today),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MetricBar(
                        label: l10n.predLuck,
                        value: today.luck,
                        gradientName: 'sunrise'),
                    MetricBar(
                        label: l10n.predEnergy,
                        value: today.energy,
                        gradientName: 'romance'),
                    MetricBar(
                        label: l10n.predProductivity,
                        value: today.productivity,
                        gradientName: 'ocean'),
                    MetricBar(
                        label: l10n.predSocial,
                        value: today.social,
                        gradientName: 'royal'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _ChipStat(
                      icon: Icons.palette_rounded,
                      label: l10n.predLuckyColor,
                      value: today.luckyColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChipStat(
                      icon: Icons.tag_rounded,
                      label: l10n.predLuckyNumber,
                      value: '${today.luckyNumber}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GlassCard(
                gradient: AppGradients.ocean,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l10n.featurePositiveTitle,
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('“${today.affirmation}”',
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _share(today),
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(l10n.resultShare),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.predUpcoming),
              for (final DailyPrediction p in upcoming.skip(1))
                _UpcomingRow(prediction: p),
              const SizedBox(height: 20),
              const DisclaimerBanner(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.prediction});
  final DailyPrediction prediction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.aura,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        children: <Widget>[
          Text(DateFormat.yMMMMEEEEd().format(prediction.date),
              style: context.textTheme.labelMedium
                  ?.copyWith(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(prediction.moodEmoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 8),
          Text(prediction.moodLabel,
              style: context.textTheme.headlineSmall
                  ?.copyWith(color: Colors.white)),
          const SizedBox(height: 6),
          Text('${l10n.predMood}: ${prediction.overall}/100',
              style:
                  context.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          const SizedBox(height: 14),
          Text(prediction.message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _ChipStat extends StatelessWidget {
  const _ChipStat(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: <Widget>[
          Icon(icon, color: context.colors.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: context.textTheme.labelSmall),
              Text(value, style: context.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({required this.prediction});
  final DailyPrediction prediction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: <Widget>[
            Text(prediction.moodEmoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(DateFormat.MMMEd().format(prediction.date),
                      style: context.textTheme.titleSmall),
                  Text(prediction.moodLabel,
                      style: context.textTheme.bodySmall),
                ],
              ),
            ),
            Text('${prediction.overall}',
                style: context.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
