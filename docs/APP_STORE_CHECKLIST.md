# Apple App Store — Submission Checklist
### Dream AI – Face Analyzer & Daily Fun Predictions

> **Category:** Entertainment | **Stack:** Flutter, Google AdMob, Firebase Analytics, `in_app_purchase`
> **Positioning:** Entertainment-only. All face scans/predictions are for fun — no medical, psychological, or scientific claims.
> Use this as a gating checklist before submitting for App Review.

---

## 1. Apple Developer Program

- [ ] **Apple Developer Program** membership active ($99/year).
- [ ] Account type correct (**Organization** with a valid D-U-N-S number recommended for a company; Individual otherwise).
- [ ] **Account Holder** has accepted the latest **Program License Agreement** (and Paid Apps Agreement — required for IAP).
- [ ] **Paid Applications Agreement** signed in App Store Connect → Business; **banking + tax** forms complete (required for IAP revenue).
- [ ] Two-factor authentication enabled on the Apple ID.
- [ ] Roles assigned (Admin/App Manager/Developer) appropriately for the team.

---

## 2. App Store Connect Setup

- [ ] New app record created in **App Store Connect**.
- [ ] **App name** set (≤30 chars): `Dream AI: Face & Aura Fun`.
- [ ] **Subtitle** set (≤30 chars) — see `ASO.md` (recommended: `Aura, Luck & Personality Fun`).
- [ ] **Primary category:** Entertainment. (Secondary optional, e.g., Lifestyle.)
- [ ] **Keywords field** (≤100 chars, comma-separated, no spaces) entered from `ASO.md`.
- [ ] **Promotional text** (≤170 chars) entered (updatable without review).
- [ ] **Description** entered with **entertainment disclaimer** at the end.
- [ ] **Support URL** and **Marketing URL** provided.
- [ ] **Privacy Policy URL** provided (required — app collects data & serves ads).
- [ ] **Age rating** questionnaire completed → target **12+ or 17+ as appropriate** (NOT made for kids; do not enable the Kids Category).
- [ ] **Pricing** set (Free with IAP) and **availability** countries selected (align with `ASO.md` localization tiers).

---

## 3. Bundle ID, Capabilities & Build

- [ ] **Bundle ID** registered in the Developer portal (e.g., `com.dreamai.faceanalyzer`) and matches Xcode/Flutter config — **immutable after first submission**.
- [ ] App ID capabilities enabled as needed: **In-App Purchase** (required); **Push Notifications** only if used (daily prediction reminders may use this).
- [ ] **Signing & Provisioning** configured (Automatic signing in Xcode or managed profiles); distribution certificate valid.
- [ ] Build archived from Xcode/`flutter build ipa` and uploaded via **Transporter** or Xcode Organizer.
- [ ] **Deployment target** (min iOS version) set sensibly (e.g., iOS 13/14+) and tested.
- [ ] App built with current **Xcode / iOS SDK** version per Apple's submission requirement.
- [ ] No use of non-public/private APIs (common Flutter-plugin rejection vector — audit plugins).

---

## 4. Info.plist Usage Strings (Permissions)

- [ ] **`NSCameraUsageDescription`** — clear, honest, in-context. Example: *"Dream AI uses your camera to capture a selfie for a fun, on-device face scan and entertainment results."*
- [ ] **`NSUserTrackingUsageDescription`** — required for App Tracking Transparency (see §6). Example: *"Allow tracking to receive more relevant ads and support free features. Your face scan results are just for fun."*
- [ ] **`NSPhotoLibraryUsageDescription`** / **`NSPhotoLibraryAddUsageDescription`** — only if users pick from / save result cards to Photos.
- [ ] **`NSUserNotificationsUsageDescription`** behavior handled if sending daily reminders (request via UNUserNotificationCenter).
- [ ] No leftover unused permission strings (each prompt the app can trigger MUST have a purpose string or it crashes/gets rejected).
- [ ] **SKAdNetwork identifiers** (`SKAdNetworkItems`) added to Info.plist for AdMob + mediation partners (ad attribution without IDFA).
- [ ] `GADApplicationIdentifier` (AdMob App ID) added to Info.plist.

---

## 5. App Privacy "Nutrition Label" (App Store Connect → App Privacy)

> Declare precisely; Apple cross-checks against runtime/SDK behavior. Based on **AdMob + Firebase Analytics + `in_app_purchase`**:

- [ ] **Identifiers → Device ID (IDFA)** — *Collected*, **Used for Tracking**, linked, purpose **Third-Party Advertising / Developer's Advertising** (AdMob). Gated behind ATT (see §6).
- [ ] **Usage Data → Product Interaction / Advertising Data** — *Collected* (Firebase Analytics + AdMob), purposes **Analytics, Developer's Advertising**.
- [ ] **Diagnostics → Crash/Performance Data** — *Collected* if Crashlytics/Performance used; purpose **Analytics**, typically **not linked / not tracking**.
- [ ] **Purchases → Purchase History** — *Collected* via `in_app_purchase`; purpose **App Functionality**.
- [ ] **Location → Coarse Location** — declare only if AdMob/SDK collects it for ad targeting (verify SDK config).
- [ ] **User Content → Photos (face scan):** Declare honestly. If the selfie is **processed on-device and never transmitted/stored remotely**, you may mark it **Data Not Collected** — but only if you are certain no SDK uploads it. If any image leaves the device, declare **User Content → Photos**, purpose **App Functionality**, with retention details.
- [ ] Each item correctly flagged **Linked to identity** vs **Not linked**, and **Used to track you** vs not.
- [ ] **"Data Used to Track You"** section includes IDFA + any cross-app advertising data.
- [ ] App Privacy answers **match the Privacy Policy** and the runtime behavior.

