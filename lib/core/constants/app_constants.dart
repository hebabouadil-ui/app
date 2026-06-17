/// App-wide constant values that are not secrets.
abstract final class AppConstants {
  static const String appName = 'Dream AI';
  static const String appTagline = 'Face Analyzer & Daily Fun Predictions';

  /// Shown across the app to keep store compliance crystal clear.
  static const String entertainmentDisclaimer =
      'This app is intended solely for entertainment purposes and does not '
      'provide scientific, medical, or psychological advice.';

  static const String shortDisclaimer = 'AI face & palm reading • just for fun';

  // Legal / support links (replace with real URLs before release).
  static const String privacyPolicyUrl = 'https://dreamai.app/privacy';
  static const String termsUrl = 'https://dreamai.app/terms';
  static const String supportEmail = 'support@dreamai.app';
  static const String websiteUrl = 'https://dreamai.app';

  // Store ids (replace with real ids before release).
  static const String androidPackage = 'app.dreamai.faceanalyzer';
  static const String iosAppId = '0000000000';

  // Minimum age — keeps the app out of the "children" category (COPPA/Families).
  static const int minimumAge = 13;

  // Free tier limits (premium removes these).
  static const int freeAnalysesPerDay = 3;

  // Gamification economy.
  static const int xpPerAnalysis = 20;
  static const int xpPerDailyCheckIn = 15;
  static const int xpPerShare = 25;
  static const int xpPerChallenge = 60;
  static const int xpPerReferral = 100;
  static const int xpPerLevel = 250;

  // Referral reward (premium analyses credited to the referrer).
  static const int referralRewardCredits = 5;

  // Ask for a store review only after this many positive interactions.
  static const int reviewPromptThreshold = 4;
}
