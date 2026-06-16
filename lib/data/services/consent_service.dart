import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Handles privacy consent end-to-end:
///  * **GDPR / ePrivacy** via Google's User Messaging Platform (UMP) consent
///    form, which also drives personalized-vs-non-personalized ads.
///  * **iOS App Tracking Transparency (ATT)** prompt.
class ConsentService {
  bool _attRequested = false;

  /// Requests a UMP consent-info update and shows the form if required.
  /// Returns whether ads can be requested afterwards.
  Future<bool> gatherConsent() async {
    final Completer<bool> completer = Completer<bool>();

    final ConsentRequestParameters params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        try {
          await _loadAndShowFormIfRequired();
        } catch (e) {
          debugPrint('Consent form error: $e');
        }
        final bool canRequest =
            await ConsentInformation.instance.canRequestAds();
        if (!completer.isCompleted) completer.complete(canRequest);
      },
      (FormError error) {
        debugPrint('Consent info update failed: ${error.message}');
        // Fail open to non-personalized ads.
        if (!completer.isCompleted) completer.complete(true);
      },
    );

    return completer.future;
  }

  Future<void> _loadAndShowFormIfRequired() {
    final Completer<void> completer = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
      if (error != null) {
        debugPrint('Consent form load/show error: ${error.message}');
      }
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  /// Lets users re-open the privacy options form (required by UMP when a
  /// privacy-options entry point is needed). Wire this to a Settings button.
  Future<void> showPrivacyOptions() async {
    final Completer<void> completer = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (error != null) {
        debugPrint('Privacy options error: ${error.message}');
      }
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  Future<bool> isPrivacyOptionsRequired() async {
    final PrivacyOptionsRequirementStatus status =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    return status == PrivacyOptionsRequirementStatus.required;
  }

  Future<bool> canRequestAds() => ConsentInformation.instance.canRequestAds();

  /// iOS App Tracking Transparency. Returns true if tracking is authorized.
  /// On non-iOS platforms this is a no-op that returns true.
  Future<bool> requestTrackingAuthorization() async {
    if (kIsWeb || !Platform.isIOS) return true;
    try {
      TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined && !_attRequested) {
        _attRequested = true;
        // A short delay improves prompt reliability right after launch.
        await Future<void>.delayed(const Duration(milliseconds: 250));
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      }
      return status == TrackingStatus.authorized;
    } catch (e) {
      debugPrint('ATT request failed: $e');
      return false;
    }
  }

  /// For development: reset stored consent so the form shows again.
  void reset() => ConsentInformation.instance.reset();
}
