# Google Play Store — Submission Checklist
### Dream AI – Face Analyzer & Daily Fun Predictions

> **Category:** Entertainment | **Stack:** Flutter, Google AdMob, Firebase Analytics, `in_app_purchase`
> **Target audience:** 13+ (NOT designed for children) — this is critical for the Data safety, Families, and ads declarations below.
> Use this as a gating checklist before pushing to Production.

---

## 1. Google Play Developer Account

- [ ] Google Play Developer account created and the **one-time $25 registration fee** paid.
- [ ] Account type chosen correctly (**Organization** recommended if a company; Personal if individual).
- [ ] **Identity verification** completed (legal name, address, phone, D-U-N-S if organization).
- [ ] **Developer contact details** (email, website, phone) verified — these appear/are used by Google.
- [ ] **Payments profile** created and linked (required for IAP/paid features).
- [ ] Two-factor authentication enabled on the Google account.
- [ ] App created in **Play Console** with correct default language and app name (`Dream AI: Face & Aura Fun`, ≤30 chars).

---

## 2. App Signing (Play App Signing)

- [ ] **Play App Signing** enabled (default and recommended) — Google manages the app signing key.
- [ ] **Upload key** generated locally and kept secure (back it up offline; losing it blocks updates unless reset).
- [ ] App built as an **Android App Bundle (`.aab`)**, not a legacy APK (required for new apps).
- [ ] `applicationId` finalized (e.g., `com.dreamai.faceanalyzer`) — **cannot be changed after publishing**.
- [ ] Release build signed with the upload key via `key.properties` / Gradle signing config (not debug keys).
- [ ] `minSdkVersion` and `targetSdkVersion` meet current Play requirements (target the latest required API level).
- [ ] ProGuard/R8 minification + resource shrinking validated against AdMob, Firebase, and `in_app_purchase` (no broken classes).
- [ ] Version code incremented and `versionName` set for the release.

---

## 3. Store Listing Assets

### Text
- [ ] **App title** (≤30 chars) finalized.
- [ ] **Short description** (≤80 chars) finalized — front-loaded with keywords + entertainment cue.
- [ ] **Full description** (≤4000 chars) finalized **with the entertainment disclaimer block at the end** (see `ASO.md`).

### Graphics
- [ ] **App icon** — 512×512 px, 32-bit PNG (with alpha), under 1 MB. No real faces; mystical/modern (see `ASO.md` icon concepts).
- [ ] **Feature graphic** — 1024×500 px, PNG/JPG, no essential text in outer margins.
- [ ] **Phone screenshots** — minimum **2**, recommended **6–8**; 16:9 or 9:16; min dimension 320px, max 3840px. Captions baked in (see `ASO.md`).
- [ ] **7-inch tablet screenshots** — provide if you want tablet placement (recommended for reach).
- [ ] **10-inch tablet screenshots** — provide if supporting larger tablets.
- [ ] (Optional) **Promo video** — YouTube URL, 30s–2min, shows real app usage.
- [ ] All assets reviewed for **no real celebrity photos** (Celebrity Look-Alike uses generic/illustrated avatars only) and no misleading "real analysis" claims.

---

## 4. Content Rating Questionnaire (IARC)

- [ ] IARC content rating questionnaire completed (required before publishing).
- [ ] Category selected accurately (**Entertainment / Reference, Social, etc.** — answer honestly).
- [ ] Questions answered truthfully: **no** violence, **no** sexual content, **no** gambling.
- [ ] **"Does the app share the user's current physical location?"** — answer per actual behavior (likely No).
- [ ] **Digital purchases** declared (Yes — ad-free + premium packs via `in_app_purchase`).
- [ ] **Users can interact / share content** — declare sharing of result cards if applicable.
- [ ] Confirm the resulting rating (target **Everyone / Teen**, consistent with 13+ audience) — re-run if features change.
- [ ] Note: misrepresenting content here is a common cause of enforcement — keep answers accurate.

---

## 5. Data Safety Form

> Be precise — this is cross-checked against your privacy policy and runtime behavior. Given **AdMob + Firebase Analytics + `in_app_purchase`**, the following typically applies.

