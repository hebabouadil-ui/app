import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import '../../shared/widgets/gradient_background.dart';

class LegalSection {
  const LegalSection(this.heading, this.body);
  final String heading;
  final String body;
}

/// Simple scrollable scaffold for long-form legal text (privacy/terms).
class LegalPage extends StatelessWidget {
  const LegalPage({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.intro,
    required this.sections,
  });

  final String title;
  final String lastUpdated;
  final String intro;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Text('Last updated: $lastUpdated',
                  style: context.textTheme.labelSmall),
              const SizedBox(height: 12),
              Text(intro, style: context.textTheme.bodyLarge),
              const SizedBox(height: 20),
              for (final LegalSection s in sections) ...<Widget>[
                Text(s.heading, style: context.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(s.body, style: context.textTheme.bodyMedium),
                const SizedBox(height: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
