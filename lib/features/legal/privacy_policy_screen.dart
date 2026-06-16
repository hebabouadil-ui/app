import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import 'legal_page.dart';

/// NOTE: This is a developer-friendly template. Have it reviewed by legal
/// counsel and host the canonical version at [AppConstants.privacyPolicyUrl]
/// before publishing.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPage(
      title: context.l10n.settingsPrivacy,
      lastUpdated: 'June 16, 2026',
      intro:
          'Dream AI ("we", "us") respects your privacy. ${AppConstants.appName} is an '
          'entertainment app. This policy explains what limited data is processed '
          'and your choices. You can use the core experience without creating an account.',
      sections: const <LegalSection>[
        LegalSection(
          'On-device face scanning',
          'When you scan a photo, face detection runs entirely on your device. '
              'Your photos and any facial landmarks are NOT uploaded to our servers '
              'and are not used to identify you. We do not build or store biometric '
              'profiles. Results are generated locally for entertainment only.',
        ),
        LegalSection(
          'Information we process',
          'We do not collect your name, email, or contacts. We process: (a) anonymous '
              'usage analytics (e.g. screens viewed, features used) via Firebase Analytics; '
              '(b) advertising identifiers and ad interaction data via Google AdMob to show '
              'ads; and (c) purchase status via the App Store / Google Play to unlock features.',
        ),
        LegalSection(
          'Advertising',
          'We use Google AdMob. Depending on your consent choice and region, ads may be '
              'personalized or non-personalized. In the EEA/UK we present a Google-certified '
              'consent (UMP) message. On iOS we ask via App Tracking Transparency before any '
              'tracking. You can change your choice anytime in Settings → Privacy choices.',
        ),
        LegalSection(
          'Analytics',
          'Firebase Analytics helps us understand aggregate, anonymous usage so we can '
              'improve the app. Analytics collection is disabled until you consent and can '
              'be turned off in Settings.',
        ),
        LegalSection(
          'Children',
          'Dream AI is intended for users aged ${AppConstants.minimumAge}+ and is not directed '
              'to children. We do not knowingly collect personal data from children. If you '
              'believe a child has provided data, contact us and we will delete it.',
        ),
        LegalSection(
          'Your choices & rights',
          'You may withdraw ad-personalization consent, disable analytics, and reset your '
              'local data at any time. Where GDPR/CCPA applies, you have rights to access, '
              'delete, and object to processing. Because most data is on-device, clearing app '
              'data or uninstalling removes it.',
        ),
        LegalSection(
          'Third parties',
          'Our service providers include Google (Firebase, AdMob), Apple, and Google Play '
              'for payments. Their handling of data is governed by their own privacy policies.',
        ),
        LegalSection(
          'Contact',
          'Questions? Email ${AppConstants.supportEmail}.',
        ),
      ],
    );
  }
}
