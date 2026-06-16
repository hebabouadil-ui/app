import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../data/models/analysis_result.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/service_providers.dart';
import '../../shared/widgets/disclaimer_banner.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/metric_bar.dart';
import 'widgets/share_card.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, required this.result, required this.delta});

  final AnalysisResult result;
  final GamificationDelta delta;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  final ScreenshotController _shot = ScreenshotController();
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logScreen('result');
      _celebrate(widget.delta);
    });
  }

  void _celebrate(GamificationDelta delta) {
    if (!mounted || !delta.hasCelebration) return;
    final String message = delta.leveledUp
        ? context.l10n.celebrationLevelUp(delta.newLevel)
        : delta.newBadges.isNotEmpty
            ? '${context.l10n.celebrationBadge} ${delta.newBadges.first.emoji}'
            : context.l10n.celebrationStreak;
    context.showSnack(message);
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final Uint8List? bytes = await _shot.capture(
        pixelRatio: 3,
        delay: const Duration(milliseconds: 40),
      );
      if (bytes == null || !mounted) return;
      final String text =
          'My ${widget.result.title} on Dream AI ✨ Score: ${widget.result.primaryScore}! '
          'Try yours — it\'s just for fun. #DreamAI';
      final bool ok = await ref
          .read(shareServiceProvider)
          .shareImage(bytes: bytes, text: text);
      if (ok && mounted) {
        ref.read(analyticsServiceProvider).logShare(widget.result.type.id, 'sheet');
        final GamificationDelta delta =
            await ref.read(gamificationProvider.notifier).recordShare();
        await ref.read(reviewServiceProvider).maybeRequestReview();
        if (mounted) _celebrate(delta);
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final AnalysisResult r = widget.result;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: <Widget>[
                // Captured for sharing.
                Screenshot(
                  controller: _shot,
                  child: ShareableResultCard(result: r),
                ),
                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(r.summary, style: context.textTheme.bodyLarge),
                      if (r.traits.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        Text(l10n.resultTraits,
                            style: context.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            for (final String t in r.traits)
                              Chip(label: Text(t)),
                          ],
                        ),
                      ],
                      if (r.metrics.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        for (final metric in r.metrics)
                          MetricBar(
                            label: metric.label,
                            value: metric.value,
                            gradientName: r.gradientName,
                          ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _sharing ? null : _share,
                        icon: _sharing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.ios_share_rounded),
                        label: Text(l10n.resultShare),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.go(AppRoutes.home),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.resultAgain),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const DisclaimerBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
