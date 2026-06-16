import 'package:flutter/widgets.dart';

import '../../core/extensions/context_extensions.dart';
import '../../data/models/analysis_type.dart';

/// Localized display copy for each [AnalysisType]. Kept in one place so the
/// home grid, result screen and history all read consistently.
typedef FeatureCopy = ({String title, String description});

FeatureCopy featureCopy(BuildContext context, AnalysisType type) {
  final l10n = context.l10n;
  switch (type) {
    case AnalysisType.auraScore:
      return (title: l10n.featureAuraTitle, description: l10n.featureAuraDesc);
    case AnalysisType.personality:
      return (
        title: l10n.featurePersonalityTitle,
        description: l10n.featurePersonalityDesc
      );
    case AnalysisType.firstImpression:
      return (
        title: l10n.featureFirstImpressionTitle,
        description: l10n.featureFirstImpressionDesc
      );
    case AnalysisType.leadership:
      return (
        title: l10n.featureLeadershipTitle,
        description: l10n.featureLeadershipDesc
      );
    case AnalysisType.romanticStyle:
      return (
        title: l10n.featureRomanticTitle,
        description: l10n.featureRomanticDesc
      );
    case AnalysisType.dailyLuck:
      return (title: l10n.featureLuckTitle, description: l10n.featureLuckDesc);
    case AnalysisType.futureMood:
      return (title: l10n.featureMoodTitle, description: l10n.featureMoodDesc);
    case AnalysisType.friendshipCompatibility:
      return (
        title: l10n.featureFriendshipTitle,
        description: l10n.featureFriendshipDesc
      );
    case AnalysisType.celebrityLookAlike:
      return (
        title: l10n.featureCelebrityTitle,
        description: l10n.featureCelebrityDesc
      );
    case AnalysisType.positiveMessage:
      return (
        title: l10n.featurePositiveTitle,
        description: l10n.featurePositiveDesc
      );
  }
}

/// The display order on the home screen.
const List<AnalysisType> homeFeatureOrder = <AnalysisType>[
  AnalysisType.auraScore,
  AnalysisType.personality,
  AnalysisType.firstImpression,
  AnalysisType.leadership,
  AnalysisType.romanticStyle,
  AnalysisType.dailyLuck,
  AnalysisType.futureMood,
  AnalysisType.friendshipCompatibility,
  AnalysisType.celebrityLookAlike,
  AnalysisType.positiveMessage,
];
