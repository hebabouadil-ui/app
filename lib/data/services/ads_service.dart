import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/ad_unit_ids.dart';

/// Centralized AdMob manager.
///
/// Responsibilities:
///  * Initialize the SDK and apply personalized/non-personalized requests.
///  * App Open ads on launch/resume (skipped right after a rewarded/interstitial
///    so users aren't double-served).
///  * Interstitials after result generation, with **frequency capping**.
///  * Rewarded ads to unlock premium analyses on the free tier.
///  * Expose request config for banner/native widgets.
///
/// All entry points respect [adsRemoved] (premium / ad-free purchase).
class AdsService {
  AdsService();

  bool _initialized = false;

  /// Set true when the user owns the ad-free upgrade or any premium pack.
  bool adsRemoved = false;

  /// Driven by consent (UMP/ATT). When false we request non-personalized ads.
  bool personalized = false;

  /// Minimum seconds between interstitials (frequency cap).
  int interstitialMinIntervalSeconds = 90;

  DateTime? _lastInterstitialShown;
  DateTime? _lastFullScreenShown;

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;
  AppOpenAd? _appOpenAd;
  bool _showingFullScreen = false;

  AdRequest get request => AdRequest(nonPersonalizedAds: !personalized);

  String get nativeAdUnitId => AdUnitIds.native;
  String get bannerAdUnitId => AdUnitIds.banner;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      // Test devices should be configured here during QA.
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment:
              TagForChildDirectedTreatment.unspecified,
          maxAdContentRating: MaxAdContentRating.t, // Teen-appropriate
        ),
      );
      _initialized = true;
      _preloadInterstitial();
      _preloadRewarded();
      loadAppOpenAd();
    } catch (e) {
      debugPrint('AdsService init failed: $e');
    }
  }

  // ---- Interstitial ---------------------------------------------------------

  void _preloadInterstitial() {
    if (adsRemoved || !_initialized) return;
    InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) => _interstitial = ad,
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial failed: $error');
          _interstitial = null;
        },
      ),
    );
  }

  bool get _interstitialCapReached {
    if (_lastInterstitialShown == null) return false;
    final Duration since = DateTime.now().difference(_lastInterstitialShown!);
    return since.inSeconds < interstitialMinIntervalSeconds;
  }

  /// Shows an interstitial if one is loaded and the frequency cap allows it.
  /// Returns true if an ad was shown. Never blocks the result UX.
  Future<bool> maybeShowInterstitial({String placement = 'after_result'}) async {
    if (adsRemoved || _showingFullScreen || _interstitialCapReached) {
      return false;
    }
    final InterstitialAd? ad = _interstitial;
    if (ad == null) {
      _preloadInterstitial();
      return false;
    }
    final Completer<bool> completer = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _showingFullScreen = true,
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        _showingFullScreen = false;
        _lastInterstitialShown = DateTime.now();
        _lastFullScreenShown = DateTime.now();
        ad.dispose();
        _interstitial = null;
        _preloadInterstitial();
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        _showingFullScreen = false;
        ad.dispose();
        _interstitial = null;
        _preloadInterstitial();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    await ad.show();
    return completer.future;
  }

  // ---- Rewarded -------------------------------------------------------------

  void _preloadRewarded() {
    if (!_initialized) return;
    RewardedAd.load(
      adUnitId: AdUnitIds.rewarded,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) => _rewarded = ad,
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Rewarded failed: $error');
          _rewarded = null;
        },
      ),
    );
  }

  bool get isRewardedReady => _rewarded != null;

  /// Shows a rewarded ad. Resolves to true only if the user earned the reward.
  Future<bool> showRewarded({String placement = 'unlock_premium'}) async {
    final RewardedAd? ad = _rewarded;
    if (ad == null) {
      _preloadRewarded();
      return false;
    }
    final Completer<bool> completer = Completer<bool>();
    bool earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _showingFullScreen = true,
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        _showingFullScreen = false;
        _lastFullScreenShown = DateTime.now();
        ad.dispose();
        _rewarded = null;
        _preloadRewarded();
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        _showingFullScreen = false;
        ad.dispose();
        _rewarded = null;
        _preloadRewarded();
        if (!completer.isCompleted) completer.complete(false);
      },
    );
    await ad.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        earned = true;
      },
    );
    return completer.future;
  }

  // ---- App Open -------------------------------------------------------------

  void loadAppOpenAd() {
    if (adsRemoved || !_initialized) return;
    AppOpenAd.load(
      adUnitId: AdUnitIds.appOpen,
      request: request,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) => _appOpenAd = ad,
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AppOpen failed: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Shows the App Open ad on resume if available. Skipped when another full
  /// screen ad was shown in the last few seconds to avoid stacking.
  Future<void> showAppOpenIfAvailable() async {
    if (adsRemoved || _showingFullScreen || _appOpenAd == null) return;
    if (_lastFullScreenShown != null &&
        DateTime.now().difference(_lastFullScreenShown!).inSeconds < 10) {
      return;
    }
    final AppOpenAd ad = _appOpenAd!;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _showingFullScreen = true,
      onAdDismissedFullScreenContent: (AppOpenAd ad) {
        _showingFullScreen = false;
        _lastFullScreenShown = DateTime.now();
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
        _showingFullScreen = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );
    await ad.show();
  }

  void dispose() {
    _interstitial?.dispose();
    _rewarded?.dispose();
    _appOpenAd?.dispose();
  }
}
