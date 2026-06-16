/// Hive box names and keys. Centralized to avoid typos and collisions.
abstract final class StorageKeys {
  // Box names
  static const String settingsBox = 'settings';
  static const String userBox = 'user';
  static const String gamificationBox = 'gamification';
  static const String resultsBox = 'results';
  static const String predictionsBox = 'predictions';

  // settingsBox keys
  static const String onboardingComplete = 'onboarding_complete';
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String gdprConsent = 'gdpr_consent';
  static const String personalizedAds = 'personalized_ads';
  static const String attRequested = 'att_requested';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String isPremium = 'is_premium';
  static const String adFree = 'ad_free';
  static const String premiumPacks = 'premium_packs';
  static const String lastInterstitialEpoch = 'last_interstitial_epoch';
  static const String positiveInteractions = 'positive_interactions';
  static const String reviewRequested = 'review_requested';
  static const String selectedTheme = 'selected_visual_theme';

  // userBox keys
  static const String userProfile = 'profile';
  static const String referralCode = 'referral_code';
  static const String referredBy = 'referred_by';
  static const String referralCredits = 'referral_credits';

  // gamificationBox keys
  static const String gamificationState = 'state';

  // counters
  static const String analysesToday = 'analyses_today';
  static const String analysesTodayDate = 'analyses_today_date';
}
