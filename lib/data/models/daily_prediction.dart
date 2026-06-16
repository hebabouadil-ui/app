/// The daily, deterministic-per-day "fortune" shown on the home screen and the
/// dedicated Daily Predictions screen.
class DailyPrediction {
  const DailyPrediction({
    required this.date,
    required this.luck,
    required this.energy,
    required this.productivity,
    required this.social,
    required this.moodEmoji,
    required this.moodLabel,
    required this.message,
    required this.luckyColor,
    required this.luckyNumber,
    required this.affirmation,
  });

  final DateTime date; // normalized to the day (midnight, local)
  final int luck; // 0-100
  final int energy; // 0-100
  final int productivity; // 0-100
  final int social; // 0-100
  final String moodEmoji;
  final String moodLabel;
  final String message; // motivational message
  final String luckyColor;
  final int luckyNumber;
  final String affirmation; // "Today's Positive Message"

  /// Average of the four scores — handy for a single headline figure.
  int get overall => ((luck + energy + productivity + social) / 4).round();

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date.toIso8601String(),
        'luck': luck,
        'energy': energy,
        'productivity': productivity,
        'social': social,
        'moodEmoji': moodEmoji,
        'moodLabel': moodLabel,
        'message': message,
        'luckyColor': luckyColor,
        'luckyNumber': luckyNumber,
        'affirmation': affirmation,
      };

  factory DailyPrediction.fromJson(Map<String, dynamic> json) =>
      DailyPrediction(
        date: DateTime.parse(json['date'] as String),
        luck: (json['luck'] as num).toInt(),
        energy: (json['energy'] as num).toInt(),
        productivity: (json['productivity'] as num).toInt(),
        social: (json['social'] as num).toInt(),
        moodEmoji: json['moodEmoji'] as String,
        moodLabel: json['moodLabel'] as String,
        message: json['message'] as String,
        luckyColor: json['luckyColor'] as String,
        luckyNumber: (json['luckyNumber'] as num).toInt(),
        affirmation: json['affirmation'] as String,
      );
}
