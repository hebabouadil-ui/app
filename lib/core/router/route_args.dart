import '../../data/models/analysis_type.dart';

/// Arguments passed to the scan screen.
class ScanArgs {
  const ScanArgs({
    required this.type,
    this.alreadyUnlocked = false,
    this.secondFace = false,
  });

  final AnalysisType type;

  /// True when a rewarded ad / credit already unlocked this run, so it should
  /// not count against the free daily quota.
  final bool alreadyUnlocked;

  /// True when capturing the *second* face for friendship compatibility.
  final bool secondFace;
}

/// Arguments passed to the analyzing screen, which runs detection + generation.
class AnalyzingArgs {
  const AnalyzingArgs({
    required this.type,
    this.imagePath,
    this.secondImagePath,
    this.countsAgainstQuota = true,
  });

  final AnalysisType type;

  /// Null for date-only experiences (daily luck, future mood, positive msg).
  final String? imagePath;

  /// Second face for friendship compatibility.
  final String? secondImagePath;

  final bool countsAgainstQuota;
}
