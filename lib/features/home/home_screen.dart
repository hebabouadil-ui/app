import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../data/models/analysis_type.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/widgets/disclaimer_banner.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/native_ad_card.dart';
import '../../shared/widgets/section_header.dart';
import '../scan/experience_launcher.dart';
import 'feature_catalog.dart';
import 'widgets/daily_snapshot_card.dart';
import 'widgets/feature_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logScreen('home');
      _dailyCheckIn();
    });
  }

  Future<void> _dailyCheckIn() async {
    final GamificationDelta delta =
        await ref.read(gamificationProvider.notifier).checkInToday();
    if (!mounted) return;
    if (delta.streakIncreased) {
      final int streak = ref.read(gamificationProvider).currentStreak;
      context.showSnack('🔥 $streak day streak! +${delta.xpGained} XP');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final String name = ref.watch(userProvider).displayName;
    final int streak = ref.watch(gamificationProvider).currentStreak;
    final bool unlimited = ref.watch(settingsProvider).hasUnlimited;
    final int used = ref.watch(analysisQuotaProvider);

    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: const AppLogo(fontSize: 20),
              actions: <Widget>[
                IconButton(
                  tooltip: l10n.settingsPremium,
                  icon: const Icon(Icons.workspace_premium_rounded),
                  onPressed: () => context.push(AppRoutes.premium),
                ),
                IconButton(
                  tooltip: l10n.settingsTitle,
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(AppRoutes.settings),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          l10n.homeGreeting(name),
                          style: context.textTheme.headlineMedium,
                        ),
                      ),
                      if (streak > 0) _StreakChip(streak: streak),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const DailySnapshotCard(),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: l10n.homeExplore,
                    trailing: unlimited
                        ? null
                        : Chip(
                            label: Text(
                              'Free today: ${(AppConstants.freeAnalysesPerDay - used).clamp(0, AppConstants.freeAnalysesPerDay)}/${AppConstants.freeAnalysesPerDay}',
                            ),
                          ),
                  ),
                  GridView.count(
                    crossAxisCount: context.featureGridColumns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.92,
                    children: <Widget>[
                      for (final AnalysisType type in homeFeatureOrder)
                        FeatureCard(
                          type: type,
                          locked: type.isPremium && !unlimited,
                          onTap: () => startExperience(context, ref, type),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const NativeAdCard(),
                  const SizedBox(height: 20),
                  const DisclaimerBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('🔥', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text('$streak', style: context.textTheme.labelLarge),
        ],
      ),
    );
  }
}
