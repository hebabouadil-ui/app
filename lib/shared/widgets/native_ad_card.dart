import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';

/// A native ad rendered with AdMob's built-in **medium template** (no custom
/// platform factory required). For premium users it shows nothing; if the ad
/// fails to load it gracefully falls back to an in-house "Go Premium" promo so
/// the feed never shows an empty hole.
class NativeAdCard extends ConsumerStatefulWidget {
  const NativeAdCard({super.key});

  @override
  ConsumerState<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends ConsumerState<NativeAdCard> {
  NativeAd? _ad;
  bool _loaded = false;
  bool _failed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad == null && !ref.read(settingsProvider).adsRemoved) {
      _load();
    }
  }

  void _load() {
    final adsService = ref.read(adsServiceProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final NativeAd ad = NativeAd(
      adUnitId: adsService.nativeAdUnitId,
      request: adsService.request,
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor:
            isDark ? const Color(0xFF161334) : const Color(0xFFFFFFFF),
        cornerRadius: AppTheme.radius,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: const Color(0xFF7C5CFF),
          size: 15,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          if (mounted) setState(() => _failed = true);
        },
      ),
    )..load();
    _ad = ad;
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(settingsProvider).adsRemoved) return const SizedBox.shrink();
    if (_failed) return const _PremiumPromo();
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(minHeight: 300, maxHeight: 360),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: AdWidget(ad: _ad!),
    );
  }
}

/// In-house fallback promo (also a soft monetization nudge).
class _PremiumPromo extends StatelessWidget {
  const _PremiumPromo();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => context.push(AppRoutes.premium),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppGradients.dusk,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: <Widget>[
            const Text('✨', style: TextStyle(fontSize: 34)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Go ad-free with Premium',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Unlimited analyses + exclusive themes',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
