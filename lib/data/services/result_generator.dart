import '../../core/utils/seeded_random.dart';
import '../models/analysis_result.dart';
import '../models/analysis_type.dart';
import '../models/daily_prediction.dart';
import '../models/face_features.dart';
import 'result_content.dart';

/// Pure, deterministic, fully testable engine that turns a face-feature summary
/// and/or the current date into entertainment-only results.
///
/// Determinism rules:
///  * "Trait" experiences (personality, leadership, romance, etc.) are stable
///    for a given face so re-scanning the same person feels consistent.
///  * "Mood/energy" experiences (aura, daily luck, future mood, positive
///    message) fold in the date so they refresh every day.
class ResultGenerator {
  const ResultGenerator();

  static const Set<AnalysisType> _dailyVarying = <AnalysisType>{
    AnalysisType.auraScore,
    AnalysisType.dailyLuck,
    AnalysisType.futureMood,
    AnalysisType.positiveMessage,
  };

  /// Generates a result for a face-or-date based experience.
  AnalysisResult generate({
    required AnalysisType type,
    required FaceFeatures features,
    DateTime? now,
    String salt = '',
  }) {
    final DateTime ts = now ?? DateTime.now();
    final String dayPart =
        _dailyVarying.contains(type) ? _dayKey(ts) : 'fixed';
    final SeededRandom r = SeededRandom.fromString(
      '${type.id}|${features.seedSignature}|$dayPart|$salt',
    );
    final String id = '${type.id}-${ts.microsecondsSinceEpoch}';

    switch (type) {
      case AnalysisType.auraScore:
        return _aura(r, features, ts, id);
      case AnalysisType.personality:
        return _personality(r, features, ts, id);
      case AnalysisType.firstImpression:
        return _firstImpression(r, features, ts, id);
      case AnalysisType.leadership:
        return _leadership(r, features, ts, id);
      case AnalysisType.romanticStyle:
        return _romantic(r, features, ts, id);
      case AnalysisType.celebrityLookAlike:
        return _celebrity(r, features, ts, id);
      case AnalysisType.dailyLuck:
        return _fromDaily(AnalysisType.dailyLuck, generateDailyPrediction(ts, salt: salt), ts, id);
      case AnalysisType.futureMood:
        return _fromDaily(AnalysisType.futureMood, generateDailyPrediction(ts, salt: salt), ts, id);
      case AnalysisType.positiveMessage:
        return _fromDaily(AnalysisType.positiveMessage, generateDailyPrediction(ts, salt: salt), ts, id);
      case AnalysisType.friendshipCompatibility:
        // Friendship needs two faces; callers should use [generateFriendship].
        return _friendship(features, const FaceFeatures.none(), ts, salt: salt);
    }
  }

  /// Compatibility between two scanned faces.
  AnalysisResult generateFriendship(
    FaceFeatures a,
    FaceFeatures b, {
    DateTime? now,
    String salt = '',
  }) {
    return _friendship(a, b, now ?? DateTime.now(), salt: salt);
  }

  /// The deterministic-per-day fortune.
  DailyPrediction generateDailyPrediction(DateTime day, {String salt = ''}) {
    final DateTime d = DateTime(day.year, day.month, day.day);
    final SeededRandom r =
        SeededRandom.fromString('daily|${_dayKey(d)}|$salt');
    final mood = r.pick(ResultContent.moods);
    return DailyPrediction(
      date: d,
      luck: r.nextScore(),
      energy: r.nextScore(),
      productivity: r.nextScore(),
      social: r.nextScore(),
      moodEmoji: mood.emoji,
      moodLabel: mood.label,
      message: r.pick(ResultContent.motivationalMessages),
      luckyColor: r.pick(ResultContent.luckyColors),
      luckyNumber: r.nextInt(1, 99),
      affirmation: r.pick(ResultContent.affirmations),
    );
  }

  // ---------------------------------------------------------------------------
  // Per-experience builders
  // ---------------------------------------------------------------------------

  AnalysisResult _aura(
      SeededRandom r, FaceFeatures f, DateTime ts, String id) {
    final aura = r.pick(ResultContent.auras);
    final String adjective = r.pick(ResultContent.positiveAdjectives);
    final int score = r.nextScore(min: 55);
    return AnalysisResult(
      id: id,
      type: AnalysisType.auraScore,
      createdAt: ts,
      primaryScore: score,
      title: '${aura.name} Aura',
      subtitle: 'You radiate $adjective energy',
      summary:
          '${r.pick(ResultContent.summaryOpeners)} your aura is glowing '
          '${aura.name.toLowerCase()} today. People can\'t help but notice '
          'your $adjective presence. Lean into it and share that glow!',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Positivity', value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: 'Magnetism', value: r.nextScore(min: 50)),
        ResultMetric(label: 'Calm', value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: 'Creativity', value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits, 3),
      gradientName: aura.gradient,
      emoji: aura.emoji,
      extra: <String, String>{'aura': aura.name},
    );
  }

