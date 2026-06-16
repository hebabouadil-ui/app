import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../data/models/analysis_type.dart';
import '../../../shared/widgets/glass_card.dart';
import '../feature_catalog.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.type,
    required this.onTap,
    this.locked = false,
  });

  final AnalysisType type;
  final VoidCallback onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final FeatureCopy copy = featureCopy(context, type);
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppGradients.byName(type.gradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(type.icon, color: Colors.white, size: 24),
              ),
              if (locked)
                Icon(Icons.lock_rounded,
                    size: 18,
                    color: context.colors.onSurface.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            copy.title,
            style: context.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            copy.description,
            style: context.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
