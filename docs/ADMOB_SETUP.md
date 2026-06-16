# AdMob Setup (Monetization)

Dream AI monetizes with **Google AdMob**: App Open, Interstitial, Rewarded,
Native, and Banner formats, plus a UMP consent flow.

## 0. Test vs. production ids
`lib/core/constants/ad_unit_ids.dart` automatically uses **Google's official
test ad units** in `debug`/`profile` builds and your **real** units in
`release`. Never click live ads during development — it can get your account
suspended.

## 1. Create the AdMob app
1. [AdMob Console](https://apps.admob.com/) → **Apps → Add app** (one for
   Android, one for iOS).
2. Copy each **App ID** (`ca-app-pub-XXXX~YYYY`).

## 2. Set the App IDs natively
- **Android** — `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY" />
  ```
- **iOS** — `ios/Runner/Info.plist`:
  ```xml
  <key>GADApplicationIdentifier</key>
  <string>ca-app-pub-XXXXXXXXXXXXXXXX~ZZZZZZZZZZ</string>
  ```

## 3. Create ad units & set the ids
In AdMob create one unit per format **per platform** (App Open, Banner,
Interstitial, Rewarded, Native Advanced). Paste the `ca-app-pub-…/…` ids into the
`_prod*` constants in `lib/core/constants/ad_unit_ids.dart`.

## 4. SKAdNetwork (iOS)
`Info.plist` ships a representative `SKAdNetworkItems` list. Replace it with the
**current full list** from Google:
<https://developers.google.com/admob/ios/3p-skadnetworks>

## 5. Consent (UMP) & ATT
- In AdMob → **Privacy & messaging**, create a **GDPR** message (and a US-states
  message if desired). `ConsentService.gatherConsent()` loads/show it.
- iOS App Tracking Transparency is requested via `app_tracking_transparency`
  using the `NSUserTrackingUsageDescription` string already in `Info.plist`.
- Add a **privacy options** entry point (Settings → Privacy choices) — already
  wired to `ConsentService.showPrivacyOptions()`.

## 6. Test devices (avoid invalid traffic)
Add your device as a test device during QA, e.g. in `AdsService.init()`:
```dart
MobileAds.instance.updateRequestConfiguration(
  RequestConfiguration(testDeviceIds: <String>['YOUR_DEVICE_HASH']),
);
```
The device hash is printed to logcat/console the first time an ad loads.

## Frequency & UX guardrails (already implemented)
- Interstitials: min interval (default 90s) via `AppConfig`.
- App Open: skipped on first cold-start resume and within 10s of another
  full-screen ad.
- All formats are disabled for premium / ad-free users.

## Payments / IAP
Configure the products in `lib/data/services/purchase_service.dart`
(`ProductIds`) in **Google Play Console** and **App Store Connect** with
matching ids: `dreamai_ad_free`, `dreamai_premium_unlimited`,
`dreamai_compatibility_pack`, `dreamai_theme_pack`.

> For real revenue, verify purchase receipts server-side before granting
> entitlements. The current implementation grants on-device for simplicity.
