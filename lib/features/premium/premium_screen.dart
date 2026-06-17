import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../data/services/purchase_service.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/gradient_background.dart';

/// A single one-time "Dream AI Pro" unlock. Most of the app stays free; Pro
/// unlocks the advanced readings (Palm Reading is the headline) and removes ads.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  static const List<({String emoji, String title, String sub})> _perks = [
    (emoji: '🖐️', title: 'AI Palm Reading', sub: 'Scan your hand for a deep reading'),
    (emoji: '👑', title: 'Leadership & Romance', sub: 'Unlock every advanced face reading'),
    (emoji: '⭐', title: 'Celebrity Match & Friendship', sub: 'See who you share star energy with'),
    (emoji: '🚫', title: 'No ads', sub: 'A clean, uninterrupted experience'),
    (emoji: '♾️', title: 'Unlimited readings', sub: 'No daily limit, ever'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(analyticsServiceProvider)
          .logPaywallView(ref.read(appConfigProvider).paywallVariant);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bool isPro = ref.watch(settingsProvider).isPro;
    final purchases = ref.read(purchaseServiceProvider);
    final String? price = purchases.productById(ProductIds.pro)?.price;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: AppGradients.royal,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: <Widget>[
                    const Text('👑', style: TextStyle(fontSize: 60))
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.12, 1.12),
                          duration: 1600.ms,
                          curve: Curves.easeInOut,
                        ),
                    const SizedBox(height: 12),
                    Text('Dream AI Pro',
                        style: context.textTheme.headlineMedium
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text('One payment. Unlock everything, forever.',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70)),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 22),
              for (int i = 0; i < _perks.length; i++)
                _PerkRow(perk: _perks[i])
                    .animate(delay: (120 * i).ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.15, end: 0),
              const SizedBox(height: 24),
              if (isPro)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.verified_rounded, color: Color(0xFF34D399)),
                      const SizedBox(width: 10),
                      Text("You're Pro — enjoy! ✨",
                          style: context.textTheme.titleMedium),
                    ],
                  ),
                )
              else ...<Widget>[
                FilledButton(
                  onPressed: () => purchases.buy(ProductIds.pro),
                  child: Text(price == null
                      ? '${l10n.premiumUnlock} Dream AI Pro'
                      : 'Unlock Pro — $price'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => purchases.restore(),
                  child: Text(l10n.premiumRestore),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'One-time purchase, no subscription. Payment is charged to your '
                'store account. Restore anytime on a new device.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerkRow extends StatelessWidget {
  const _PerkRow({required this.perk});
  final ({String emoji, String title, String sub}) perk;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: <Widget>[
          Text(perk.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(perk.title, style: context.textTheme.titleMedium),
                Text(perk.sub, style: context.textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399)),
        ],
      ),
    );
  }
}
