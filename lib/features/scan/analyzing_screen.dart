import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_args.dart';
import '../../data/models/analysis_type.dart';
import '../../data/models/face_features.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/aura_orb.dart';
import '../../shared/widgets/gradient_background.dart';

/// Runs on-device face detection (if needed) + result generation while showing
/// a pleasant animation, then shows an interstitial and routes to the result.
class AnalyzingScreen extends ConsumerStatefulWidget {
  const AnalyzingScreen({super.key, required this.args});

  final AnalyzingArgs args;

  @override
  ConsumerState<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends ConsumerState<AnalyzingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final AnalyzingArgs args = widget.args;
    // Keep the animation on screen for a minimum, satisfying duration.
    final Future<void> minDelay =
        Future<void>.delayed(const Duration(milliseconds: 1900));

    final AnalysisController controller = ref.read(analysisControllerProvider);
    final faceService = ref.read(faceDetectionServiceProvider);

    AnalysisOutcome outcome;
    if (args.type == AnalysisType.friendshipCompatibility) {
      final FaceFeatures a = args.imagePath == null
          ? const FaceFeatures.none()
          : await faceService.analyzeFile(args.imagePath!);
      final FaceFeatures b = args.secondImagePath == null
          ? const FaceFeatures.none()
          : await faceService.analyzeFile(args.secondImagePath!);
      outcome = await controller.runFriendship(
        a: a,
        b: b,
        countsAgainstQuota: args.countsAgainstQuota,
      );
    } else if (args.type.scanKind == ScanKind.hand) {
      outcome = await controller.runPalm(
        imagePath: args.imagePath ?? '',
        countsAgainstQuota: args.countsAgainstQuota,
      );
    } else {
      final FaceFeatures features = args.imagePath == null
          ? const FaceFeatures.none()
          : await faceService.analyzeFile(args.imagePath!);
      outcome = await controller.run(
        type: args.type,
        features: features,
        countsAgainstQuota: args.countsAgainstQuota,
      );
    }

    await minDelay;
    if (!mounted) return;

    // Interstitial after result generation (frequency-capped, premium-aware).
    final config = ref.read(appConfigProvider);
    if (config.interstitialAfterResult &&
        !ref.read(settingsProvider).adsRemoved) {
      await ref.read(adsServiceProvider).maybeShowInterstitial();
    }
    if (!mounted) return;

    context.pushReplacement(AppRoutes.result, extra: outcome);
  }

  String _scanningLabel(BuildContext context) {
    switch (widget.args.type.scanKind) {
      case ScanKind.hand:
        return context.l10n.scanningPalm;
      case ScanKind.face:
        return context.l10n.scanningFace;
      case ScanKind.none:
        return context.l10n.analyzingSubtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Orb + sweeping "AI scan" line clipped to the circle.
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AuraOrb(
                    size: 200,
                    gradientName: widget.args.type.gradient,
                    child: Icon(widget.args.type.icon,
                        size: 64, color: Colors.white),
                  ),
                  SizedBox(
                    width: 196,
                    height: 196,
                    child: ClipOval(child: const _ScanLine()),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(l10n.analyzingTitle, style: context.textTheme.headlineSmall)
                  .animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 700.ms)
                  .then()
                  .fadeOut(delay: 700.ms, duration: 700.ms),
              const SizedBox(height: 8),
              Text(_scanningLabel(context),
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

/// A glowing horizontal line that sweeps up and down — the "AI scanning" effect.
class _ScanLine extends StatelessWidget {
  const _ScanLine();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 3,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              Colors.transparent,
              Colors.white,
              Colors.transparent,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.white.withValues(alpha: 0.8), blurRadius: 12),
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: -92, end: 92, duration: 1300.ms, curve: Curves.easeInOut),
    );
  }
}
