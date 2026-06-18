import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';

/// Bottom sheet offering ways to unlock a premium/over-cap experience:
/// watch a rewarded ad, spend a referral credit, or go Premium.
/// Returns true if the experience was unlocked for this run.
Future<bool> showUnlockSheet(
  BuildContext context, {
  required UnlockRequirement requirement,
}) async {
  final bool? result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _UnlockSheet(requirement: requirement),
  );
  return result ?? false;
}

class _UnlockSheet extends ConsumerStatefulWidget {
  const _UnlockSheet({required this.requirement});
  final UnlockRequirement requirement;

  @override
  ConsumerState<_UnlockSheet> createState() => _UnlockSheetState();
}

class _UnlockSheetState extends ConsumerState<_UnlockSheet> {
  bool _busy = false;

  int _adsWatched = 0;

  Future<void> _watchAd() async {
    final int required = ref.read(appConfigProvider).rewardedAdsToUnlock;
    setState(() => _busy = true);
    final ads = ref.read(adsServiceProvider);
    final bool earned = await ads.showRewarded();
    if (!mounted) return;
    setState(() => _busy = false);
    if (!earned) {
      context.showSnack('Ad not ready yet — please try again.');
      return;
    }
    ref.read(analyticsServiceProvider).logRewardEarned('unlock_experience');
    setState(() => _adsWatched++);
    if (_adsWatched >= required) {
      Navigator.of(context).pop(true);
    } else {
      context.showSnack('Nice! Watch ${required - _adsWatched} more to unlock.');
    }
  }

  Future<void> _useCredit() async {
    final bool spent = await ref.read(userProvider.notifier).spendReferralCredit();
    if (!mounted) return;
    if (spent) {
      Navigator.of(context).pop(true);
    } else {
      context.showSnack('No referral credits available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final int credits = ref.watch(userProvider).referralCredits;
    final bool rewardedReady = ref.read(adsServiceProvider).isRewardedReady;

    final String title = widget.requirement == UnlockRequirement.premiumLocked
        ? l10n.premiumLockedTitle
        : l10n.premiumCapTitle;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(title, style: context.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('Choose how to continue:', style: context.textTheme.bodyMedium),
          const SizedBox(height: 20),
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...<Widget>[
            Builder(builder: (BuildContext context) {
              final int required =
                  ref.read(appConfigProvider).rewardedAdsToUnlock;
              final String label = required > 1
                  ? '${l10n.premiumWatchAd} ($_adsWatched/$required)'
                  : l10n.premiumWatchAd;
              return FilledButton.icon(
                onPressed: rewardedReady ? _watchAd : null,
                icon: const Icon(Icons.play_circle_fill_rounded),
                label: Text(label),
              );
            }),
            const SizedBox(height: 10),
            if (credits > 0)
              OutlinedButton.icon(
                onPressed: _useCredit,
                icon: const Icon(Icons.redeem_rounded),
                label: Text('${l10n.premiumUseCredit} ($credits)'),
              ),
            if (credits > 0) const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(false);
                context.push(AppRoutes.premium);
              },
              icon: const Icon(Icons.workspace_premium_rounded),
              label: Text(l10n.settingsPremium),
            ),
          ],
        ],
      ),
    );
  }
}
