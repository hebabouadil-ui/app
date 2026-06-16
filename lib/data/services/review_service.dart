import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/storage_keys.dart';
import 'storage_service.dart';

/// Requests the native in-app review prompt, but only after the user has had
/// several **positive** interactions and only once (store guidelines forbid
/// nagging). Call [recordPositiveInteraction] after delightful moments
/// (high score, badge unlocked, streak milestone).
class ReviewService {
  ReviewService(this._storage);

  final StorageService _storage;
  final InAppReview _inAppReview = InAppReview.instance;

  void recordPositiveInteraction() {
    final int count = _storage.read<int>(
          StorageKeys.settingsBox,
          StorageKeys.positiveInteractions,
          defaultValue: 0,
        ) ??
        0;
    _storage.write(
      StorageKeys.settingsBox,
      StorageKeys.positiveInteractions,
      count + 1,
    );
  }

  bool get _alreadyRequested =>
      _storage.read<bool>(
        StorageKeys.settingsBox,
        StorageKeys.reviewRequested,
        defaultValue: false,
      ) ??
      false;

  int get _interactions =>
      _storage.read<int>(
        StorageKeys.settingsBox,
        StorageKeys.positiveInteractions,
        defaultValue: 0,
      ) ??
      0;

  /// Shows the system review sheet if the user is "warm" and we haven't asked.
  Future<void> maybeRequestReview() async {
    if (_alreadyRequested) return;
    if (_interactions < AppConstants.reviewPromptThreshold) return;
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
        await _storage.write(
          StorageKeys.settingsBox,
          StorageKeys.reviewRequested,
          true,
        );
      }
    } catch (e) {
      debugPrint('Review request failed: $e');
    }
  }

  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(
        appStoreId: AppConstants.iosAppId,
      );
    } catch (e) {
      debugPrint('openStoreListing failed: $e');
    }
  }
}
