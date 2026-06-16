import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/analysis_result.dart';
import '../../features/home/home_screen.dart';
import '../../features/legal/disclaimer_screen.dart';
import '../../features/legal/privacy_policy_screen.dart';
import '../../features/legal/terms_screen.dart';
import '../../features/navigation/root_shell.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/predictions/predictions_screen.dart';
import '../../features/premium/premium_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/referral/referral_screen.dart';
import '../../features/rewards/rewards_screen.dart';
import '../../features/scan/analyzing_screen.dart';
import '../../features/scan/result_screen.dart';
import '../../features/scan/scan_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../providers/analysis_provider.dart';
import '../../providers/settings_provider.dart';
import 'app_routes.dart';
import 'route_args.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

/// Builds the app's [GoRouter]. Redirects to onboarding until it's complete.
final goRouterProvider = Provider<GoRouter>((Ref ref) {
  // Refresh routing whenever onboarding completion flips.
  final ValueNotifier<int> refresh = ValueNotifier<int>(0);
  ref.listen(settingsProvider.select((SettingsState s) => s.onboardingComplete),
      (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (BuildContext context, GoRouterState state) {
      final bool onboarded = ref.read(settingsProvider).onboardingComplete;
      final bool atOnboarding =
          state.matchedLocation == AppRoutes.onboarding;
      if (!onboarded && !atOnboarding) return AppRoutes.onboarding;
      if (onboarded && atOnboarding) return AppRoutes.home;
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),

      // Bottom-nav shell with 4 tabs preserving their own state.
      StatefulShellRoute.indexedStack(
        builder: (_, __, StatefulNavigationShell shell) =>
            RootShell(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.predictions,
                builder: (_, __) => const PredictionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.rewards,
                builder: (_, __) => const RewardsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Full-screen flows pushed above the shell.
      GoRoute(
        path: AppRoutes.scan,
        parentNavigatorKey: _rootKey,
        builder: (_, GoRouterState state) =>
            ScanScreen(args: state.extra! as ScanArgs),
      ),
      GoRoute(
        path: AppRoutes.analyzing,
        parentNavigatorKey: _rootKey,
        builder: (_, GoRouterState state) =>
            AnalyzingScreen(args: state.extra! as AnalyzingArgs),
      ),
      GoRoute(
        path: AppRoutes.result,
        parentNavigatorKey: _rootKey,
        builder: (_, GoRouterState state) {
          final AnalysisOutcome outcome = state.extra! as AnalysisOutcome;
          return ResultScreen(result: outcome.result, delta: outcome.delta);
        },
      ),
      GoRoute(
        path: AppRoutes.premium,
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const PremiumScreen(),
      ),
      GoRoute(
        path: AppRoutes.referral,
        builder: (_, __) => const ReferralScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (_, __) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (_, __) => const TermsScreen(),
      ),
      GoRoute(
        path: AppRoutes.disclaimer,
        builder: (_, __) => const DisclaimerScreen(),
      ),
    ],
    errorBuilder: (_, GoRouterState state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

/// Re-export so result screen can reference the outcome type cleanly.
typedef RouteAnalysisResult = AnalysisResult;
