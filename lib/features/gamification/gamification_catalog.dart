import '../../data/models/badge.dart';
import '../../data/models/challenge.dart';
import '../../data/models/gamification_state.dart';

/// Static catalogs + pure unlock logic for badges and weekly challenges.
abstract final class GamificationCatalog {
  static const List<AchievementBadge> badges = <AchievementBadge>[
    AchievementBadge(
      id: 'first_scan',
      title: 'First Glimpse',
      description: 'Complete your first analysis',
      emoji: '🌱',
      gradientName: 'ocean',
    ),
    AchievementBadge(
      id: 'streak_3',
      title: 'On a Roll',
      description: 'Reach a 3-day streak',
      emoji: '🔥',
      gradientName: 'sunrise',
    ),
    AchievementBadge(
      id: 'streak_7',
      title: 'Week Warrior',
      description: 'Reach a 7-day streak',
      emoji: '⚡',
      gradientName: 'royal',
    ),
    AchievementBadge(
      id: 'streak_30',
      title: 'Unstoppable',
      description: 'Reach a 30-day streak',
      emoji: '💎',
      gradientName: 'aura',
    ),
    AchievementBadge(
      id: 'analyses_10',
      title: 'Explorer',
      description: 'Complete 10 analyses',
      emoji: '🧭',
      gradientName: 'dusk',
    ),
    AchievementBadge(
      id: 'analyses_50',
      title: 'Connoisseur',
      description: 'Complete 50 analyses',
      emoji: '🏅',
      gradientName: 'royal',
    ),
    AchievementBadge(
      id: 'share_1',
      title: 'Spreading Vibes',
      description: 'Share your first result',
      emoji: '📣',
      gradientName: 'romance',
    ),
    AchievementBadge(
      id: 'share_10',
      title: 'Influencer',
      description: 'Share 10 results',
      emoji: '🌟',
      gradientName: 'sunrise',
    ),
    AchievementBadge(
      id: 'all_types',
      title: 'Completionist',
      description: 'Try every kind of analysis',
      emoji: '🗺️',
      gradientName: 'aura',
    ),
    AchievementBadge(
      id: 'level_5',
      title: 'Rising Star',
      description: 'Reach level 5',
      emoji: '🚀',
      gradientName: 'dusk',
    ),
  ];

  static AchievementBadge badgeById(String id) =>
      badges.firstWhere((AchievementBadge b) => b.id == id);

  /// A rotating set of weekly challenges. The "active" one is chosen from the
  /// ISO week number so it changes every week deterministically.
  static const List<WeeklyChallenge> weeklyChallenges = <WeeklyChallenge>[
    WeeklyChallenge(
      id: 'w_analyses_5',
      title: 'Curiosity Week',
      description: 'Complete 5 analyses this week',
      emoji: '🔍',
      metric: ChallengeMetric.analyses,
      target: 5,
      xpReward: 120,
    ),
    WeeklyChallenge(
      id: 'w_share_3',
      title: 'Share the Vibes',
      description: 'Share 3 results this week',
      emoji: '💌',
      metric: ChallengeMetric.shares,
      target: 3,
      xpReward: 150,
    ),
    WeeklyChallenge(
      id: 'w_checkin_5',
      title: 'Daily Devotee',
      description: 'Check in 5 days this week',
      emoji: '📅',
      metric: ChallengeMetric.checkIns,
      target: 5,
      xpReward: 140,
    ),
    WeeklyChallenge(
      id: 'w_types_4',
      title: 'Variety Hour',
      description: 'Try 4 different analyses this week',
      emoji: '🎨',
      metric: ChallengeMetric.distinctTypes,
      target: 4,
      xpReward: 160,
    ),
  ];

  /// Deterministically pick this week's challenge.
  static WeeklyChallenge challengeForWeek(DateTime date) {
    final int week = _isoWeekNumber(date);
    return weeklyChallenges[week % weeklyChallenges.length];
  }

  static int currentProgress(WeeklyChallenge challenge, GamificationState s) {
    switch (challenge.metric) {
      case ChallengeMetric.analyses:
        return s.weeklyAnalyses;
      case ChallengeMetric.shares:
        return s.weeklyShares;
      case ChallengeMetric.checkIns:
        return s.weeklyCheckIns;
      case ChallengeMetric.distinctTypes:
        return s.distinctTypesTried.length;
    }
  }

  /// Evaluates which badge ids should be unlocked given current state.
  static Set<String> evaluateBadges(GamificationState s) {
    final Set<String> unlocked = <String>{...s.unlockedBadgeIds};
    void unlock(String id, bool condition) {
      if (condition) unlocked.add(id);
    }

    unlock('first_scan', s.analysesCompleted >= 1);
    unlock('streak_3', s.longestStreak >= 3);
    unlock('streak_7', s.longestStreak >= 7);
    unlock('streak_30', s.longestStreak >= 30);
    unlock('analyses_10', s.analysesCompleted >= 10);
    unlock('analyses_50', s.analysesCompleted >= 50);
    unlock('share_1', s.sharesCount >= 1);
    unlock('share_10', s.sharesCount >= 10);
    unlock('all_types', s.distinctTypesTried.length >= 10);
    unlock('level_5', s.level >= 5);
    return unlocked;
  }

  static int _isoWeekNumber(DateTime date) {
    final DateTime thursday =
        date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));
    final DateTime firstThursday = DateTime(thursday.year, 1, 4);
    final int diff = thursday.difference(firstThursday).inDays;
    return 1 + (diff ~/ 7);
  }
}
