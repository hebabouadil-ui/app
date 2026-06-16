import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Wraps Firebase Analytics with typed events. Designed to **fail safe**: if
/// Firebase isn't configured (e.g. local dev without `firebase_options.dart`)
/// or the user has not consented, every call becomes a no-op.
class AnalyticsService {
  AnalyticsService({FirebaseAnalytics? analytics}) : _analytics = analytics;

  final FirebaseAnalytics? _analytics;
  bool _enabled = false;

  FirebaseAnalytics? get instance => _analytics;

  /// Honors GDPR/consent — analytics collection is off until the user agrees.
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    try {
      await _analytics?.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      debugPrint('Analytics setEnabled failed: $e');
    }
  }

  Future<void> _log(String name, [Map<String, Object>? params]) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics.logEvent(name: name, parameters: params);
    } catch (e) {
      debugPrint('Analytics logEvent($name) failed: $e');
    }
  }

  // ---- Conversion / engagement events --------------------------------------

  Future<void> logAppOpen() => _log('app_open');

  Future<void> logScreen(String screen) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics.logScreenView(screenName: screen);
    } catch (e) {
      debugPrint('Analytics logScreen failed: $e');
    }
  }

  Future<void> logOnboardingComplete(String variant) =>
      _log('onboarding_complete', <String, Object>{'variant': variant});

  Future<void> logAnalysisStarted(String type) =>
      _log('analysis_started', <String, Object>{'type': type});

  Future<void> logAnalysisCompleted(String type, int score) =>
      _log('analysis_completed', <String, Object>{'type': type, 'score': score});

  Future<void> logShare(String type, String channel) => _log(
        'share',
        <String, Object>{'content_type': type, 'method': channel},
      );

  Future<void> logChallengeCompleted(String id) =>
      _log('challenge_completed', <String, Object>{'challenge_id': id});

  Future<void> logBadgeUnlocked(String id) =>
      _log('badge_unlocked', <String, Object>{'badge_id': id});

  Future<void> logStreak(int days) =>
      _log('streak_continued', <String, Object>{'days': days});

  Future<void> logLevelUp(int level) async {
    if (!_enabled || _analytics == null) return;
    try {
      await _analytics.logLevelUp(level: level);
    } catch (e) {
      debugPrint('Analytics logLevelUp failed: $e');
    }
  }

  // ---- Monetization events --------------------------------------------------

  Future<void> logAdImpression(String format, String placement) => _log(
        'ad_impression_custom',
        <String, Object>{'format': format, 'placement': placement},
      );

  Future<void> logRewardEarned(String placement) =>
      _log('reward_earned', <String, Object>{'placement': placement});

  Future<void> logPaywallView(String variant) =>
      _log('paywall_view', <String, Object>{'variant': variant});

  Future<void> logPurchase(String productId) =>
      _log('purchase_success', <String, Object>{'product_id': productId});

  Future<void> logReferral(String action) =>
      _log('referral', <String, Object>{'action': action});

  // ---- A/B testing ----------------------------------------------------------

  Future<void> setUserProperty(String name, String value) async {
    if (_analytics == null) return;
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('Analytics setUserProperty failed: $e');
    }
  }
}
