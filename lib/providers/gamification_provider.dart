import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';
import '../data/models/analysis_type.dart';
import '../data/models/badge.dart';
import '../data/models/challenge.dart';
import '../data/models/gamification_state.dart';
import '../features/gamification/gamification_catalog.dart';
import 'service_providers.dart';

/// Describes what changed after an action, so the UI can celebrate (confetti,
/// badge popups, level-up sheet) without re-deriving anything.
class GamificationDelta {
  const GamificationDelta({
    this.xpGained = 0,
    this.newBadges = const <AchievementBadge>[],
    this.leveledUp = false,
    this.newLevel = 1,
    this.streakIncreased = false,
  });

  final int xpGained;
  final List<AchievementBadge> newBadges;
  final bool leveledUp;
  final int newLevel;
  final bool streakIncreased;

  bool get hasCelebration =>
      newBadges.isNotEmpty || leveledUp || streakIncreased;
}

class GamificationNotifier extends Notifier<GamificationState> {
  @override
  GamificationState build() {
    final storage = ref.read(storageServiceProvider);
    final Map<String, dynamic>? json = storage.readJson(
        StorageKeys.gamificationBox, StorageKeys.gamificationState);
    GamificationState loaded = json == null
        ? const GamificationState()
        : GamificationState.fromJson(json);

    // Roll the weekly window forward if needed.
    final GamificationState rolled = _ensureWeek(loaded);
    if (rolled != loaded) {
      loaded = rolled;
      Future<void>.microtask(() => _persist(loaded));
    }
    return loaded;
  }

  // ---- Public actions -------------------------------------------------------

  Future<GamificationDelta> recordAnalysis(AnalysisType type) async {
    final GamificationState base = _ensureWeek(state);
    final GamificationState updated = base.copyWith(
      analysesCompleted: base.analysesCompleted + 1,
      weeklyAnalyses: base.weeklyAnalyses + 1,
      distinctTypesTried: <String>{...base.distinctTypesTried, type.id},
    );
    return _commit(updated, AppConstants.xpPerAnalysis);
  }

  Future<GamificationDelta> recordShare() async {
    final GamificationState base = _ensureWeek(state);
    final GamificationState updated = base.copyWith(
      sharesCount: base.sharesCount + 1,
      weeklyShares: base.weeklyShares + 1,
    );
    return _commit(updated, AppConstants.xpPerShare);
  }

  /// Daily streak check-in. Call once when the app is opened.
  Future<GamificationDelta> checkInToday() async {
    final GamificationState base = _ensureWeek(state);
    final DateTime today = _dateOnly(DateTime.now());
    final DateTime? last =
        base.lastCheckInDate == null ? null : _dateOnly(base.lastCheckInDate!);

    if (last != null && last == today) {
      // Already checked in today — no XP, no streak change.
      if (base != state) {
        state = base;
        await _persist(base);
      }
      return const GamificationDelta();
    }

    final bool consecutive =
        last != null && today.difference(last).inDays == 1;
    final int newStreak = consecutive ? base.currentStreak + 1 : 1;

    final GamificationState updated = base.copyWith(
      currentStreak: newStreak,
      longestStreak:
          newStreak > base.longestStreak ? newStreak : base.longestStreak,
      lastCheckInDate: today,
      weeklyCheckIns: base.weeklyCheckIns + 1,
    );
    ref.read(analyticsServiceProvider).logStreak(newStreak);
    final GamificationDelta delta =
        await _commit(updated, AppConstants.xpPerDailyCheckIn);
    return GamificationDelta(
      xpGained: delta.xpGained,
      newBadges: delta.newBadges,
      leveledUp: delta.leveledUp,
      newLevel: delta.newLevel,
      streakIncreased: true,
    );
  }

  Future<GamificationDelta> claimWeeklyChallenge() async {
    final GamificationState base = _ensureWeek(state);
    final WeeklyChallenge challenge =
        GamificationCatalog.challengeForWeek(DateTime.now());
    final int progress = GamificationCatalog.currentProgress(challenge, base);
    if (progress < challenge.target ||
        base.completedChallengeIds.contains(challenge.id)) {
      return const GamificationDelta();
    }
    final GamificationState updated = base.copyWith(
      completedChallengeIds: <String>{
        ...base.completedChallengeIds,
        challenge.id,
      },
    );
    ref.read(analyticsServiceProvider).logChallengeCompleted(challenge.id);
    return _commit(updated, challenge.xpReward);
  }

  Future<GamificationDelta> addReferralXp() =>
      _commit(_ensureWeek(state), AppConstants.xpPerReferral);

  // ---- Internals ------------------------------------------------------------

  /// Applies an XP gain, recomputes badges, detects level-up, persists, and
  /// returns the delta for the UI to celebrate.
  Future<GamificationDelta> _commit(
      GamificationState updated, int xpGained) async {
    final int oldLevel = state.level;
    GamificationState next = updated.copyWith(xp: updated.xp + xpGained);

    final Set<String> unlocked = GamificationCatalog.evaluateBadges(next);
    final Set<String> newlyUnlocked =
        unlocked.difference(next.unlockedBadgeIds);
    next = next.copyWith(unlockedBadgeIds: unlocked);

    state = next;
    await _persist(next);

    final analytics = ref.read(analyticsServiceProvider);
    for (final String id in newlyUnlocked) {
      analytics.logBadgeUnlocked(id);
    }
    final bool leveledUp = next.level > oldLevel;
    if (leveledUp) analytics.logLevelUp(next.level);

    return GamificationDelta(
      xpGained: xpGained,
      newBadges:
          newlyUnlocked.map(GamificationCatalog.badgeById).toList(),
      leveledUp: leveledUp,
      newLevel: next.level,
    );
  }

  GamificationState _ensureWeek(GamificationState s) {
    final DateTime currentWeek = _weekStart(DateTime.now());
    if (s.weekStart == null) {
      return s.copyWith(weekStart: currentWeek);
    }
    if (_dateOnly(s.weekStart!) != currentWeek) {
      // New week: reset weekly counters.
      return s.copyWith(
        weekStart: currentWeek,
        weeklyAnalyses: 0,
        weeklyShares: 0,
        weeklyCheckIns: 0,
      );
    }
    return s;
  }

  Future<void> _persist(GamificationState s) async {
    await ref.read(storageServiceProvider).writeJson(
        StorageKeys.gamificationBox, StorageKeys.gamificationState, s.toJson());
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _weekStart(DateTime d) {
    final DateTime date = _dateOnly(d);
    return date.subtract(Duration(days: date.weekday - 1)); // Monday
  }
}

final gamificationProvider =
    NotifierProvider<GamificationNotifier, GamificationState>(
        GamificationNotifier.new);

/// The active weekly challenge (recomputed each build; cheap).
final activeChallengeProvider = Provider<WeeklyChallenge>(
  (Ref ref) => GamificationCatalog.challengeForWeek(DateTime.now()),
);
