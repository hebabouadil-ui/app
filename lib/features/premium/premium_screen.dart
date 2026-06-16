import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../data/services/purchase_service.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';

class _Offer {
  const _Offer(this.id, this.emoji, this.titleKey, this.descKey);
  final String id;
  final String emoji;
  final String Function(BuildContext) titleKey;
  final String Function(BuildContext) descKey;
}

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final config = ref.read(appConfigProvider);
      ref.read(analyticsServiceProvider).logPaywallView(config.paywallVariant);
    });
  }

  List<_Offer> get _offers => <_Offer>[
        _Offer(ProductIds.premiumUnlimited, '✨',
            (c) => c.l10n.premiumUnlimited, (c) => c.l10n.premiumSubtitle),
        _Offer(ProductIds.adFree, '🚫',
            (c) => c.l10n.premiumAdFree, (c) => 'Enjoy a clean, ad-free experience'),
        _Offer(ProductIds.compatibilityPack, '💞',
            (c) => c.l10n.premiumCompat, (c) => 'Deeper friendship & romance reports'),
        _Offer(ProductIds.themePack, '🎨',
            (c) => c.l10n.premiumThemes, (c) => 'Unlock all exclusive themes'),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final SettingsState settings = ref.watch(settingsProvider);
    final purchases = ref.read(purchaseServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppGradients.royal,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: <Widget>[
                    const Text('👑', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    Text(l10n.premiumTitle,
                        style: context.textTheme.headlineSmall
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(l10n.premiumSubtitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              for (final _Offer offer in _offers)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OfferTile(
                    offer: offer,
                    owned: settings.ownedProducts.contains(offer.id) ||
                        (_removesAds(offer.id) && settings.adsRemoved),
                    price: purchases.productById(offer.id)?.price,
                    onBuy: () => purchases.buy(offer.id),
                  ),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => purchases.restore(),
                child: Text(l10n.premiumRestore),
              ),
              const SizedBox(height: 8),
              Text(
                'Payment is charged to your store account. One-time purchases, '
                'no subscription. Restore anytime on a new device.',
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

bool _removesAds(String id) => ProductIds.removesAds.contains(id);

class _OfferTile extends StatelessWidget {
  const _OfferTile({
    required this.offer,
    required this.owned,
    required this.price,
    required this.onBuy,
  });

  final _Offer offer;
  final bool owned;
  final String? price;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: <Widget>[
          Text(offer.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(offer.titleKey(context),
                    style: context.textTheme.titleMedium),
                Text(offer.descKey(context),
                    style: context.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          owned
              ? Chip(
                  label: const Text('Owned'),
                  backgroundColor:
                      context.colors.primary.withValues(alpha: 0.15),
                )
              : FilledButton(
                  onPressed: onBuy,
                  child: Text(price ?? context.l10n.premiumUnlock),
                ),
        ],
      ),
    );
  }
}
