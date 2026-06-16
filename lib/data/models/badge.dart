/// A collectible achievement badge. The catalog of all badges lives in
/// `features/gamification/gamification_catalog.dart`.
class AchievementBadge {
  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.gradientName,
  });

  final String id;
  final String title;
  final String description;
  final String emoji;
  final String gradientName;
}
