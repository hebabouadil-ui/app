import 'package:dream_ai/data/models/gamification_state.dart';
import 'package:dream_ai/features/gamification/gamification_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GamificationState', () {
    test('level and progress math', () {
      expect(const GamificationState(xp: 0).level, 1);
      expect(const GamificationState(xp: 249).level, 1);
      expect(const GamificationState(xp: 250).level, 2);
      expect(const GamificationState(xp: 500).level, 3);
      expect(const GamificationState(xp: 125).levelProgress, closeTo(0.5, 0.001));
    });

    test('title scales with level and clamps at the top', () {
      expect(GamificationState.titleForLevel(1), 'Curious Soul');
      expect(GamificationState.titleForLevel(99),
          GamificationState.titleForLevel(10));
    });

    test('copyWith preserves untouched fields', () {
      const GamificationState s = GamificationState(xp: 100, currentStreak: 3);
      final GamificationState updated = s.copyWith(xp: 200);
      expect(updated.xp, 200);
      expect(updated.currentStreak, 3);
    });

    test('round-trips through JSON', () {
      final GamificationState s = const GamificationState(
        xp: 320,
        currentStreak: 4,
        longestStreak: 9,
        unlockedBadgeIds: <String>{'first_scan', 'streak_3'},
      ).copyWith(weeklyAnalyses: 2);
      final GamificationState back = GamificationState.fromJson(s.toJson());
      expect(back.xp, s.xp);
      expect(back.longestStreak, s.longestStreak);
      expect(back.unlockedBadgeIds, s.unlockedBadgeIds);
      expect(back.weeklyAnalyses, 2);
    });
  });

  group('GamificationCatalog', () {
    test('evaluateBadges unlocks based on thresholds', () {
      const GamificationState s = GamificationState(
        analysesCompleted: 12,
        longestStreak: 7,
        sharesCount: 1,
      );
      final Set<String> badges = GamificationCatalog.evaluateBadges(s);
      expect(badges, containsAll(<String>['first_scan', 'analyses_10', 'streak_3', 'streak_7', 'share_1']));
      expect(badges.contains('analyses_50'), isFalse);
    });

    test('challengeForWeek returns a known challenge', () {
      final challenge = GamificationCatalog.challengeForWeek(DateTime(2026, 6, 16));
      expect(GamificationCatalog.weeklyChallenges.contains(challenge), isTrue);
    });

    test('every badge id resolves', () {
      for (final badge in GamificationCatalog.badges) {
        expect(GamificationCatalog.badgeById(badge.id).id, badge.id);
      }
    });
  });
}
