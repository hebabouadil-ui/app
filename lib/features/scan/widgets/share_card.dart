import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../data/models/analysis_result.dart';

/// The branded, screenshot-friendly card. Uses explicit colors/styles (not
/// theme-dependent) so it renders identically when captured off-screen.
class ShareableResultCard extends StatelessWidget {
  const ShareableResultCard({super.key, required this.result});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final Gradient gradient = AppGradients.byName(result.gradientName);
    return Container(
      width: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                'Dream AI',
                style: GoogleFonts.sora(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(result.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              '${result.primaryScore}',
              style: GoogleFonts.sora(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 52,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          if (result.subtitle != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              result.subtitle!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final String trait in result.traits.take(3))
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(trait,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.shareCardCta,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
