import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// A compact, always-visible reminder that results are entertainment only.
/// Required for store compliance and shown on result/scan screens.
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: compact ? 8 : 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline,
              size: compact ? 16 : 18, color: theme.colorScheme.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              compact
                  ? AppConstants.shortDisclaimer
                  : AppConstants.entertainmentDisclaimer,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
