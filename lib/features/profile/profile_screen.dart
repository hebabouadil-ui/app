import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/gamification_state.dart';
import '../../data/models/user_profile.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final TextEditingController controller =
        TextEditingController(text: ref.read(userProvider).displayName);
    final String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Your name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
          decoration: const InputDecoration(hintText: 'Dreamer'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(context.l10n.actionSave),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(userProvider.notifier).setDisplayName(name);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final UserProfile user = ref.watch(userProvider);
    final GamificationState g = ref.watch(gamificationProvider);
    final bool isPremium = ref.watch(settingsProvider).isPremium;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              GlassCard(
                onTap: () => _editName(context, ref),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        gradient: AppGradients.aura,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        user.displayName.characters.first.toUpperCase(),
                        style: context.textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.displayName,
                              style: context.textTheme.titleLarge),
                          Text('${g.title} • ${l10n.rewardsLevel(g.level)}',
                              style: context.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_outlined, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (!isPremium) _PremiumBanner(),
              if (!isPremium) const SizedBox(height: 16),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    _Tile(
                      icon: Icons.card_giftcard_rounded,
                      title: l10n.settingsReferral,
                      onTap: () => context.push(AppRoutes.referral),
                    ),
                    _Tile(
                      icon: Icons.settings_outlined,
                      title: l10n.settingsTitle,
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                    _Tile(
                      icon: Icons.star_rate_rounded,
                      title: l10n.settingsRate,
                      onTap: () =>
                          ref.read(reviewServiceProvider).openStoreListing(),
                    ),
                    _Tile(
                      icon: Icons.privacy_tip_outlined,
                      title: l10n.settingsPrivacy,
                      onTap: () => context.push(AppRoutes.privacy),
                    ),
                    _Tile(
                      icon: Icons.description_outlined,
                      title: l10n.settingsTerms,
                      onTap: () => context.push(AppRoutes.terms),
                    ),
                    _Tile(
                      icon: Icons.info_outline,
                      title: l10n.settingsDisclaimer,
                      onTap: () => context.push(AppRoutes.disclaimer),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radius),
      onTap: () => context.push(AppRoutes.premium),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppGradients.sunrise,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: <Widget>[
            const Text('👑', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(context.l10n.premiumTitle,
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: Colors.white)),
                  Text(context.l10n.premiumSubtitle,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        if (showDivider) const Divider(height: 1, indent: 56),
      ],
    );
  }
}