  AnalysisResult _personality(
      SeededRandom r, FaceFeatures f, DateTime ts, String id) {
    final archetype = r.pick(ResultContent.personalityArchetypes);
    return AnalysisResult(
      id: id,
      type: AnalysisType.personality,
      createdAt: ts,
      primaryScore: r.nextScore(min: 60),
      title: archetype.name,
      subtitle: 'Your personality archetype',
      summary:
          'You come across as ${archetype.name.replaceFirst('The ', '').toLowerCase()} — '
          'someone who blends ${r.pick(ResultContent.traits).toLowerCase()} instincts with a '
          '${r.pick(ResultContent.positiveAdjectives)} streak. Just a fun read, but a flattering one!',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Openness', value: r.nextScore(min: 50)),
        ResultMetric(label: 'Energy', value: r.nextScore(min: 50)),
        ResultMetric(label: 'Warmth', value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: 'Focus', value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: 'Boldness', value: r.nextScore(min: 45)),
      ],
      traits: r.pickMany(ResultContent.traits, 4),
      gradientName: AnalysisType.personality.gradient,
      emoji: archetype.emoji,
    );
  }

  AnalysisResult _firstImpression(
      SeededRandom r, FaceFeatures f, DateTime ts, String id) {
    final String vibe = r.pick(ResultContent.firstImpressionVibes);
    return AnalysisResult(
      id: id,
      type: AnalysisType.firstImpression,
      createdAt: ts,
      primaryScore: _blend(f.smilingProbability, r.nextScore(min: 55)),
      title: 'You read as $vibe',
      subtitle: 'First impression test',
      summary:
          'In the first few seconds, people tend to find you $vibe. '
          'That\'s a great card to have in your hand — own it!',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Approachability', value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: 'Confidence', value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: 'Trustworthiness', value: r.nextScore(min: 55)),
        ResultMetric(label: 'Charm', value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits, 3),
      gradientName: AnalysisType.firstImpression.gradient,
      emoji: '👀',
    );
  }

  AnalysisResult _leadership(
      SeededRandom r, FaceFeatures f, DateTime ts, String id) {
    final String archetype = r.pick(ResultContent.leadershipArchetypes);
    return AnalysisResult(
      id: id,
      type: AnalysisType.leadership,
      createdAt: ts,
      primaryScore: r.nextScore(min: 58),
      title: archetype,
      subtitle: 'Leadership style',
      summary:
          'Your leadership flavor is "$archetype". You lead with '
          '${r.pick(ResultContent.traits).toLowerCase()} energy and a '
          '${r.pick(ResultContent.positiveAdjectives)} touch.',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Vision', value: r.nextScore(min: 55)),
        ResultMetric(label: 'Decisiveness', value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: 'Influence', value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: 'Composure', value: r.nextScore(min: 55)),
      ],
      traits: r.pickMany(ResultContent.traits, 3),
      gradientName: AnalysisType.leadership.gradient,
      emoji: '🏆',
    );
  }

  AnalysisResult _romantic(
      SeededRandom r, FaceFeatures f, DateTime ts, String id) {
    final String style = r.pick(ResultContent.romanticStyles);
    return AnalysisResult(
      id: id,
      type: AnalysisType.romanticStyle,
      createdAt: ts,
      primaryScore: r.nextScore(min: 60),
      title: style,
      subtitle: 'Your romantic style',
      summary:
          'In matters of the heart, you\'re "$style". You bring '
          '${r.pick(ResultContent.traits).toLowerCase()} energy and a '
          '${r.pick(ResultContent.positiveAdjectives)} charm to the people you love.',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Passion', value: r.nextScore(min: 55)),
        ResultMetric(label: 'Loyalty', value: r.nextScore(min: 60)),
        ResultMetric(label: 'Playfulness', value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: 'Mystery', value: r.nextScore(min: 40)),
      ],
      traits: r.pickMany(ResultContent.traits, 3),
      gradientName: AnalysisType.romanticStyle.gradient,
      emoji: '💖',
    );
  }

  AnalysisResult _celebrity(
      SeededRandom r, FaceFeatures f, DateTime ts, String id) {
    final String vibe = r.pick(ResultContent.celebrityVibes);
    final int match = r.nextScore(min: 72); // always flattering
    return AnalysisResult(
      id: id,
      type: AnalysisType.celebrityLookAlike,
      createdAt: ts,
      primaryScore: match,
      title: 'You give off $vibe energy',
      subtitle: '$match% vibe match',
      summary:
          'Your overall vibe lines up with $vibe. It\'s a fun match based on '
          'your expression and energy — not a literal look-alike.',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Star Power', value: r.nextScore(min: 60)),
        ResultMetric(label: 'Screen Presence', value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: 'Charisma', value: r.nextScore(min: 60)),
      ],
      traits: r.pickMany(ResultContent.traits, 3),
      gradientName: AnalysisType.celebrityLookAlike.gradient,
      emoji: '⭐',
      extra: <String, String>{'vibe': vibe},
    );
  }

  AnalysisResult _friendship(
      FaceFeatures a, FaceFeatures b, DateTime ts,
      {String salt = ''}) {
    final SeededRandom r = SeededRandom.fromString(
      'friendship|${a.seedSignature}|${b.seedSignature}|$salt',
    );
    final int score = r.nextScore(min: 62);
    return AnalysisResult(
      id: 'friendship-${ts.microsecondsSinceEpoch}',
      type: AnalysisType.friendshipCompatibility,
      createdAt: ts,
      primaryScore: score,
      title: '$score% Compatible',
      subtitle: 'Friendship compatibility',
      summary:
          'You two have a $score% friendship match! Your energies '
          '${score > 80 ? 'click instantly' : 'complement each other'} — '
          'expect ${r.pick(ResultContent.traits).toLowerCase()} adventures together.',
      metrics: <ResultMetric>[
        ResultMetric(label: 'Communication', value: r.nextScore(min: 55)),
        ResultMetric(label: 'Fun Factor', value: r.nextScore(min: 60)),
        ResultMetric(label: 'Trust', value: r.nextScore(min: 58)),
        ResultMetric(label: 'Adventure', value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits, 3),
      gradientName: AnalysisType.friendshipCompatibility.gradient,
      emoji: '🤝',
    );
  }

  AnalysisResult _fromDaily(
      AnalysisType type, DailyPrediction p, DateTime ts, String id) {
    switch (type) {
      case AnalysisType.dailyLuck:
        return AnalysisResult(
          id: id,
          type: type,
          createdAt: ts,
          primaryScore: p.luck,
          title: 'Daily Luck: ${p.luck}',
          subtitle: 'Lucky color ${p.luckyColor} • Number ${p.luckyNumber}',
          summary: p.message,
          metrics: <ResultMetric>[
            ResultMetric(label: 'Luck', value: p.luck),
            ResultMetric(label: 'Energy', value: p.energy),
            ResultMetric(label: 'Productivity', value: p.productivity),
            ResultMetric(label: 'Social', value: p.social),
          ],
          traits: <String>[p.luckyColor, 'Lucky #${p.luckyNumber}'],
          gradientName: type.gradient,
          emoji: '🍀',
          extra: <String, String>{
            'luckyColor': p.luckyColor,
            'luckyNumber': '${p.luckyNumber}',
          },
        );
      case AnalysisType.futureMood:
        return AnalysisResult(
          id: id,
          type: type,
          createdAt: ts,
          primaryScore: p.overall,
          title: 'Mood Forecast: ${p.moodLabel}',
          subtitle: 'How your day may feel',
          summary:
              'Your mood forecast is "${p.moodLabel}" ${p.moodEmoji}. ${p.message}',
          metrics: <ResultMetric>[
            ResultMetric(label: 'Morning', value: p.energy),
            ResultMetric(label: 'Afternoon', value: p.productivity),
            ResultMetric(label: 'Evening', value: p.social),
            ResultMetric(label: 'Overall', value: p.overall),
          ],
          traits: <String>[p.moodLabel],
          gradientName: type.gradient,
          emoji: p.moodEmoji,
        );
      case AnalysisType.positiveMessage:
        return AnalysisResult(
          id: id,
          type: type,
          createdAt: ts,
          primaryScore: 100,
          title: 'Today\'s Positive Message',
          subtitle: 'A little reminder for you',
          summary: p.affirmation,
          metrics: const <ResultMetric>[
            ResultMetric(label: 'Positivity', value: 100),
            ResultMetric(label: 'Self-Love', value: 97),
            ResultMetric(label: 'Gratitude', value: 95),
          ],
          traits: const <String>['You matter', 'Keep shining'],
          gradientName: type.gradient,
          emoji: '🌟',
        );
      default:
        throw ArgumentError('Not a daily type: $type');
    }
  }

  // ---------------------------------------------------------------------------

  /// Blends a 0–1 feature signal with a random score so results react to the
  /// face yet stay playful and varied.
  int _blend(double signal, int random) {
    final double v = (signal.clamp(0.0, 1.0) * 100 * 0.45) + (random * 0.55);
    return v.round().clamp(20, 99);
  }

  String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
