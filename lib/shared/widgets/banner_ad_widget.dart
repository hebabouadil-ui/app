import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';

/// An anchored adaptive banner. Renders nothing for premium/ad-free users or
/// until the ad finishes loading (so layout never jumps to a blank box).
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ad == null && !ref.read(settingsProvider).adsRemoved) {
      _load();
    }
  }

  Future<void> _load() async {
    final adsService = ref.read(adsServiceProvider);
    final double width = MediaQuery.sizeOf(context).width;
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      width.truncate(),
    );

    final BannerAd ad = BannerAd(
      adUnitId: adsService.bannerAdUnitId,
      size: size ?? AdSize.banner,
      request: adsService.request,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          if (mounted) setState(() => _loaded = false);
        },
      ),
    );
    await ad.load();
    if (mounted) _ad = ad;
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(settingsProvider).adsRemoved) return const SizedBox.shrink();
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return SafeArea(
      top: false,
      child: SizedBox(
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      ),
    );
  }
}
