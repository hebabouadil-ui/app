import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/context_extensions.dart';
import '../../shared/widgets/banner_ad_widget.dart';

/// Hosts the four primary tabs and the persistent bottom navigation + banner.
class RootShell extends ConsumerWidget {
  const RootShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _onTap(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const BannerAdWidget(),
          NavigationBar(
            selectedIndex: shell.currentIndex,
            onDestinationSelected: _onTap,
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_rounded),
                label: context.l10n.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.auto_graph_outlined),
                selectedIcon: const Icon(Icons.auto_graph_rounded),
                label: context.l10n.navPredictions,
              ),
              NavigationDestination(
                icon: const Icon(Icons.emoji_events_outlined),
                selectedIcon: const Icon(Icons.emoji_events_rounded),
                label: context.l10n.navRewards,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: context.l10n.navProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
