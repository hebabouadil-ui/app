import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Product identifiers. These must match the ids configured in Google Play
/// Console and App Store Connect (see the store checklists in /docs).
abstract final class ProductIds {
  /// The single headline one-time purchase: unlocks all advanced readings
  /// (Palm Reading, Leadership, Romance, Celebrity, Friendship) and removes ads.
  static const String pro = 'dreamai_pro';

  // Legacy/secondary products (kept for backwards compatibility / restores).
  static const String adFree = 'dreamai_ad_free';
  static const String premiumUnlimited = 'dreamai_premium_unlimited';

  /// All non-consumable, one-time unlocks.
  static const Set<String> all = <String>{
    pro,
    adFree,
    premiumUnlimited,
  };

  /// Products that also remove ads.
  static const Set<String> removesAds = <String>{pro, adFree, premiumUnlimited};

  /// Products that unlock the advanced (premium) experiences.
  static const Set<String> unlocksPro = <String>{pro, premiumUnlimited};
}

/// Wraps `in_app_purchase`. Fails safe when billing is unavailable (e.g. the
/// emulator or a device without store support) so the rest of the app keeps
/// working. Entitlement persistence is delegated to the caller via callbacks.
class PurchaseService {
  PurchaseService();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _available = false;
  List<ProductDetails> _products = <ProductDetails>[];

  bool get isAvailable => _available;
  List<ProductDetails> get products => List<ProductDetails>.unmodifiable(_products);

  /// Called whenever a purchase (new or restored) is verified as owned.
  void Function(String productId)? onPurchased;

  /// Called on errors so the UI can surface a message.
  void Function(String message)? onError;

  Future<void> init() async {
    try {
      _available = await _iap.isAvailable();
    } catch (e) {
      debugPrint('IAP availability check failed: $e');
      _available = false;
    }
    if (!_available) return;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object e) => onError?.call('Purchase stream error: $e'),
    );

    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(ProductIds.all);
      if (response.error != null) {
        debugPrint('queryProductDetails error: ${response.error}');
      }
      _products = response.productDetails;
    } catch (e) {
      debugPrint('Load products failed: $e');
    }
  }

  ProductDetails? productById(String id) {
    for (final ProductDetails p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> buy(String productId) async {
    if (!_available) {
      onError?.call('In-app purchases are not available on this device.');
      return;
    }
    final ProductDetails? product = productById(productId);
    if (product == null) {
      onError?.call('Product not found. Please try again later.');
      return;
    }
    final PurchaseParam param = PurchaseParam(productDetails: product);
    try {
      // All our products are non-consumable one-time unlocks.
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      onError?.call('Could not start purchase: $e');
    }
  }

  Future<void> restore() async {
    if (!_available) {
      onError?.call('In-app purchases are not available on this device.');
      return;
    }
    try {
      await _iap.restorePurchases();
    } catch (e) {
      onError?.call('Could not restore purchases: $e');
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // NOTE: For real money on the line, verify the receipt server-side
          // before granting entitlements. See docs/ADMOB_SETUP.md notes.
          onPurchased?.call(purchase.productID);
          break;
        case PurchaseStatus.error:
          onError?.call(purchase.error?.message ?? 'Purchase failed.');
          break;
        case PurchaseStatus.canceled:
          break;
        case PurchaseStatus.pending:
          break;
      }
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
