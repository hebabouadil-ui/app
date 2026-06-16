import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/section_header.dart';

/// Supported UI locales (null == follow system).
const Map<String, Locale?> _localeOptions = <String, Locale?>{
  'System': null,
  'English': Locale('en'),
  'Español': Locale('es'),
  'العربية': Locale('ar'),
};

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final Locale? current = ref.read(settingsProvider).locale;
    final String? choice = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: Text(context.l10n.settingsLanguage),
        children: <Widget>[
          for (final MapEntry<String, Locale?> e in _localeOptions.entries)
            RadioListTile<String>(
              value: e.key,
              groupValue: _localeOptions.entries
                  .firstWhere(
                    (MapEntry<String, Locale?> x) =>
                        x.value?.languageCode == current?.languageCode,
                    orElse: () => _localeOptions.entries.first,
                  )
                  .key,
              title: Text(e.key),
              onChanged: (String? v) => Navigator.pop(context, v),
            ),
        ],
      ),
    );
    if (choice != null) {
      await ref.read(settingsProvider.notifier).setLocale(_localeOptions[choice]);
    }
  }

  Future<void> _privacyChoices(BuildContext context, WidgetRef ref) async {
    final consent = ref.read(consentServiceProvider);
    if (await consent.isPrivacyOptionsRequired()) {
      await consent.showPrivacyOptions();
    } else if (context.mounted) {
      context.showSnack('No additional privacy options are required here.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final SettingsState settings = ref.watch(settingsProvider);
    final SettingsNotifier notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              SectionHeader(title: l10n.settingsAppearance),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(l10n.settingsThemeMode,
                        style: context.textTheme.titleSmall),
                    const SizedBox(height: 10),
                    SegmentedButton<ThemeMode>(
                      segments: <ButtonSegment<ThemeMode>>[
                        ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            label: Text(l10n.settingsSystem)),
                        ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            label: Text(l10n.settingsLight)),
                        ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            label: Text(l10n.settingsDark)),
                      ],
                      selected: <ThemeMode>{settings.themeMode},
                      onSelectionChanged: (Set<ThemeMode> s) =>
                          notifier.setThemeMode(s.first),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.settingsLanguage),
                  subtitle: Text(settings.locale == null
                      ? l10n.settingsSystem
                      : settings.locale!.languageCode.toUpperCase()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickLanguage(context, ref),
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: l10n.settingsNotifications),
              GlassCard(
                padding: EdgeInsets.zero,
                child: SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: Text(l10n.settingsNotifications),
                  value: settings.notificationsEnabled,
                  onChanged: (bool v) async {
                    if (v) {
                      final bool granted = await ref
                          .read(notificationsServiceProvider)
                          .requestPermission();
                      await notifier.setNotificationsEnabled(granted);
                    } else {
                      await notifier.setNotificationsEnabled(false);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: l10n.consentTitle),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    SwitchListTile(
                      secondary: const Icon(Icons.ads_click_rounded),
                      title: Text(l10n.consentPersonalized),
                      value: settings.personalizedAds,
                      onChanged: (bool v) =>
                          notifier.setConsent(personalized: v),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: Text(l10n.settingsPrivacyChoices),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _privacyChoices(context, ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: l10n.premiumTitle),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.workspace_premium_rounded),
                      title: Text(l10n.settingsPremium),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.premium),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.restore_rounded),
                      title: Text(l10n.premiumRestore),
                      onTap: () => ref.read(purchaseServiceProvider).restore(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(title: l10n.settingsDisclaimer),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.shield_outlined),
                      title: Text(l10n.settingsPrivacy),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.privacy),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.gavel_rounded),
                      title: Text(l10n.settingsTerms),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.terms),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(l10n.settingsDisclaimer),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.disclaimer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(child: _VersionLabel()),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snap) {
        final String version = snap.hasData
            ? '${snap.data!.version} (${snap.data!.buildNumber})'
            : '';
        return Text('${context.l10n.settingsVersion} $version',
            style: context.textTheme.bodySmall);
      },
    );
  }
}
