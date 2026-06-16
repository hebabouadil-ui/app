import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import 'legal_page.dart';

/// NOTE: Developer-friendly template — have it reviewed by legal counsel and
/// host the canonical version at [AppConstants.termsUrl] before publishing.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalPage(
      title: context.l10n.settingsTerms,
      lastUpdated: 'June 16, 2026',
      intro:
          'By using ${AppConstants.appName} you agree to these Terms. If you do not agree, '
          'please do not use the app.',
      sections: const <LegalSection>[
        LegalSection(
          'Entertainment only',
          'All content — scores, traits, predictions, compatibility and look-alike results — '
              'is provided for entertainment purposes only. It does not constitute scientific, '
              'medical, psychological, financial, or professional advice, and must not be relied '
              'upon for any decision.',
        ),
        LegalSection(
          'License',
          'We grant you a personal, non-exclusive, non-transferable, revocable license to use '
              'the app for personal, non-commercial entertainment.',
        ),
        LegalSection(
          'Acceptable use',
          'You agree not to misuse the app, scan images of other people without their consent, '
              'reverse engineer it, or use it to harass, demean, or make claims about anyone.',
        ),
        LegalSection(
          'Purchases',
          'Optional one-time in-app purchases unlock premium features and/or remove ads. '
              'Purchases are processed by Apple or Google and are subject to their terms. '
              'Refunds are handled by the respective store.',
        ),
        LegalSection(
          'Disclaimers',
          'The app is provided "as is" without warranties of any kind. We do not warrant that '
              'results are accurate, meaningful, or fit for any purpose.',
        ),
        LegalSection(
          'Limitation of liability',
          'To the maximum extent permitted by law, we are not liable for any indirect, '
              'incidental, or consequential damages arising from your use of the app.',
        ),
        LegalSection(
          'Changes',
          'We may update these Terms. Continued use after changes means you accept them.',
        ),
        LegalSection(
          'Contact',
          'Questions about these Terms? Email ${AppConstants.supportEmail}.',
        ),
      ],
    );
  }
}