### Data collected / shared
- [ ] **Device or other IDs** — *Collected & Shared* (AdMob Advertising ID for ads/personalization). Purpose: **Advertising/marketing, Analytics**.
- [ ] **App activity** (in-app actions, screen views) — *Collected* via Firebase Analytics. Purpose: **Analytics, App functionality**.
- [ ] **Crash logs / diagnostics** — *Collected* if Firebase Crashlytics is used. Purpose: **Analytics / functionality**.
- [ ] **Approximate location** — declare *Collected/Shared* only if AdMob coarse location is used for ad targeting (review SDK config).
- [ ] **Purchase history** — *Collected* via `in_app_purchase` / Play Billing for entitlements. Purpose: **App functionality**.
- [ ] **Photos (face scan image):** Declare honestly. If the selfie is **processed on-device and never uploaded/stored on a server**, you may indicate it is **not collected** — but you MUST be certain no SDK transmits it. If any image leaves the device, declare it as **Collected** with purpose **App functionality** and describe retention.

### Security & handling declarations
- [ ] **Data is encrypted in transit** — confirm (HTTPS for all network calls).
- [ ] **Users can request data deletion** — provide an in-app path and/or a deletion-request URL/email.
- [ ] Each data type marked **optional vs required** correctly.
- [ ] **"Is all collected data ephemeral?"** answered accurately.
- [ ] AdMob configured for **consent-gated personalized vs non-personalized ads** (see §7) and reflected here.
- [ ] Data safety answers **match the Privacy Policy** word-for-word in spirit.

---

## 6. Target Audience & Content (Families / COPPA)

> **This app targets 13+ and is NOT directed at children.** Configure accordingly to stay out of the "Designed for Families" / COPPA regime.

- [ ] **Target age groups:** select **13+** (and up). **Do NOT** select any age band under 13.
- [ ] Confirm the app is **NOT** enrolled in the **Designed for Families** program.
- [ ] Store listing, icon, and screenshots do **not** appeal primarily to children (no cartoonish kid framing).
- [ ] **Ads + children:** Because no under-13 audience is selected, AdMob ads are permitted, but you still must complete the Ads declaration (§7) and respect consent (§9).
- [ ] If Google's audience review flags possible child appeal, be ready to justify the 13+ entertainment positioning.
- [ ] Confirm no features encourage sharing of personal info by minors.

---

## 7. Ads Declaration

- [ ] **"Does your app contain ads?"** → **Yes** (AdMob: rewarded, native, interstitial, app-open).
- [ ] Ad formats reviewed against Play policy:
  - [ ] **App-open ads** comply (not shown on splash before content loads inappropriately; respect frequency rules).
  - [ ] **Interstitials** are not unexpected/disruptive (no full-screen ad on app launch action, no accidental clicks).
  - [ ] **Rewarded ads** are clearly opt-in.
  - [ ] No ads overlap with system buttons or fake "close" buttons (disallowed/deceptive ads policy).
- [ ] AdMob app IDs added to `AndroidManifest.xml` (`com.google.android.gms.ads.APPLICATION_ID`).
- [ ] **Families Policy** ad SDK requirements N/A (since 13+), but confirm AdMob account is in good standing.
- [ ] Ad content rating in AdMob set appropriately (e.g., max ad content rating = Teen/G as desired).

---

## 8. Privacy Policy & Legal

- [ ] **Privacy Policy URL** is public, live, and entered in Play Console (App content → Privacy policy). **Required** because the app collects data and serves ads.
- [ ] Privacy Policy explicitly mentions **AdMob/Google advertising**, **Firebase Analytics**, advertising identifiers, and (if applicable) on-device face-scan handling.
- [ ] Privacy Policy describes **data deletion** process and contact email.
- [ ] **Terms of Service** linked/in-app (recommended given IAP + UGC sharing).
- [ ] **Entertainment disclaimer** present in app and store description (no medical/psychological/scientific claims).
- [ ] **GDPR** consent mechanism implemented for EEA/UK users (consent for personalized ads + analytics).
- [ ] Account deletion: if accounts exist, provide the required **in-app account deletion** + web deletion URL (Play data deletion policy).

---

## 9. Consent (GDPR) Implementation Verification

