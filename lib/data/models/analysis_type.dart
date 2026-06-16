import 'package:flutter/material.dart';

/// The catalog of "experiences" offered by the app. Each entry powers a home
/// screen card and selects which fun-result generator to run.
enum AnalysisType {
  auraScore(
    id: 'aura',
    icon: Icons.auto_awesome,
    gradient: 'aura',
    requiresFace: true,
    isPremium: false,
  ),
  personality(
    id: 'personality',
    icon: Icons.psychology_alt,
    gradient: 'royal',
    requiresFace: true,
    isPremium: false,
  ),
  firstImpression(
    id: 'first_impression',
    icon: Icons.visibility,
    gradient: 'dusk',
    requiresFace: true,
    isPremium: false,
  ),
  leadership(
    id: 'leadership',
    icon: Icons.flag_circle,
    gradient: 'royal',
    requiresFace: true,
    isPremium: true,
  ),
  romanticStyle(
    id: 'romantic',
    icon: Icons.favorite,
    gradient: 'romance',
    requiresFace: true,
    isPremium: true,
  ),
  dailyLuck(
    id: 'daily_luck',
    icon: Icons.casino,
    gradient: 'sunrise',
    requiresFace: false,
    isPremium: false,
  ),
  futureMood(
    id: 'future_mood',
    icon: Icons.nightlight_round,
    gradient: 'dusk',
    requiresFace: false,
    isPremium: false,
  ),
  friendshipCompatibility(
    id: 'friendship',
    icon: Icons.diversity_3,
    gradient: 'ocean',
    requiresFace: true,
    isPremium: true,
  ),
  celebrityLookAlike(
    id: 'celebrity',
    icon: Icons.star,
    gradient: 'sunrise',
    requiresFace: true,
    isPremium: true,
  ),
  positiveMessage(
    id: 'positive_message',
    icon: Icons.wb_sunny,
    gradient: 'ocean',
    requiresFace: false,
    isPremium: false,
  );

  const AnalysisType({
    required this.id,
    required this.icon,
    required this.gradient,
    required this.requiresFace,
    required this.isPremium,
  });

  final String id;
  final IconData icon;
  final String gradient;

  /// Whether a face scan is required to run this experience.
  final bool requiresFace;

  /// Whether this is gated behind premium / a rewarded ad on the free tier.
  final bool isPremium;

  static AnalysisType fromId(String id) {
    return AnalysisType.values.firstWhere(
      (AnalysisType t) => t.id == id,
      orElse: () => AnalysisType.auraScore,
    );
  }
}
