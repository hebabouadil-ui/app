import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/badge.dart';
import '../../data/models/challenge.dart';
import '../../data/models/gamification_state.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/service_providers.dart';
import '../gamification/gamification_catalog.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/section_header.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(analyticsServiceProvider).logScreen('rewards'));
  }

  Future<void> _claim() async {
    final GamificationDelta delta =
        await ref.read(gamificationProvider.notifier).claimWeeklyChallenge();
    if (!mounted) return;
    if (delta.xpGained > 0) {
      context.showSnack('🎉 Challenge complete! +${delta.xpGained} XP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final GamificationState s = ref.watch(gamificationProvider);
    final WeeklyChallenge challenge = ref.watch(activeChallengeProvider);
    final int progress = GamificationCatalog.currentProgress(challenge, s);
    final bool claimed = s.completedChallengeIds.contains(challenge.id);
    final bool canClaim = progress >= challenge.target && !claimed;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rewardsTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              _LevelCard(state: s),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatTile(
                        emoji: '🔥',
                        value: '${s.currentStreak}',
                        label: l10n.rewardsStreak),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                        emoji: '🧪',
                        value: '${s.analysesCompleted}',
                        label: 'Analyses'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                        emoji: '📣',
                        value: '${s.sharesCount}',
                        label: 'Shares'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.rewardsChallenge),
              _ChallengeCard(
                challenge: challenge,
                progress: progress,
                claimed: claimed,
                canClaim: canClaim,
                onClaim: _claim,
              ),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.rewardsBadges),
              GridView.count(
                crossAxisCount: context.isTablet ? 4 : 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: <Widget>[
                  for (final AchievementBadge badge
                      in GamificationCatalog.badges)
                    _BadgeTile(
                      badge: badge,
                      unlocked: s.unlockedBadgeIds.contains(badge.id),
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

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.state});
  final GamificationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppGradients.royal,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.rewardsLevel(state.level),
                      style: context.textTheme.headlineMedium
                          ?.copyWith(color: Colors.white)),
                  Text(state.title,
                      style: context.textTheme.titleSmall
                          ?.copyWith(color: Colors.white70)),
                ],
              ),
              const Text('🏅', style: TextStyle(fontSize: 44)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.levelProgress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text('${state.xpIntoLevel} / ${AppConstants.xpPerLevel} XP to next level',
              style:
                  context.textTheme.labelSmall?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.emoji, required this.value, required this.label});
  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(value, style: context.textTheme.titleLarge),
          Text(label, style: context.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.progress,
    required this.claimed,
    required this.canClaim,
    required this.onClaim,
  });

  final WeeklyChallenge challenge;
  final int progress;
  final bool claimed;
  final bool canClaim;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final double pct = (progress / challenge.target).clamp(0.0, 1.0);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(challenge.emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(challenge.title, style: context.textTheme.titleMedium),
                    Text(challenge.description,
                        style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('+${challenge.xpReward} XP',
                    style: context.textTheme.labelMedium
                        ?.copyWith(color: context.colors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor:
                  context.colors.onSurface.withValues(alpha: 0.08),
            ),
          ),
          const SizedBox(height: 6),
          Text('$progress / ${challenge.target}',
              style: context.textTheme.labelSmall),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canClaim ? onClaim : null,
              child: Text(claimed
                  ? l10n.rewardsClaimed
                  : canClaim
                      ? l10n.rewardsClaim
                      : l10n.rewardsLocked),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge, required this.unlocked});
  final AchievementBadge badge;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.4,
      child: GlassCard(
        gradient: unlocked ? AppGradients.byName(badge.gradientName) : null,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(unlocked ? badge.emoji : '🔒',
                style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 6),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                color: unlocked ? Colors.white : context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
