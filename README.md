# Dream AI – Face Analyzer & Daily Fun Predictions

A cross-platform **Flutter** entertainment app: playful, on-device "AI" face
insights and daily predictions, built for high retention, viral sharing, and
ethical ad-based monetization. One codebase ships to **Google Play** and the
**Apple App Store**.

> ⚠️ **Entertainment only.** This app is intended solely for entertainment
> purposes and does not provide scientific, medical, or psychological advice.
> Every result is generated for fun.

---

## ✨ Features

- **Animated onboarding** with permission + privacy-consent steps.
- **Home hub** with 10 experiences: Aura Score, Personality Insights, First
  Impression, Leadership, Romantic Style, Daily Luck, Future Mood, Friendship
  Compatibility, Celebrity Look-Alike, Today's Positive Message.
- **On-device face scan** (Google ML Kit) — photos never leave the device.
- **Daily predictions**: luck, energy, productivity, social, mood forecast,
  motivational message + a 5-day outlook. Deterministic per day so they feel
  "real" but never change after you've seen them.
- **Beautiful shareable cards** rendered to an image and shared to Instagram,
  WhatsApp, TikTok, X, Facebook (and anywhere else) via the native share sheet.
- **Gamification**: daily streaks, XP, levels & unlockable titles, achievement
  badges, weekly challenges.
- **Local notifications** for re-engagement (no push servers).
- **Monetization** with Google AdMob: App Open, interstitial (after results,
  frequency-capped), rewarded (to unlock premium experiences), and natively
  templated native ads. Optional one-time **ad-free / premium** purchases.
- **Firebase Analytics** for retention, sessions, feature usage, ad & conversion
  events (consent-gated).
- **Privacy & compliance**: GDPR/UMP consent, iOS App Tracking Transparency,
  COPPA-safe (13+, no accounts), privacy policy, terms, and disclaimers.
- **Growth**: referral system with reward credits, in-app review prompts after
  positive moments, viral share incentives, and A/B-testing hooks.
- **Polish**: light/dark themes, responsive layouts, smooth animations,
  localization (English, Spanish, Arabic incl. RTL).

---

## 🏗️ Architecture

Clean, layered architecture with **Riverpod** for state and **GoRouter** for
navigation.

```
lib/
├── main.dart                  # Composition root: init services + DI overrides
├── app.dart                   # MaterialApp.router, theme, l10n, app-open ads
├── core/                      # Cross-cutting concerns (no feature logic)
│   ├── config/                # AppConfig + feature flags / A-B buckets
│   ├── constants/             # App constants, storage keys, ad unit ids
│   ├── extensions/            # BuildContext helpers (l10n, theme, responsive)
│   ├── router/                # GoRouter, routes, typed route args
│   ├── theme/                 # Colors, gradients, typography, ThemeData
│   └── utils/                 # SeededRandom (deterministic engine seed)
├── data/
│   ├── models/                # Plain immutable models (+ JSON)
│   └── services/              # Storage, ads, analytics, notifications,
│                              # purchases, consent, share, review,
│                              # face detection, and the result generator
├── providers/                 # Riverpod providers (the application layer)
├── features/                  # UI per feature (onboarding, home, scan, …)
├── shared/widgets/            # Reusable widgets (cards, gauges, ad widgets)
└── l10n/                      # ARB localization files
```

**Key idea — the "fun engine":** `data/services/result_generator.dart` is a
pure, deterministic function of `(experience, faceFeatures, date, userSalt)`.
It's fully unit-tested and contains zero side effects, which keeps results
reproducible and the UI layer thin.

---

## 🚀 Getting started

### Prerequisites
- Flutter **3.27+** (stable) / Dart **3.6+**
- Xcode 15+ (iOS) and/or Android Studio + JDK 17 (Android)
- A Firebase project and an AdMob account (for full functionality)

### 1. Generate platform scaffolding (one time)
This repository contains all **source code** and the **hand-edited platform
files** (AndroidManifest, Gradle, Info.plist, AppDelegate, Podfile). The
generated/binary pieces (launcher icons, Gradle wrapper, `Runner.xcodeproj`,
storyboards) are produced by Flutter:

```bash
flutter create --org app.dreamai --project-name dream_ai --platforms=android,ios .
```

`flutter create` **adds missing files without overwriting** the ones already
in the repo, so your manifest/Info.plist customizations are preserved.

### 2. Install dependencies
```bash
flutter pub get
```
Localization Dart (`lib/l10n/generated/`) is generated automatically by
`flutter gen-l10n` during `pub get`/build.

### 3. Configure Firebase & AdMob
- Firebase: see [`docs/FIREBASE_SETUP.md`](docs/FIREBASE_SETUP.md)
- AdMob: see [`docs/ADMOB_SETUP.md`](docs/ADMOB_SETUP.md)

The app **runs without** Firebase/real AdMob ids during development: Firebase
init fails safe (analytics becomes a no-op) and ads use Google's official test
units automatically in debug/profile builds.

### 4. Run
```bash
flutter run
```

---

## 🧪 Testing

```bash
flutter test          # unit + widget tests
flutter analyze       # static analysis
```

Pure logic (the result engine, gamification rules, seeded RNG) is covered by
fast unit tests in `test/`. See [`docs/TESTING_CHECKLIST.md`](docs/TESTING_CHECKLIST.md).

---

## 💸 Monetization summary

| Format        | Where it shows                                   | Guardrails |
|---------------|--------------------------------------------------|-----------|
| App Open      | On resume (not first cold start)                 | Skipped if a full-screen ad was shown <10s ago, premium-aware |
| Interstitial  | After a result is generated                      | Frequency cap (default 90s), premium-aware |
| Rewarded      | To unlock a premium experience or over-cap run   | Only on explicit user opt-in |
| Native        | Inline in the home feed                          | Built-in medium template; in-house promo fallback |
| Banner        | Anchored above the bottom navigation             | Hidden for premium users |

Free tier allows **3 analyses/day**; premium experiences are unlocked by a
rewarded ad, a referral credit, or a one-time purchase.

---

## 🌍 Localization
ARB files live in `lib/l10n/`. Add a language by creating `app_<locale>.arb`
and adding the locale to your translations. RTL (Arabic) is supported.

---

## 📦 Deliverables & docs
- [`docs/FIREBASE_SETUP.md`](docs/FIREBASE_SETUP.md)
- [`docs/ADMOB_SETUP.md`](docs/ADMOB_SETUP.md)
- [`docs/BUILD_INSTRUCTIONS.md`](docs/BUILD_INSTRUCTIONS.md)
- [`docs/TESTING_CHECKLIST.md`](docs/TESTING_CHECKLIST.md)
- [`docs/DEPLOYMENT_CHECKLIST.md`](docs/DEPLOYMENT_CHECKLIST.md)
- [`docs/PLAY_STORE_CHECKLIST.md`](docs/PLAY_STORE_CHECKLIST.md)
- [`docs/APP_STORE_CHECKLIST.md`](docs/APP_STORE_CHECKLIST.md)
- [`docs/ASO.md`](docs/ASO.md) — store listing copy, keywords, icon/screenshot ideas

---

## 🔒 Compliance notes
- 13+ audience; **no accounts**, **no biometric profiles**, photos analyzed
  on-device only.
- Consent (UMP) gathered before personalized ads; analytics disabled until
  consent; ATT prompt on iOS.
- Replace the placeholder privacy/terms URLs, AdMob ids, and bundle ids before
  release (search for `0000` and `dreamai.app`).

## License
Proprietary / all rights reserved (update as needed).
