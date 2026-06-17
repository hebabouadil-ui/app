import 'package:flutter/material.dart';

/// What kind of capture an experience needs before it can run.
enum ScanKind { none, face, hand }

/// The catalog of "experiences" offered by the app. Each entry powers a home
/// screen card and selects which reading generator to run.
enum AnalysisType {
  auraScore(
    id: 'aura',
    icon: Icons.auto_awesome,
    gradient: 'aura',
    scanKind: ScanKind.face,
    isPremium: false,
  ),
  personality(
    id: 'personality',
    icon: Icons.psychology_alt,
    gradient: 'royal',
    scanKind: ScanKind.face,
    isPremium: false,
  ),
  firstImpression(
    id: 'first_impression',
    icon: Icons.visibility,
    gradient: 'dusk',
    scanKind: ScanKind.face,
    isPremium: false,
  ),
  palmReading(
    id: 'palm',
    icon: Icons.front_hand,
    gradient: 'royal',
    scanKind: ScanKind.hand,
    isPremium: true,
  ),
  leadership(
    id: 'leadership',
    icon: Icons.flag_circle,
    gradient: 'royal',
    scanKind: ScanKind.face,
    isPremium: true,
  ),
  romanticStyle(
    id: 'romantic',
    icon: Icons.favorite,
    gradient: 'romance',
    scanKind: ScanKind.face,
    isPremium: true,
  ),
  dailyLuck(
    id: 'daily_luck',
    icon: Icons.casino,
    gradient: 'sunrise',
    scanKind: ScanKind.none,
    isPremium: false,
  ),
  futureMood(
    id: 'future_mood',
    icon: Icons.nightlight_round,
    gradient: 'dusk',
    scanKind: ScanKind.none,
    isPremium: false,
  ),
  friendshipCompatibility(
    id: 'friendship',
    icon: Icons.diversity_3,
    gradient: 'ocean',
    scanKind: ScanKind.face,
    isPremium: true,
  ),
  celebrityLookAlike(
    id: 'celebrity',
    icon: Icons.star,
    gradient: 'sunrise',
    scanKind: ScanKind.face,
    isPremium: true,
  ),
  positiveMessage(
    id: 'positive_message',
    icon: Icons.wb_sunny,
    gradient: 'ocean',
    scanKind: ScanKind.none,
    isPremium: false,
  );

  const AnalysisType({
    required this.id,
    required this.icon,
    required this.gradient,
    required this.scanKind,
    required this.isPremium,
  });

  final String id;
  final IconData icon;
  final String gradient;
  final ScanKind scanKind;

  /// Whether this is gated behind Pro / a rewarded ad on the free tier.
  final bool isPremium;

  /// Whether a face capture is required.
  bool get requiresFace => scanKind == ScanKind.face;

  /// Whether any photo capture (face or hand) is required.
  bool get requiresImage => scanKind != ScanKind.none;

  static AnalysisType fromId(String id) {
    return AnalysisType.values.firstWhere(
      (AnalysisType t) => t.id == id,
      orElse: () => AnalysisType.auraScore,
    );
  }
}
