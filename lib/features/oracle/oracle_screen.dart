import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/oracle_content.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/gradient_background.dart';

/// A sticky, repeatable "pull a card" ritual: tap the deck to reveal a rich,
/// localized message, then draw again. Keeps users engaged beyond face/palm.
class OracleScreen extends ConsumerStatefulWidget {
  const OracleScreen({super.key});

  @override
  ConsumerState<OracleScreen> createState() => _OracleScreenState();
}

class _OracleScreenState extends ConsumerState<OracleScreen> {
  static const List<String> _gradients = <String>[
    'aura', 'royal', 'dusk', 'ocean', 'romance', 'sunrise',
  ];
  final math.Random _rng = math.Random();
  int _index = -1; // -1 = not drawn yet
  int _drawCount = 0;

  void _draw(int len) {
    setState(() {
      _index = _rng.nextInt(len);
      _drawCount++;
    });
    if (_drawCount == 1) {
      ref.read(reviewServiceProvider).recordPositiveInteraction();
    }
    ref.read(analyticsServiceProvider).logScreen('oracle_draw');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String lang =
        ref.watch(settingsProvider.select((SettingsState s) => s.locale))
                ?.languageCode ??
            WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final List<({String theme, String text})> cards =
        OracleContent.cards(lang);
    final bool revealed = _index >= 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.oracleTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text(l10n.oracleIntro,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: revealed
                        ? _RevealedCard(
                            key: ValueKey<int>(_drawCount),
                            card: cards[_index],
                            gradientName: _gradients[_index % _gradients.length],
                          )
                        : _FaceDownCard(onTap: () => _draw(cards.length)),
                  ),
                ),
                const SizedBox(height: 16),
                if (revealed)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _draw(cards.length),
                      icon: const Icon(Icons.style_rounded),
                      label: Text(l10n.oracleDrawAgain),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaceDownCard extends StatelessWidget {
  const _FaceDownCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        height: 360,
        decoration: BoxDecoration(
          gradient: AppGradients.dusk,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white24, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('✨', style: TextStyle(fontSize: 72))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 1600.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 18),
            Text(context.l10n.oracleTapReveal,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: Colors.white)),
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: -6, end: 6, duration: 2400.ms, curve: Curves.easeInOut),
    );
  }
}

class _RevealedCard extends StatelessWidget {
  const _RevealedCard({super.key, required this.card, required this.gradientName});
  final ({String theme, String text}) card;
  final String gradientName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      constraints: const BoxConstraints(minHeight: 360),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.byName(gradientName),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppGradients.byName(gradientName).colors.first.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(card.theme,
                style: context.textTheme.labelLarge
                    ?.copyWith(color: Colors.white, letterSpacing: 1)),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          const SizedBox(height: 16),
          Text(
            card.text,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium
                ?.copyWith(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    )
        .animate(key: key)
        .fadeIn(duration: 350.ms)
        .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), curve: Curves.easeOutBack)
        .shimmer(delay: 250.ms, duration: 1100.ms, color: Colors.white24);
  }
}
