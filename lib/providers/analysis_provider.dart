import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';
import '../data/models/analysis_result.dart';
import '../data/models/analysis_type.dart';
import '../data/models/face_features.dart';
import 'gamification_provider.dart';
import 'service_providers.dart';
import 'settings_provider.dart';
import 'user_provider.dart';

/// Most-recent-first history of generated results, persisted to Hive.
class AnalysisHistoryNotifier extends Notifier<List<AnalysisResult>> {
  static const String _key = 'history';

  @override
  List<AnalysisResult> build() {
    final storage = ref.read(storageServiceProvider);
    return storage
        .readJsonList(StorageKeys.resultsBox, _key)
        .map(AnalysisResult.fromJson)
        .toList();
  }

  Future<void> add(AnalysisResult result) async {
    await ref
        .read(storageServiceProvider)
        .pushJsonList(StorageKeys.resultsBox, _key, result.toJson());
    state = <AnalysisResult>[result, ...state];
  }

  Future<void> clear() async {
    await ref.read(storageServiceProvider).delete(StorageKeys.resultsBox, _key);
    state = <AnalysisResult>[];
  }
}

final analysisHistoryProvider =
    NotifierProvider<AnalysisHistoryNotifier, List<AnalysisResult>>(
        AnalysisHistoryNotifier.new);

/// Number of free analyses used today (auto-resets at midnight).
class AnalysisQuotaNotifier extends Notifier<int> {
  @override
  int build() {
    final storage = ref.read(storageServiceProvider);
    final String? savedDate = storage.read<String>(
        StorageKeys.settingsBox, StorageKeys.analysesTodayDate);
    final String today = _todayKey();
    if (savedDate != today) {
      Future<void>.microtask(_reset);
      return 0;
    }
    return storage.read<int>(
            StorageKeys.settingsBox, StorageKeys.analysesToday,
            defaultValue: 0) ??
        0;
  }

  Future<void> increment() async {
    final storage = ref.read(storageServiceProvider);
    final int next = state + 1;
    await storage.write(
        StorageKeys.settingsBox, StorageKeys.analysesToday, next);
    await storage.write(
        StorageKeys.settingsBox, StorageKeys.analysesTodayDate, _todayKey());
    state = next;
  }

  Future<void> _reset() async {
    final storage = ref.read(storageServiceProvider);
    await storage.write(StorageKeys.settingsBox, StorageKeys.analysesToday, 0);
    await storage.write(
        StorageKeys.settingsBox, StorageKeys.analysesTodayDate, _todayKey());
    state = 0;
  }

  int get remaining =>
      (AppConstants.freeAnalysesPerDay - state).clamp(0, AppConstants.freeAnalysesPerDay);

  String _todayKey() {
    final DateTime d = DateTime.now();
    return '${d.year}-${d.month}-${d.day}';
  }
}

final analysisQuotaProvider =
    NotifierProvider<AnalysisQuotaNotifier, int>(AnalysisQuotaNotifier.new);

/// Why an experience can't be run immediately.
enum UnlockRequirement {
  /// Free to run right now.
  none,

  /// Free-tier daily cap reached (unlock via rewarded ad / premium / credit).
  capReached,

  /// Premium-only experience on a non-premium account.
  premiumLocked,
}

/// The output of running an experience, bundling the result with any
/// gamification celebration to show.
typedef AnalysisOutcome = ({AnalysisResult result, GamificationDelta delta});

/// Coordinates generation, persistence, quota, gamification and analytics.
class AnalysisController {
  AnalysisController(this.ref);

  final Ref ref;

  /// Determines whether [type] needs an unlock before running.
  UnlockRequirement requirementFor(AnalysisType type) {
    final SettingsState settings = ref.read(settingsProvider);
    if (settings.hasUnlimited) return UnlockRequirement.none;
    if (type.isPremium) return UnlockRequirement.premiumLocked;
    final int used = ref.read(analysisQuotaProvider);
    if (used >= AppConstants.freeAnalysesPerDay) {
      return UnlockRequirement.capReached;
    }
    return UnlockRequirement.none;
  }

  /// Runs an experience and returns the result + celebration delta.
  /// [countsAgainstQuota] is false when the run was unlocked by a rewarded ad,
  /// referral credit, or premium.
  Future<AnalysisOutcome> run({
    required AnalysisType type,
    required FaceFeatures features,
    bool countsAgainstQuota = true,
  }) async {
    final analytics = ref.read(analyticsServiceProvider);
    analytics.logAnalysisStarted(type.id);

    final AnalysisResult result = ref.read(resultGeneratorProvider).generate(
          type: type,
          features: features,
          salt: ref.read(userProvider).id,
        );

    await ref.read(analysisHistoryProvider.notifier).add(result);
    if (countsAgainstQuota) {
      await ref.read(analysisQuotaProvider.notifier).increment();
    }
    final GamificationDelta delta =
        await ref.read(gamificationProvider.notifier).recordAnalysis(type);

    analytics.logAnalysisCompleted(type.id, result.primaryScore);
    ref.read(reviewServiceProvider).recordPositiveInteraction();

    return (result: result, delta: delta);
  }

  /// Friendship compatibility from two scanned faces.
  Future<AnalysisOutcome> runFriendship({
    required FaceFeatures a,
    required FaceFeatures b,
    bool countsAgainstQuota = true,
  }) async {
    final analytics = ref.read(analyticsServiceProvider);
    analytics.logAnalysisStarted(AnalysisType.friendshipCompatibility.id);
    final AnalysisResult result =
        ref.read(resultGeneratorProvider).generateFriendship(
              a,
              b,
              salt: ref.read(userProvider).id,
            );
    await ref.read(analysisHistoryProvider.notifier).add(result);
    if (countsAgainstQuota) {
      await ref.read(analysisQuotaProvider.notifier).increment();
    }
    final GamificationDelta delta = await ref
        .read(gamificationProvider.notifier)
        .recordAnalysis(AnalysisType.friendshipCompatibility);
    analytics.logAnalysisCompleted(
        AnalysisType.friendshipCompatibility.id, result.primaryScore);
    ref.read(reviewServiceProvider).recordPositiveInteraction();
    return (result: result, delta: delta);
  }
}

final analysisControllerProvider =
    Provider<AnalysisController>((Ref ref) => AnalysisController(ref));
