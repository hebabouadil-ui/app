# Build Instructions

## One-time scaffolding
The repo includes all source + hand-edited platform files. Generate the
binary/boilerplate pieces (icons, Gradle wrapper, `Runner.xcodeproj`,
storyboards) once:
```bash
flutter create --org app.dreamai --project-name dream_ai --platforms=android,ios .
flutter pub get
```
Then set your real launcher icon (recommended):
```bash
# add flutter_launcher_icons to dev_dependencies, place a 1024px icon, then:
dart run flutter_launcher_icons
```

## Run (debug)
```bash
flutter run                 # attached device/emulator
flutter run -d chrome       # (UI preview only; ads/IAP/MLKit are mobile-only)
```

## Android

### Debug APK
```bash
flutter build apk --debug
```

### Release signing
1. Create a keystore:
   ```bash
   keytool -genkey -v -keystore ~/dreamai-upload.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `android/key.properties` (git-ignored):
   ```properties
   storePassword=********
   keyPassword=********
   keyAlias=upload
   storeFile=/absolute/path/to/dreamai-upload.jks
   ```
   `android/app/build.gradle` automatically uses it for the release build.

### Release artifacts
```bash
flutter build appbundle --release     # .aab for Play Store (preferred)
flutter build apk --release --split-per-abi
```
Output: `build/app/outputs/bundle/release/app-release.aab`.

> Min SDK 23, target/compile SDK 35, JDK 17. R8 shrinking is enabled; keep rules
> live in `android/app/proguard-rules.pro`.

## iOS

### Pods
```bash
cd ios && pod install && cd ..
```
> Min deployment target is **iOS 15.5** (required by current Google ML Kit pods).

### Build / archive
```bash
flutter build ios --release            # builds Runner.app
# Then open ios/Runner.xcworkspace in Xcode → Product → Archive → Distribute.
```
Or fully via CLI:
```bash
flutter build ipa --release
# Output: build/ios/ipa/*.ipa  → upload with Transporter or `xcrun altool`.
```

### Xcode settings to confirm
- Signing & Capabilities → your team + bundle id `app.dreamai.faceanalyzer`.
- Add `GoogleService-Info.plist` to the Runner target.
- Background Modes are **not** required.

## Flavors / environments (optional)
`AppConfig` (`lib/core/config/app_config.dart`) holds feature flags and A/B
buckets. Wire a remote-config provider to override them at runtime without
changing call sites.

## Common issues
- **`Generated.xcconfig must exist`** → run `flutter pub get`.
- **Pod min-version errors** → ensure `platform :ios, '15.5'` and rerun
  `pod repo update && pod install`.
- **Missing launcher icon / Gradle wrapper** → you skipped `flutter create .`.
- **Ads not showing in release** → real ad unit ids set? account approved? new
  units can take hours to start filling.