---

## 6. App Tracking Transparency (ATT) — Required for AdMob/IDFA

- [ ] **ATT prompt** (`ATTrackingManager.requestTrackingAuthorization`) implemented and shown **before** accessing IDFA / enabling personalized ads.
- [ ] `NSUserTrackingUsageDescription` string is descriptive and non-coercive (no rewards-for-consent wording that violates guidelines).
- [ ] If user **denies** ATT: serve **non-personalized ads**, do NOT access IDFA, and continue full functionality (no gating of core features behind tracking consent — guideline 5.1.1(iv)/3.2.2).
- [ ] **GDPR/UMP consent** (Google UMP CMP) also implemented for EEA/UK and sequenced sensibly relative to the ATT prompt.
- [ ] AdMob SDK configured to respect ATT status (request NPA when not authorized).
- [ ] Tested on a real device (ATT prompt does not appear on Simulator reliably) in both **Allow** and **Ask App Not to Track** states.
- [ ] No fingerprinting / IDFA workaround when the user denies tracking (instant rejection risk).

---

## 7. Required Screenshots & Media

> Apple requires screenshots for specific display sizes. Provide at least the largest iPhone size; others can scale, but tailored sets convert better. Captions baked in (see `ASO.md`).

- [ ] **6.9" / 6.7" iPhone** (e.g., iPhone 15/16 Pro Max class) — **required** (1290×2796 or 1320×2868). Up to 10 screenshots.
- [ ] **6.5" iPhone** (e.g., iPhone 11 Pro Max / XS Max) — 1242×2688 (recommended if not auto-scaling from larger).
- [ ] **5.5" iPhone** (e.g., iPhone 8 Plus) — 1242×2208 (provide if supporting older devices / for completeness).
- [ ] **iPad 12.9"/13"** screenshots — **required only if the app supports iPad** (2048×2732). Decide iPad support explicitly; if iPhone-only, set the build to iPhone family.
- [ ] (Optional) **App Previews** (video, 15–30s) per size — recorded from the app.
- [ ] No real celebrity images in screenshots (Celebrity Look-Alike uses generic/illustrated avatars).
- [ ] Screenshots are **accurate** to the actual app (no fabricated UI) — guideline 2.3.3.
- [ ] **1024×1024 App Store icon** uploaded (no alpha, no transparency, no rounded corners baked in).

---

## 8. App Review Guidelines — Risk Areas & Mitigations

> "Fun prediction / face scan" apps draw extra scrutiny. Address each proactively in the build and in **App Review notes**.

| Guideline | Risk | Mitigation |
|-----------|------|------------|
| **1.1 Safety / Objectionable Content** | Face "analysis" could be read as profiling, body-shaming, or implying real judgments. | Keep ALL copy explicitly playful; never imply real attractiveness/health/IQ scoring. Add visible "for entertainment only" labels on result screens. |
| **1.4 Physical Harm / 1.4.1** | Predictions mistaken for medical/psychological advice. | No medical, mental-health, or diagnostic language anywhere. Persistent entertainment disclaimer. |
| **2.1 App Completeness** | Reviewer can't test ads/IAP, or build crashes. | Provide working demo flow; ensure no login wall; ship a complete, crash-free build. |
| **2.3 Accurate Metadata** | Name/description/screenshots imply "real AI analysis" or accurate results. | Avoid claims of accuracy; frame as "AI-style, just for fun." Screenshots match real UI. No hidden/undocumented features. |
| **2.3.1 Hidden Features** | Undocumented functionality. | Disclose everything; no hidden/dormant code paths. |
| **3.1.1 In-App Purchase** | Selling ad-free / premium packs via non-Apple payment. | Use **StoreKit / `in_app_purchase`** for all digital unlocks (no external payment links for digital goods). |
| **4.0 / 4.1 Design & Copycats** | Generic "face reader" clones get rejected; using another app's assets. | Original branding, icon, and UI; no copied assets or trademarks. |
| **4.2 Minimum Functionality** | Perceived as a "thin"/novelty app. | Demonstrate depth: multiple feature modules, gamification (streaks/XP/badges), daily content, sharing. |
| **4.3 Spam / Duplicate** | Looks like one of many near-identical fortune apps. | Differentiate features and design; avoid template/reskin appearance. |
| **5.1.1 Data Collection & Storage** | Camera/photo + ad tracking without proper consent. | ATT + UMP consent; purpose strings; on-device processing emphasized; privacy policy complete. |
| **5.1.1(v) Account Deletion** | If accounts exist, must offer in-app account deletion. | Provide in-app account & data deletion path. |
| **5.1.2 Data Use & Sharing** | Sharing IDFA/data without consent. | Respect ATT; declare sharing accurately in App Privacy. |
| **5.1.4 Kids / 5.2** | App could be deemed child-directed → stricter rules. | Set age rating 12+/17+, do NOT enroll in Kids Category, no child-targeted design. |

