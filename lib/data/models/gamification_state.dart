import '../../core/constants/app_constants.dart';

/// All persisted progression data. Immutable; mutated via [copyWith] inside the
/// gamification notifier so Riverpod can diff and rebuild cheaply.
class GamificationState {
  const GamificationState({
    this.xp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCheckInDate,
    this.unlockedBadgeIds = const <String>{},
    this.completedChallengeIds = const <String>{},
    this.analysesCompleted = 0,
    this.sharesCount = 0,
    this.distinctTypesTried = const <String>{},
    this.weekStart,
    this.weeklyAnalyses = 0,
    this.weeklyShares = 0,
    this.weeklyCheckIns = 0,
  });

  final int xp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCheckInDate;
  final Set<String> unlockedBadgeIds;
  final Set<String> completedChallengeIds;
  final int analysesCompleted;
  final int sharesCount;
  final Set<String> distinctTypesTried;

  // Weekly challenge window + counters (reset every 7 days).
  final DateTime? weekStart;
  final int weeklyAnalyses;
  final int weeklyShares;
  final int weeklyCheckIns;

  int get level => (xp ~/ AppConstants.xpPerLevel) + 1;

  /// XP accumulated within the current level.
  int get xpIntoLevel => xp % AppConstants.xpPerLevel;

  /// 0.0–1.0 progress to the next level.
  double get levelProgress => xpIntoLevel / AppConstants.xpPerLevel;

  /// Unlockable title derived purely from level.
  String get title => titleForLevel(level);

  static String titleForLevel(int level) {
    const List<String> titles = <String>[
      'Curious Soul', // 1
      'Dream Seeker', // 2
      'Aura Explorer', // 3
      'Vibe Reader', // 4
      'Mystic Apprentice', // 5
      'Insight Adept', // 6
      'Cosmic Voyager', // 7
      'Aura Master', // 8
      'Dream Sage', // 9
      'Legendary Oracle', // 10+
    ];
    final int index = (level - 1).clamp(0, titles.length - 1);
    return titles[index];
  }

  GamificationState copyWith({
    int? xp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCheckInDate,
    Set<String>? unlockedBadgeIds,
    Set<String>? completedChallengeIds,
    int? analysesCompleted,
    int? sharesCount,
    Set<String>? distinctTypesTried,
    DateTime? weekStart,
    int? weeklyAnalyses,
    int? weeklyShares,
    int? weeklyCheckIns,
  }) {
    return GamificationState(
      xp: xp ?? this.xp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      completedChallengeIds:
          completedChallengeIds ?? this.completedChallengeIds,
      analysesCompleted: analysesCompleted ?? this.analysesCompleted,
      sharesCount: sharesCount ?? this.sharesCount,
      distinctTypesTried: distinctTypesTried ?? this.distinctTypesTried,
      weekStart: weekStart ?? this.weekStart,
      weeklyAnalyses: weeklyAnalyses ?? this.weeklyAnalyses,
      weeklyShares: weeklyShares ?? this.weeklyShares,
      weeklyCheckIns: weeklyCheckIns ?? this.weeklyCheckIns,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'xp': xp,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastCheckInDate': lastCheckInDate?.toIso8601String(),
        'unlockedBadgeIds': unlockedBadgeIds.toList(),
        'completedChallengeIds': completedChallengeIds.toList(),
        'analysesCompleted': analysesCompleted,
        'sharesCount': sharesCount,
        'distinctTypesTried': distinctTypesTried.toList(),
        'weekStart': weekStart?.toIso8601String(),
        'weeklyAnalyses': weeklyAnalyses,
        'weeklyShares': weeklyShares,
        'weeklyCheckIns': weeklyCheckIns,
      };

  factory GamificationState.fromJson(Map<String, dynamic> json) {
    return GamificationState(
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      lastCheckInDate: json['lastCheckInDate'] == null
          ? null
          : DateTime.parse(json['lastCheckInDate'] as String),
      unlockedBadgeIds:
          (json['unlockedBadgeIds'] as List<dynamic>?)?.cast<String>().toSet() ??
              <String>{},
      completedChallengeIds: (json['completedChallengeIds'] as List<dynamic>?)
              ?.cast<String>()
              .toSet() ??
          <String>{},
      analysesCompleted: (json['analysesCompleted'] as num?)?.toInt() ?? 0,
      sharesCount: (json['sharesCount'] as num?)?.toInt() ?? 0,
      distinctTypesTried: (json['distinctTypesTried'] as List<dynamic>?)
              ?.cast<String>()
              .toSet() ??
          <String>{},
      weekStart: json['weekStart'] == null
          ? null
          : DateTime.parse(json['weekStart'] as String),
      weeklyAnalyses: (json['weeklyAnalyses'] as num?)?.toInt() ?? 0,
      weeklyShares: (json['weeklyShares'] as num?)?.toInt() ?? 0,
      weeklyCheckIns: (json['weeklyCheckIns'] as num?)?.toInt() ?? 0,
    );
  }
}
