import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// AdMob ad unit ids.
///
/// In debug/profile builds we always return Google's official **test** ids so
/// developers never accidentally click on live ads (an AdMob policy violation).
/// In release builds the real ids below are used — replace the placeholders
/// with your own from the AdMob console (see docs/ADMOB_SETUP.md).
abstract final class AdUnitIds {
  // ---- Google official TEST ids (safe for development) ----
  static const String _testAndroidAppOpen =
      'ca-app-pub-3940256099942544/9257395921';
  static const String _testAndroidBanner =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testAndroidInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testAndroidRewarded =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testAndroidNative =
      'ca-app-pub-3940256099942544/2247696110';

  static const String _testIosAppOpen =
      'ca-app-pub-3940256099942544/5575463023';
  static const String _testIosBanner =
      'ca-app-pub-3940256099942544/2934735716';
  static const String _testIosInterstitial =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testIosRewarded =
      'ca-app-pub-3940256099942544/1712485313';
  static const String _testIosNative =
      'ca-app-pub-3940256099942544/3986624511';

  // ---- REAL release ids (REPLACE these before publishing) ----
  static const String _prodAndroidAppOpen = 'ca-app-pub-0000000000000000/0000000001';
  static const String _prodAndroidBanner = 'ca-app-pub-0000000000000000/0000000002';
  static const String _prodAndroidInterstitial = 'ca-app-pub-0000000000000000/0000000003';
  static const String _prodAndroidRewarded = 'ca-app-pub-0000000000000000/0000000004';
  static const String _prodAndroidNative = 'ca-app-pub-0000000000000000/0000000005';

  static const String _prodIosAppOpen = 'ca-app-pub-0000000000000000/0000000011';
  static const String _prodIosBanner = 'ca-app-pub-0000000000000000/0000000012';
  static const String _prodIosInterstitial = 'ca-app-pub-0000000000000000/0000000013';
  static const String _prodIosRewarded = 'ca-app-pub-0000000000000000/0000000014';
  static const String _prodIosNative = 'ca-app-pub-0000000000000000/0000000015';

  static bool get _useTest => kDebugMode || kProfileMode;
  static bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  static String get appOpen {
    if (_useTest) return _isAndroid ? _testAndroidAppOpen : _testIosAppOpen;
    return _isAndroid ? _prodAndroidAppOpen : _prodIosAppOpen;
  }

  static String get banner {
    if (_useTest) return _isAndroid ? _testAndroidBanner : _testIosBanner;
    return _isAndroid ? _prodAndroidBanner : _prodIosBanner;
  }

  static String get interstitial {
    if (_useTest) {
      return _isAndroid ? _testAndroidInterstitial : _testIosInterstitial;
    }
    return _isAndroid ? _prodAndroidInterstitial : _prodIosInterstitial;
  }

  static String get rewarded {
    if (_useTest) return _isAndroid ? _testAndroidRewarded : _testIosRewarded;
    return _isAndroid ? _prodAndroidRewarded : _prodIosRewarded;
  }

  static String get native {
    if (_useTest) return _isAndroid ? _testAndroidNative : _testIosNative;
    return _isAndroid ? _prodAndroidNative : _prodIosNative;
  }
}
