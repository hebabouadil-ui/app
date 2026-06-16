import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_gradients.dart';
import '../../shared/widgets/gradient_background.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsDisclaimer)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: AppGradients.aura,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: <Widget>[
                      const Text('🎈', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(
                        AppConstants.entertainmentDisclaimer,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _bullet(context,
                    'All scores, traits, predictions and matches are generated for fun.'),
                _bullet(context,
                    'Face scanning runs on your device using motion/landmark detection and is used only to add playful variety to results.'),
                _bullet(context,
                    'Nothing in this app is a measurement of attractiveness, intelligence, health, or any real-world trait.'),
                _bullet(context,
                    'Results are not based on science and should never be used to make decisions about your life, relationships, or wellbeing.'),
                _bullet(context,
                    'If you are looking for real guidance, please consult a qualified professional.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('•  ', style: TextStyle(fontSize: 18)),
          Expanded(child: Text(text, style: context.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
