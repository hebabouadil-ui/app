# Testing Checklist

## Automated
- [ ] `flutter analyze` passes with no errors.
- [ ] `flutter test` passes (unit + widget tests in `test/`).
- [ ] Result engine determinism tests pass (`result_generator_test.dart`).
- [ ] Gamification rules tests pass (`gamification_test.dart`).
- [ ] Seeded RNG stability tests pass (`seeded_random_test.dart`).

Suggested additions as the app grows:
- [ ] Golden tests for `ShareableResultCard` in light/dark.
- [ ] Provider tests with `ProviderContainer` + overridden `StorageService`.
- [ ] Integration test (`integration_test/`) for the full scan→result→share flow.

## Manual — first run & onboarding
- [ ] Fresh install shows animated onboarding.
- [ ] Entertainment disclaimer is clearly visible.
- [ ] Camera permission requested; notification permission requested.
- [ ] Consent choice persists; declining personalization still allows the app.

## Manual — core experiences
- [ ] Each of the 10 home cards opens and produces a result.
- [ ] Face-based experiences detect a face; graceful message when none found.
- [ ] No-face experiences (Daily Luck / Future Mood / Positive Message) skip the camera.
- [ ] Friendship requires two photos before "Analyze" enables.
- [ ] Scores are 0–100; metrics render; traits render.
- [ ] Same photo + same day → consistent trait results.

## Manual — daily predictions
- [ ] Today's prediction is stable across app restarts (same day).
- [ ] Upcoming 5-day list renders.
- [ ] "Today's Positive Message" shows.

## Manual — sharing
- [ ] Share opens the native sheet with a rendered image card.
- [ ] Sharing increments XP and may trigger a review prompt (after threshold).

## Manual — gamification
- [ ] Opening the app increments the daily streak once per day.
- [ ] XP accrues; level-up celebration appears.
- [ ] Badges unlock at thresholds.
- [ ] Weekly challenge progress updates; claim grants XP once.
- [ ] Weekly counters reset on a new week.

## Manual — monetization (use test ids)
- [ ] Banner shows above the bottom nav (free users only).
- [ ] Interstitial appears after a result, respecting the frequency cap.
- [ ] Rewarded ad unlocks a premium experience only after completion.
- [ ] App Open ad shows on resume (not first cold start).
- [ ] Native ad renders in the home feed; in-house promo fallback on failure.
- [ ] Premium purchase / ad-free removes all ads immediately.
- [ ] Restore purchases works on a fresh install.

## Manual — settings & compliance
- [ ] Light/dark/system theme switching works.
- [ ] Language switch (EN/ES/AR) works; Arabic renders right-to-left.
- [ ] Notifications toggle schedules/cancels reminders.
- [ ] Privacy choices re-opens the consent form (where required).
- [ ] Privacy Policy, Terms, and Disclaimer screens open.

## Devices
- [ ] Small phone, large phone, tablet (responsive grid columns).
- [ ] Android 13+ notification permission flow.
- [ ] iOS ATT prompt appears once.
- [ ] Offline: app works; ads simply don't load.
