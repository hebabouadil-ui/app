import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';
import '../data/models/user_profile.dart';
import 'service_providers.dart';

/// Owns the on-device [UserProfile]. Created automatically on first launch —
/// no sign-in required, which keeps the app COPPA-friendly and privacy-first.
class UserNotifier extends Notifier<UserProfile> {
  static const Uuid _uuid = Uuid();

  @override
  UserProfile build() {
    final storage = ref.read(storageServiceProvider);
    final Map<String, dynamic>? json =
        storage.readJson(StorageKeys.userBox, StorageKeys.userProfile);
    if (json != null) return UserProfile.fromJson(json);

    final UserProfile created = _create();
    // Persist outside the synchronous build via microtask.
    Future<void>.microtask(() => _persist(created));
    return created;
  }

  UserProfile _create() {
    final String id = _uuid.v4();
    return UserProfile(
      id: id,
      displayName: 'Dreamer',
      referralCode: _referralCodeFrom(id),
      createdAt: DateTime.now(),
    );
  }

  /// Stable 6-char uppercase code from the user id.
  String _referralCodeFrom(String id) {
    final String cleaned =
        id.replaceAll(RegExp('[^a-zA-Z0-9]'), '').toUpperCase();
    return cleaned.substring(0, 6);
  }

  Future<void> _persist(UserProfile profile) async {
    await ref
        .read(storageServiceProvider)
        .writeJson(StorageKeys.userBox, StorageKeys.userProfile, profile.toJson());
  }

  Future<void> setDisplayName(String name) async {
    final UserProfile updated = state.copyWith(displayName: name.trim());
    state = updated;
    await _persist(updated);
  }

  /// Applies a referral code shared by a friend (once). Credits are granted to
  /// the referrer in a real backend; here we record the relationship and give
  /// the new user a small welcome bonus.
  Future<bool> applyReferralCode(String code) async {
    final String normalized = code.trim().toUpperCase();
    if (state.referredBy != null) return false; // already referred
    if (normalized == state.referralCode) return false; // can't refer yourself
    if (normalized.length < 4) return false;

    final UserProfile updated = state.copyWith(
      referredBy: normalized,
      referralCredits: state.referralCredits + AppConstants.referralRewardCredits,
    );
    state = updated;
    await _persist(updated);
    ref.read(analyticsServiceProvider).logReferral('applied');
    return true;
  }

  /// Spend a referral credit (used to unlock a premium analysis for free).
  Future<bool> spendReferralCredit() async {
    if (state.referralCredits <= 0) return false;
    final UserProfile updated =
        state.copyWith(referralCredits: state.referralCredits - 1);
    state = updated;
    await _persist(updated);
    return true;
  }

  Future<void> addReferralCredits(int amount) async {
    final UserProfile updated =
        state.copyWith(referralCredits: state.referralCredits + amount);
    state = updated;
    await _persist(updated);
  }
}

final userProvider =
    NotifierProvider<UserNotifier, UserProfile>(UserNotifier.new);
