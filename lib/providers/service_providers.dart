import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/services/ads_service.dart';
import '../data/services/analytics_service.dart';
import '../data/services/consent_service.dart';
import '../data/services/face_detection_service.dart';
import '../data/services/image_scan_service.dart';
import '../data/services/notifications_service.dart';
import '../data/services/purchase_service.dart';
import '../data/services/result_generator.dart';
import '../data/services/review_service.dart';
import '../data/services/share_service.dart';
import '../data/services/storage_service.dart';

/// Services that require async initialization in `main()` are provided via
/// `ProviderScope` overrides. Accessing them before override throws, which
/// surfaces wiring mistakes early.
final storageServiceProvider = Provider<StorageService>(
  (Ref ref) => throw UnimplementedError('Override in main()'),
);

final analyticsServiceProvider = Provider<AnalyticsService>(
  (Ref ref) => throw UnimplementedError('Override in main()'),
);

final adsServiceProvider = Provider<AdsService>(
  (Ref ref) => throw UnimplementedError('Override in main()'),
);

final notificationsServiceProvider = Provider<NotificationsService>(
  (Ref ref) => throw UnimplementedError('Override in main()'),
);

final purchaseServiceProvider = Provider<PurchaseService>(
  (Ref ref) => throw UnimplementedError('Override in main()'),
);

final consentServiceProvider = Provider<ConsentService>(
  (Ref ref) => ConsentService(),
);

/// App-wide config / feature flags & A/B buckets.
final appConfigProvider = Provider<AppConfig>((Ref ref) => AppConfig());

// Stateless services can be constructed directly.

final resultGeneratorProvider =
    Provider<ResultGenerator>((Ref ref) => const ResultGenerator());

final faceDetectionServiceProvider = Provider<FaceDetectionService>((Ref ref) {
  final FaceDetectionService service = FaceDetectionService();
  ref.onDispose(service.dispose);
  return service;
});

final shareServiceProvider = Provider<ShareService>((Ref ref) => ShareService());

final imageScanServiceProvider =
    Provider<ImageScanService>((Ref ref) => ImageScanService());

final reviewServiceProvider = Provider<ReviewService>(
  (Ref ref) => ReviewService(ref.watch(storageServiceProvider)),
);
