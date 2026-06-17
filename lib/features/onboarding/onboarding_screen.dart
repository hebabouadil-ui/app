import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../providers/service_providers.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/aura_orb.dart';
import '../../shared/widgets/gradient_background.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  bool _wantsNotifications = true;
  bool _personalizedAds = true;
  bool _finishing = false;

  static const int _lastPage = 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _lastPage) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);

    final settings = ref.read(settingsProvider.notifier);
    final consent = ref.read(consentServiceProvider);

    // Camera permission (used later for face scans).
    await Permission.camera.request();

    // Notifications.
    if (_wantsNotifications) {
      final bool granted =
          await ref.read(notificationsServiceProvider).requestPermission();
      await settings.setNotificationsEnabled(granted);
    }

    // Consent: record choice, run iOS ATT + UMP.
    await settings.setConsent(personalized: _personalizedAds);
    await consent.requestTrackingAuthorization();

    ref.read(analyticsServiceProvider).logOnboardingComplete(
        ref.read(appConfigProvider).onboardingVariant);

    // Flipping this triggers the router redirect to home.
    await settings.completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pages = <_OnbPageData>[
      _OnbPageData(
        emoji: '🔮',
        gradient: 'aura',
        title: l10n.onbTitle1,
        body: l10n.onbBody1,
      ),
      _OnbPageData(
        emoji: '🔔',
        gradient: 'ocean',
        title: l10n.onbTitle3,
        body: l10n.onbBody3,
      ),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishing ? null : _finish,
                  child: Text(l10n.actionSkip),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (int i) => setState(() => _page = i),
                  children: <Widget>[
                    for (final _OnbPageData p in pages) _InfoPage(data: p),
                    _PermissionsPage(
                      wantsNotifications: _wantsNotifications,
                      personalizedAds: _personalizedAds,
                      onNotifications: (bool v) =>
                          setState(() => _wantsNotifications = v),
                      onPersonalized: (bool v) =>
                          setState(() => _personalizedAds = v),
                    ),
                  ],
                ),
              ),
              _Dots(count: _lastPage + 1, index: _page),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _finishing ? null : _next,
                    child: _finishing
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_page == _lastPage
                            ? l10n.actionGetStarted
                            : l10n.actionNext),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnbPageData {
  const _OnbPageData({
    required this.emoji,
    required this.gradient,
    required this.title,
    required this.body,
  });
  final String emoji;
  final String gradient;
  final String title;
  final String body;
}

class _InfoPage extends StatelessWidget {
  const _InfoPage({required this.data});
  final _OnbPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AuraOrb(
            size: 180,
            gradientName: data.gradient,
            child: Text(data.emoji, style: const TextStyle(fontSize: 72)),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: context.textTheme.displaySmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge
                ?.copyWith(color: context.colors.onSurface.withValues(alpha: 0.7)),
          ).animate(delay: 120.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _PermissionsPage extends StatelessWidget {
  const _PermissionsPage({
    required this.wantsNotifications,
    required this.personalizedAds,
    required this.onNotifications,
    required this.onPersonalized,
  });

  final bool wantsNotifications;
  final bool personalizedAds;
  final ValueChanged<bool> onNotifications;
  final ValueChanged<bool> onPersonalized;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          const Text('🚀', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text('Almost there',
              style: context.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _PermissionTile(
            icon: Icons.camera_alt_rounded,
            text: l10n.onbPermissionCamera,
            value: true,
            onChanged: null, // requested at finish; informational here
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.notifications_active_rounded),
            title: Text(l10n.onbPermissionNotifications),
            value: wantsNotifications,
            onChanged: onNotifications,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.ads_click_rounded),
            title: Text(l10n.consentPersonalized),
            subtitle: Text(l10n.consentBody,
                style: context.textTheme.bodySmall),
            value: personalizedAds,
            onChanged: onPersonalized,
            isThreeLine: true,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppGradients.dusk,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.info_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppConstants.entertainmentDisclaimer,
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String text;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.check_circle, color: Color(0xFF34D399)),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            gradient: active ? AppGradients.aura : null,
            color: active ? null : context.colors.onSurface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
