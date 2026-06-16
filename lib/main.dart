import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/services/ads_service.dart';
import 'data/services/analytics_service.dart';
import 'data/services/notifications_service.dart';
import 'data/services/purchase_service.dart';
import 'data/services/storage_service.dart';
import 'providers/service_providers.dart';
import 'providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1) Local storage must be ready before anything reads settings.
  final StorageService storage = StorageService.instance;
  await storage.init();

  // 2) Firebase is optional in dev (config files may be absent). Fail safe.
  FirebaseAnalytics? firebaseAnalytics;
  try {
    await Firebase.initializeApp();
    firebaseAnalytics = FirebaseAnalytics.instance;
  } catch (e) {
    debugPrint('Firebase not initialized (continuing without it): $e');
  }

  // 3) Construct services.
  final AnalyticsService analytics =
      AnalyticsService(analytics: firebaseAnalytics);
  final AdsService ads = AdsService();
  final NotificationsService notifications = NotificationsService();
  final PurchaseService purchases = PurchaseService();
  await notifications.init();

  // 4) Build the Riverpod container with overrides for async services.
  final ProviderContainer container = ProviderContainer(
    overrides: <Override>[
      storageServiceProvider.overrideWithValue(storage),
      analyticsServiceProvider.overrideWithValue(analytics),
      adsServiceProvider.overrideWithValue(ads),
      notificationsServiceProvider.overrideWithValue(notifications),
      purchaseServiceProvider.overrideWithValue(purchases),
    ],
  );

  // 5) Reading settings runs its build(), which syncs ads/analytics with the
  //    user's stored consent + entitlements.
  container.read(settingsProvider);

  // 6) Wire purchases → entitlement persistence.
  purchases
    ..onPurchased = (String productId) {
      container.read(settingsProvider.notifier).grantProduct(productId);
      container.read(analyticsServiceProvider).logPurchase(productId);
    }
    ..onError = (String message) => debugPrint('Purchase error: $message');

  await purchases.init();

  // 7) Initialize ads last (after consent/entitlements are applied).
  await ads.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const DreamAIApp(),
    ),
  );
}
