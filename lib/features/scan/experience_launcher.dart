import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/router/route_args.dart';
import '../../data/models/analysis_type.dart';
import '../../providers/analysis_provider.dart';
import 'unlock_sheet.dart';

/// Single entry point for starting any experience from a home card.
///
/// Handles the unlock flow (premium / over-cap → rewarded ad / credit /
/// purchase) and then routes to the face-scan or analyzing screen.
Future<void> startExperience(
  BuildContext context,
  WidgetRef ref,
  AnalysisType type,
) async {
  final AnalysisController controller = ref.read(analysisControllerProvider);
  final UnlockRequirement requirement = controller.requirementFor(type);

  bool unlocked = false;
  if (requirement != UnlockRequirement.none) {
    unlocked = await showUnlockSheet(context, requirement: requirement);
    if (!unlocked) return; // user backed out
  }
  if (!context.mounted) return;

  if (type.requiresImage) {
    context.push(
      AppRoutes.scan,
      extra: ScanArgs(type: type, alreadyUnlocked: unlocked),
    );
  } else {
    // Date-only experiences skip the camera entirely.
    context.push(
      AppRoutes.analyzing,
      extra: AnalyzingArgs(type: type, countsAgainstQuota: !unlocked),
    );
  }
}
