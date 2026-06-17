import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../data/models/user_profile.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String _inviteText(String code) =>
      'Join me on Dream AI ✨ AI face & palm readings + daily predictions!\n'
      'Use my code $code in Settings → Invite to get bonus credits.\n'
      '${AppConstants.playStoreUrl}';

  Future<void> _shareInvite(String code) async {
    final String text = _inviteText(code);
    final bool shared =
        await ref.read(shareServiceProvider).shareText(text);
    ref.read(analyticsServiceProvider).logReferral('invite_sent');
    if (!shared && mounted) {
      // No share target (e.g. emulator) — copy so it still "works".
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) context.showSnack('Invite copied to clipboard');
    }
  }

  Future<void> _apply() async {
    final bool ok =
        await ref.read(userProvider.notifier).applyReferralCode(_codeController.text);
    if (!mounted) return;
    if (ok) {
      await ref.read(gamificationProvider.notifier).addReferralXp();
      if (mounted) context.showSnack(context.l10n.referralApplied);
    } else {
      context.showSnack(context.l10n.referralInvalid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final UserProfile user = ref.watch(userProvider);
    final bool alreadyReferred = user.referredBy != null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.referralTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppGradients.romance,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: <Widget>[
                    const Text('🎁', style: TextStyle(fontSize: 52)),
                    const SizedBox(height: 12),
                    Text(l10n.referralSubtitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(l10n.referralYourCode, style: context.textTheme.titleSmall),
              const SizedBox(height: 8),
              GlassCard(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SelectableText(
                        user.referralCode,
                        style: context.textTheme.headlineSmall
                            ?.copyWith(letterSpacing: 4),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: user.referralCode));
                        context.showSnack('Code copied');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _shareInvite(user.referralCode),
                icon: const Icon(Icons.share_rounded),
                label: Text(l10n.referralShare),
              ),
              const SizedBox(height: 12),
              GlassCard(
                gradient: AppGradients.ocean,
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.stars_rounded, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(l10n.referralCredits(user.referralCredits),
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.referralEnterCode, style: context.textTheme.titleSmall),
              const SizedBox(height: 8),
              if (alreadyReferred)
                GlassCard(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.check_circle, color: Color(0xFF34D399)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('You used code ${user.referredBy}',
                            style: context.textTheme.bodyMedium),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: 'ABC123',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _apply,
                      child: Text(l10n.referralApply),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
