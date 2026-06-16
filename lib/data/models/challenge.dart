/// What user action a [WeeklyChallenge] tracks.
enum ChallengeMetric { analyses, shares, checkIns, distinctTypes }

/// A time-boxed weekly challenge that awards XP on completion.
class WeeklyChallenge {
  const WeeklyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.metric,
    required this.target,
    required this.xpReward,
  });

  final String id;
  final String title;
  final String description;
  final String emoji;
  final ChallengeMetric metric;
  final int target;
  final int xpReward;
}
