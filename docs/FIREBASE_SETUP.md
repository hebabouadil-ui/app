# Firebase Setup (Analytics)

Dream AI uses **Firebase Analytics**. Firebase init is optional in development —
the app runs without it (analytics becomes a safe no-op). Follow this before
release so you get retention, session, feature-usage, ad, and conversion data.

## 1. Create the project
1. Go to the [Firebase Console](https://console.firebase.google.com/) → **Add project**.
2. Enable **Google Analytics** when prompted (creates a linked GA4 property).

## 2. Recommended: FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=<your-firebase-project-id>
```
This registers your Android & iOS apps and writes `lib/firebase_options.dart`.

> This repo calls `Firebase.initializeApp()` **without** options, which reads the
> native config files below. If you prefer `DefaultFirebaseOptions`, import the
> generated `firebase_options.dart` in `main.dart` and pass
> `options: DefaultFirebaseOptions.currentPlatform`. Note `firebase_options.dart`
> is git-ignored.

## 3. Add the native config files
- **Android:** download `google-services.json` → place in `android/app/`.
  The Google Services Gradle plugin is already wired in `android/app/build.gradle`
  and `android/settings.gradle`.
- **iOS:** download `GoogleService-Info.plist` → add to `ios/Runner/` **via Xcode**
  (so it's included in the target's "Copy Bundle Resources").

> Both files are git-ignored on purpose — never commit them.

## 4. Use the matching bundle/package ids
- Android `applicationId`: `app.dreamai.faceanalyzer`
- iOS bundle id: set in Xcode (e.g. `app.dreamai.faceanalyzer`)

Make sure the ids in Firebase match these exactly.

## 5. Verify
```bash
flutter run
```
In the Firebase console, open **Analytics → DebugView** and enable debug mode:
- Android: `adb shell setprop debug.firebase.analytics.app app.dreamai.faceanalyzer`
- iOS: add `-FIRAnalyticsDebugEnabled` to the scheme's launch arguments.

You should see `app_open`, `screen_view`, `analysis_completed`, etc.

## Events emitted by the app
See `lib/data/services/analytics_service.dart`. Highlights:
`app_open`, `screen_view`, `onboarding_complete`, `analysis_started`,
`analysis_completed`, `share`, `challenge_completed`, `badge_unlocked`,
`streak_continued`, `level_up`, `ad_impression_custom`, `reward_earned`,
`paywall_view`, `purchase_success`, `referral`.

## Consent
Analytics collection is **disabled until the user consents** (handled by
`SettingsNotifier.setConsent`). Respect this when adding new events.
