import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/storage_keys.dart';
import '../data/services/purchase_service.dart';
import 'service_providers.dart';

/// Immutable settings snapshot driving theme, locale, consent and entitlements.
class SettingsState {
  const SettingsState({
    this.onboardingComplete = false,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.consentChosen = false,
    this.personalizedAds = false,
    this.notificationsEnabled = false,
    this.ownedProducts = const <String>{},
    this.visualTheme = 'aura',
  });

  final bool onboardingComplete;
  final ThemeMode themeMode;
  final Locale? locale;
  final bool consentChosen;
  final bool personalizedAds;
  final bool notificationsEnabled;
  final Set<String> ownedProducts;
  final String visualTheme;

  bool get adsRemoved =>
      ownedProducts.any(ProductIds.removesAds.contains);
  bool get hasUnlimited =>
      ownedProducts.contains(ProductIds.premiumUnlimited);
  bool get hasCompatibilityPack =>
      ownedProducts.contains(ProductIds.compatibilityPack);
  bool get hasThemePack => ownedProducts.contains(ProductIds.themePack);
  bool get isPremium => ownedProducts.isNotEmpty;

  SettingsState copyWith({
    bool? onboardingComplete,
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
    bool? consentChosen,
    bool? personalizedAds,
    bool? notificationsEnabled,
    Set<String>? ownedProducts,
    String? visualTheme,
  }) {
    return SettingsState(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      themeMode: themeMode ?? this.themeMode,
      locale: clearLocale ? null : (locale ?? this.locale),
      consentChosen: consentChosen ?? this.consentChosen,
      personalizedAds: personalizedAds ?? this.personalizedAds,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      ownedProducts: ownedProducts ?? this.ownedProducts,
      visualTheme: visualTheme ?? this.visualTheme,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    final SettingsState loaded = _load();
    // Sync downstream services with the loaded entitlements/consent.
    _syncServices(loaded);
    return loaded;
  }

  SettingsState _load() {
    final storage = ref.read(storageServiceProvider);
    final String? themeStr =
        storage.read<String>(StorageKeys.settingsBox, StorageKeys.themeMode);
    final String? localeStr =
        storage.read<String>(StorageKeys.settingsBox, StorageKeys.locale);
    final List<String> owned =
        storage.readStringList(StorageKeys.settingsBox, StorageKeys.premiumPacks);

    return SettingsState(
      onboardingComplete: storage.read<bool>(
              StorageKeys.settingsBox, StorageKeys.onboardingComplete,
              defaultValue: false) ??
          false,
      themeMode: _parseThemeMode(themeStr),
      locale: localeStr == null ? null : Locale(localeStr),
      consentChosen: storage.read<bool>(
              StorageKeys.settingsBox, StorageKeys.gdprConsent,
              defaultValue: false) ??
          false,
      personalizedAds: storage.read<bool>(
              StorageKeys.settingsBox, StorageKeys.personalizedAds,
              defaultValue: false) ??
          false,
      notificationsEnabled: storage.read<bool>(
              StorageKeys.settingsBox, StorageKeys.notificationsEnabled,
              defaultValue: false) ??
          false,
      ownedProducts: owned.toSet(),
      visualTheme: storage.read<String>(
              StorageKeys.settingsBox, StorageKeys.selectedTheme,
              defaultValue: 'aura') ??
          'aura',
    );
  }

  void _syncServices(SettingsState s) {
    final ads = ref.read(adsServiceProvider);
    ads.adsRemoved = s.adsRemoved;
    ads.personalized = s.personalizedAds;
    ref.read(analyticsServiceProvider).setEnabled(s.consentChosen);
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

  Future<void> completeOnboarding() async {
    await ref.read(storageServiceProvider).write(
        StorageKeys.settingsBox, StorageKeys.onboardingComplete, true);
    state = state.copyWith(onboardingComplete: true);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(storageServiceProvider).write(
        StorageKeys.settingsBox, StorageKeys.themeMode, _themeModeToString(mode));
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale? locale) async {
    final storage = ref.read(storageServiceProvider);
    if (locale == null) {
      await storage.delete(StorageKeys.settingsBox, StorageKeys.locale);
      state = state.copyWith(clearLocale: true);
    } else {
      await storage.write(
          StorageKeys.settingsBox, StorageKeys.locale, locale.languageCode);
      state = state.copyWith(locale: locale);
    }
  }

  /// Records the user's consent choice and propagates it to ads + analytics.
  Future<void> setConsent({required bool personalized}) async {
    final storage = ref.read(storageServiceProvider);
    await storage.write(
        StorageKeys.settingsBox, StorageKeys.gdprConsent, true);
    await storage.write(
        StorageKeys.settingsBox, StorageKeys.personalizedAds, personalized);
    state = state.copyWith(consentChosen: true, personalizedAds: personalized);
    ref.read(adsServiceProvider).personalized = personalized;
    await ref.read(analyticsServiceProvider).setEnabled(true);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await ref.read(storageServiceProvider).write(
        StorageKeys.settingsBox, StorageKeys.notificationsEnabled, enabled);
    state = state.copyWith(notificationsEnabled: enabled);
    final notifications = ref.read(notificationsServiceProvider);
    if (enabled) {
      await notifications.scheduleDailyReminders();
    } else {
      await notifications.cancelAll();
    }
  }

  Future<void> setVisualTheme(String themeId) async {
    await ref.read(storageServiceProvider).write(
        StorageKeys.settingsBox, StorageKeys.selectedTheme, themeId);
    state = state.copyWith(visualTheme: themeId);
  }

  /// Grants an owned product (purchase or restore) and updates ad state.
  Future<void> grantProduct(String productId) async {
    final Set<String> updated = <String>{...state.ownedProducts, productId};
    await _persistProducts(updated);
    state = state.copyWith(ownedProducts: updated);
    ref.read(adsServiceProvider).adsRemoved = state.adsRemoved;
  }

  Future<void> _persistProducts(Set<String> products) async {
    final storage = ref.read(storageServiceProvider);
    await storage.write(
        StorageKeys.settingsBox, StorageKeys.premiumPacks, products.toList());
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