- [ ] **App Review notes** written: explain it's an entertainment/novelty app, where the disclaimer appears, how ATT/consent works, and provide any needed test instructions.
- [ ] Demo of IAP and ad behavior described for the reviewer (test mode acceptable).

---

## 9. IDFA / Advertising Declaration

- [ ] During submission, **"Does this app use the Advertising Identifier (IDFA)?"** → **Yes** (AdMob).
- [ ] Check the correct usage reasons:
  - [ ] **Serve advertisements within the app** ✔
  - [ ] Attribute installs/actions to a previously served ad (if using attribution) ✔ as applicable
  - [ ] (Limit Ad Tracking / ATT respected) — confirm the attestation that you honor the user's tracking choice.
- [ ] SKAdNetwork IDs present in Info.plist for AdMob and mediated networks (§4).

---

## 10. Export Compliance (Encryption)

- [ ] Determine encryption usage. Most apps use only **standard HTTPS/TLS** (exempt).
- [ ] Set **`ITSAppUsesNonExemptEncryption`** in Info.plist (`false` if only using standard/exempt encryption) to skip repeated prompts.
- [ ] If only exempt encryption is used, no CCATS/year-end self-classification report is required — confirm and document the rationale.
- [ ] If any custom/non-exempt encryption is added later, complete the full export compliance documentation.

---

## 11. In-App Purchase Configuration & Review

- [ ] IAP products created in App Store Connect:
  - [ ] **Remove Ads** — Non-Consumable.
  - [ ] **Premium pack(s)** — Non-Consumable or Auto-Renewable Subscription as designed.
- [ ] Product IDs match the codebase constants exactly.
- [ ] Localized **display name + description** and pricing tiers set for each product.
- [ ] **Review screenshot** + review notes attached to each IAP (required for first review).
- [ ] **Restore Purchases** implemented and tested (required for non-consumables / subscriptions).
- [ ] Subscriptions (if any): subscription group, free trial/intro offer config, and **required subscription disclosures** (price, period, auto-renew terms) shown in-app and linked to Terms (EULA) + Privacy.
- [ ] IAP tested in **Sandbox** with a sandbox tester account (no real charges).
- [ ] First IAP is submitted **together with the app version** (new IAPs must be attached to a version review).

---

## 12. TestFlight Beta

- [ ] Build uploaded and processed for **TestFlight**.
- [ ] **Internal testing** group set up (up to 100 internal testers, no Beta App Review needed) — smoke test ads, IAP (sandbox), ATT, camera scan.
- [ ] **External testing** group (up to 10,000) configured if doing wider beta — requires **Beta App Review** + **Test Information** (beta description, contact, feedback email) and an entertainment disclaimer note.
- [ ] **Export compliance** answered for the TestFlight build.
- [ ] Verified ATT prompt + consent flow on real devices via TestFlight.
- [ ] Verified IAP purchase + restore via sandbox in TestFlight.
- [ ] Crash-free and performance-acceptable on the oldest supported device before promoting to App Review.

---

## 13. Pre-Submission Final Review

- [ ] All required metadata, screenshots, and the 1024×1024 icon present and consistent.
- [ ] Entertainment disclaimer visible **in-app** (result screens) and in the **store description**.
- [ ] No medical/psychological/scientific claims anywhere in app or metadata.
- [ ] Camera/photo flows degrade gracefully if permission denied.
- [ ] ATT denial path serves non-personalized ads and does not block features.
- [ ] Privacy Policy + Terms (EULA) linked in-app and in App Store Connect.
- [ ] Build version/number incremented; release option chosen (**Manual release** recommended to control go-live).
- [ ] App Review notes finalized with reviewer test guidance.

---

## 14. Post-Launch Monitoring

- [ ] Monitor **App Store Connect → App Review** status and respond fast to any rejection (use Resolution Center; rebut with disclaimer/positioning if "novelty/spam" is cited).
- [ ] Watch **crash reports / Organizer metrics** and Crashlytics.
- [ ] Monitor **ratings & reviews**; reply to "not accurate" complaints by reaffirming the entertainment-only nature.
- [ ] Track **App Analytics** (impressions → product page views → conversion) and iterate on screenshots/subtitle (and promo text, which updates without review).
- [ ] Monitor **AdMob** for invalid traffic / policy issues and SKAdNetwork performance.
- [ ] Keep AdMob, Firebase, and `in_app_purchase` plugins updated; re-test ATT + consent after major SDK/iOS updates.
- [ ] Re-validate **App Privacy** label whenever a new SDK or data flow is introduced.
- [ ] Stay current with annual Xcode/SDK build requirements for future updates.
```
