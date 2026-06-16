# Deployment Checklist (pre-release, both platforms)

## Identity & config
- [ ] Replace bundle/package id placeholders if needed (`app.dreamai.faceanalyzer`).
- [ ] Replace privacy/terms URLs in `lib/core/constants/app_constants.dart`
      (`dreamai.app/...`) and host the real pages.
- [ ] Replace AdMob **App IDs** (Manifest + Info.plist) and **ad unit ids**
      (`ad_unit_ids.dart` `_prod*`).
- [ ] Replace iOS App Store id (`AppConstants.iosAppId`) used by the review prompt.
- [ ] Set the real launcher icon + splash.
- [ ] Bump `version:` in `pubspec.yaml` (`x.y.z+build`).

## Firebase & analytics
- [ ] `google-services.json` and `GoogleService-Info.plist` in place.
- [ ] DebugView shows events.
- [ ] Conversion events marked as conversions in GA4.

## Ads & consent
- [ ] UMP GDPR (and US) messages published in AdMob.
- [ ] SKAdNetwork list updated to Google's full current list.
- [ ] Verified non-personalized ads when consent declined.
- [ ] Frequency caps feel comfortable (not spammy).

## Monetization
- [ ] IAP products created & **active** in both stores with matching ids.
- [ ] Tested purchase + restore in sandbox/test tracks.
- [ ] Tax/banking set up in both consoles.

## Compliance
- [ ] Entertainment disclaimer present on result/scan screens and in store text.
- [ ] Privacy Policy + Terms reachable in-app and via store listing URL.
- [ ] Audience set to 13+ (not "children"); COPPA/Families avoided.
- [ ] Data safety (Play) / App Privacy (Apple) forms match actual SDK behavior
      (AdMob, Firebase Analytics, in_app_purchase).

## Quality
- [ ] `flutter analyze` clean; `flutter test` green.
- [ ] Release build profiled for jank on a low-end device.
- [ ] No debug logs leaking PII; `avoid_print` respected.
- [ ] Crash-free session check (add Crashlytics if desired).

## Release
- [ ] Android: signed `.aab`, Play App Signing enrolled.
- [ ] iOS: archive validated, TestFlight build approved internally.
- [ ] Screenshots + listing assets uploaded (see `docs/ASO.md`).
- [ ] Staged rollout (Play) / phased release (Apple) enabled.
- [ ] Post-launch: monitor ARPU, retention (D1/D7/D30), ad fill, crash rate,
      and review sentiment; iterate via the A/B hooks in `AppConfig`.