- [ ] **Google User Messaging Platform (UMP) SDK** (or equivalent CMP) integrated for EEA/UK consent.
- [ ] Consent collected **before** loading personalized ads; non-personalized ads served on refusal.
- [ ] Firebase Analytics respects consent state (consent mode) where required.
- [ ] Consent choice is **revocable** in-app (settings entry to re-open the consent form).
- [ ] Tested with an EEA region/VPN to confirm the consent form actually appears.

---

## 10. Monetization Setup (In-App Products)

- [ ] **Google Play Billing** library integrated via Flutter `in_app_purchase`.
- [ ] Products created in Play Console:
  - [ ] **Remove Ads** (one-time, non-consumable / entitlement).
  - [ ] **Premium pack(s)** (non-consumable or subscription as designed).
- [ ] Product IDs match the codebase constants exactly.
- [ ] Prices set across target countries; tax/financial profile complete.
- [ ] **Purchase restore** flow implemented and tested (required for non-consumables).
- [ ] Purchases tested with **license testers** (no real charges) before launch.
- [ ] Server-side or local entitlement verification implemented (avoid easy bypass of ad-free).
- [ ] Subscription terms/cancellation info disclosed in-app if subscriptions are used.

---

## 11. Pre-Launch Report

- [ ] **Pre-launch report** enabled in Play Console (App bundle explorer / Release → Testing).
- [ ] Review **crashes/ANRs** on the matrix of real test devices.
- [ ] Review **performance**, **accessibility**, and **security (SSL/vulnerability)** warnings.
- [ ] Provide **test credentials/instructions** if any flow requires login.
- [ ] Confirm AdMob test ads (not live ads) are configured during pre-launch testing to avoid policy strikes/invalid traffic.
- [ ] Resolve all blocking issues before promoting to Production.

---

## 12. Release Tracks

- [ ] **Internal testing** track used first (up to 100 testers; fastest propagation) — smoke test build, IAP, ads (test mode), consent.
- [ ] **Closed testing** track (alpha) with a tester list/email group — required testing volume for new personal developer accounts if applicable.
- [ ] **Open testing** (beta) optional — gather wider feedback and reviews before launch.
- [ ] **Production** rollout configured as a **staged rollout** (e.g., start at 10–20%, then ramp).
- [ ] **Countries/regions** selected (align with `ASO.md` localization tiers).
- [ ] Release notes written (and localized for Tier-1 markets).
- [ ] "Managed publishing" considered so you control the exact go-live moment after review approval.

---

## 13. Pre-Submission Final Review

- [ ] App complies with **Deceptive Behavior** policy — no claims the AI provides real/accurate analysis (entertainment framing everywhere).
- [ ] App complies with **Health misinformation** policy — no medical/health claims from face scans.
- [ ] **Permissions** minimized — only request **Camera** (for face scan); justify any others. No unused sensitive permissions.
- [ ] Camera permission has a clear, in-context rationale prompt.
- [ ] No use of restricted permissions (e.g., no `QUERY_ALL_PACKAGES`, no SMS/Call Log) — would require declarations.
- [ ] App content (icon, screenshots, description) is **consistent** and not misleading.
- [ ] Tested on min and target SDK devices; offline behavior graceful.

---

## 14. Post-Launch Monitoring

- [ ] Monitor **Android vitals** (crash rate, ANR rate) — stay under Google's bad-behavior thresholds.
- [ ] Monitor **policy status / inbox** in Play Console for warnings or strikes.
- [ ] Monitor **AdMob** for **invalid traffic** flags and policy violations (can suspend ad serving).
- [ ] Track **store listing conversion** (store performance) and A/B test (Store Listing Experiments) icon/screenshots/short description.
- [ ] Monitor **ratings & reviews**; set up reply templates; watch for "it's not accurate" complaints and reinforce the entertainment disclaimer in replies.
- [ ] Track **Firebase Analytics** funnels (scan → result → share → retention/streak).
- [ ] Keep **targetSdkVersion** current to meet annual Play API-level requirements.
- [ ] Keep AdMob, Firebase, and `in_app_purchase` SDKs updated; re-test consent flow after major SDK bumps.
- [ ] Re-validate **Data safety** form whenever a new SDK or data flow is added.
```
