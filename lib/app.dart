import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'providers/service_providers.dart';
import 'providers/settings_provider.dart';
import 'core/router/app_router.dart';

/// Root widget: wires theme, localization, routing and the app-open-ad
/// lifecycle handler.
class DreamAIApp extends ConsumerStatefulWidget {
  const DreamAIApp({super.key});

  @override
  ConsumerState<DreamAIApp> createState() => _DreamAIAppState();
}

class _DreamAIAppState extends ConsumerState<DreamAIApp>
    with WidgetsBindingObserver {
  bool _firstResumeSkipped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsServiceProvider).logAppOpen();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Don't show an app-open ad on the very first resume (cold start is
      // covered by launch flow) to keep the first impression clean.
      if (!_firstResumeSkipped) {
        _firstResumeSkipped = true;
        return;
      }
      ref.read(adsServiceProvider).showAppOpenIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode =
        ref.watch(settingsProvider.select((SettingsState s) => s.themeMode));
    final Locale? locale =
        ref.watch(settingsProvider.select((SettingsState s) => s.locale));
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Dream AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
