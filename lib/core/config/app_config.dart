/// Runtime configuration & feature flags.
///
/// These are intentionally simple compile-time flags. They double as
/// **A/B testing hooks**: a remote-config provider (e.g. Firebase Remote
/// Config) can override them at runtime in a future iteration without touching
/// call sites — see [AppConfig.override].
class AppConfig {
  AppConfig({
    this.adsEnabled = true,
    this.appOpenAdEnabled = true,
    this.interstitialAfterResult = true,
    this.interstitialMinIntervalSeconds = 90,
    this.analyticsEnabled = true,
    this.referralEnabled = true,
    this.reviewPromptEnabled = true,
    // A/B experiment buckets (assigned at first launch, see ExperimentService).
    this.paywallVariant = 'A',
    this.onboardingVariant = 'A',
  });

  final bool adsEnabled;
  final bool appOpenAdEnabled;
  final bool interstitialAfterResult;
  final int interstitialMinIntervalSeconds;
  final bool analyticsEnabled;
  final bool referralEnabled;
  final bool reviewPromptEnabled;
  final String paywallVariant;
  final String onboardingVariant;

  AppConfig override({
    bool? adsEnabled,
    bool? appOpenAdEnabled,
    bool? interstitialAfterResult,
    int? interstitialMinIntervalSeconds,
    bool? analyticsEnabled,
    bool? referralEnabled,
    bool? reviewPromptEnabled,
    String? paywallVariant,
    String? onboardingVariant,
  }) {
    return AppConfig(
      adsEnabled: adsEnabled ?? this.adsEnabled,
      appOpenAdEnabled: appOpenAdEnabled ?? this.appOpenAdEnabled,
      interstitialAfterResult:
          interstitialAfterResult ?? this.interstitialAfterResult,
      interstitialMinIntervalSeconds:
          interstitialMinIntervalSeconds ?? this.interstitialMinIntervalSeconds,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      referralEnabled: referralEnabled ?? this.referralEnabled,
      reviewPromptEnabled: reviewPromptEnabled ?? this.reviewPromptEnabled,
      paywallVariant: paywallVariant ?? this.paywallVariant,
      onboardingVariant: onboardingVariant ?? this.onboardingVariant,
    );
  }
}
