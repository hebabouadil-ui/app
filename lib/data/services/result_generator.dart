import '../../core/utils/seeded_random.dart';
import '../models/analysis_result.dart';
import '../models/analysis_type.dart';
import '../models/daily_prediction.dart';
import '../models/face_features.dart';
import 'result_content.dart';

/// Pure, deterministic, fully testable engine that turns a face/hand scan
/// and/or the date into entertainment-only results — **localized** to the
/// caller's language (en/es/ar, fallback en).
class ResultGenerator {
  const ResultGenerator();

  static const Set<AnalysisType> _dailyVarying = <AnalysisType>{
    AnalysisType.auraScore,
    AnalysisType.dailyLuck,
    AnalysisType.futureMood,
    AnalysisType.positiveMessage,
  };

  AnalysisResult generate({
    required AnalysisType type,
    required FaceFeatures features,
    DateTime? now,
    String salt = '',
    String lang = 'en',
  }) {
    final String l = ResultContent.norm(lang);
    final DateTime ts = now ?? DateTime.now();
    final String dayPart =
        _dailyVarying.contains(type) ? _dayKey(ts) : 'fixed';
    final SeededRandom r = SeededRandom.fromString(
      '${type.id}|${features.seedSignature}|$dayPart|$salt',
    );
    final String id = '${type.id}-${ts.microsecondsSinceEpoch}';

    switch (type) {
      case AnalysisType.auraScore:
        return _aura(r, features, ts, id, l);
      case AnalysisType.personality:
        return _personality(r, features, ts, id, l);
      case AnalysisType.firstImpression:
        return _firstImpression(r, features, ts, id, l);
      case AnalysisType.leadership:
        return _leadership(r, features, ts, id, l);
      case AnalysisType.romanticStyle:
        return _romantic(r, features, ts, id, l);
      case AnalysisType.celebrityLookAlike:
        return _celebrity(r, features, ts, id, l);
      case AnalysisType.dailyLuck:
        return _fromDaily(AnalysisType.dailyLuck,
            generateDailyPrediction(ts, salt: salt, lang: l), ts, id, l);
      case AnalysisType.futureMood:
        return _fromDaily(AnalysisType.futureMood,
            generateDailyPrediction(ts, salt: salt, lang: l), ts, id, l);
      case AnalysisType.positiveMessage:
        return _fromDaily(AnalysisType.positiveMessage,
            generateDailyPrediction(ts, salt: salt, lang: l), ts, id, l);
      case AnalysisType.palmReading:
        return generatePalm(imageSeed: features.seedSignature, now: ts, salt: salt, lang: l);
      case AnalysisType.friendshipCompatibility:
        return _friendship(features, const FaceFeatures.none(), ts, salt: salt, lang: l);
    }
  }

  AnalysisResult generateFriendship(
    FaceFeatures a,
    FaceFeatures b, {
    DateTime? now,
    String salt = '',
    String lang = 'en',
  }) {
    return _friendship(a, b, now ?? DateTime.now(),
        salt: salt, lang: ResultContent.norm(lang));
  }

  DailyPrediction generateDailyPrediction(DateTime day,
      {String salt = '', String lang = 'en'}) {
    final String l = ResultContent.norm(lang);
    final DateTime d = DateTime(day.year, day.month, day.day);
    final SeededRandom r =
        SeededRandom.fromString('daily|${_dayKey(d)}|$salt');
    final int moodIdx = r.nextInt(0, ResultContent.moodEmojis.length - 1);
    return DailyPrediction(
      date: d,
      luck: r.nextScore(),
      energy: r.nextScore(),
      productivity: r.nextScore(),
      social: r.nextScore(),
      moodEmoji: ResultContent.moodEmojis[moodIdx],
      moodLabel: ResultContent.moodLabels(l)[moodIdx],
      message: r.pick(ResultContent.motivationalMessages(l)),
      luckyColor: r.pick(ResultContent.luckyColors(l)),
      luckyNumber: r.nextInt(1, 99),
      affirmation: r.pick(ResultContent.affirmations(l)),
    );
  }

  AnalysisResult generatePalm({
    required String imageSeed,
    DateTime? now,
    String salt = '',
    String lang = 'en',
  }) {
    final String l = ResultContent.norm(lang);
    final DateTime ts = now ?? DateTime.now();
    final SeededRandom r = SeededRandom.fromString('palm|$imageSeed|$salt');
    final int i = r.nextInt(0, ResultContent.palmEmojis.length - 1);
    final int score = r.nextScore(min: 60);
    return AnalysisResult(
      id: 'palm-${ts.microsecondsSinceEpoch}',
      type: AnalysisType.palmReading,
      createdAt: ts,
      primaryScore: score,
      title: ResultContent.palmArchetypes(l)[i],
      subtitle: _t(l, 'Your palm reading', 'Tu lectura de mano', 'قراءة كفّك'),
      summary:
          '${r.pick(ResultContent.summaryOpeners(l))} ${r.pick(ResultContent.palmFortunes(l))}',
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'lifeLine'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'heartLine'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'headLine'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'fateLine'), value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: 'royal',
      emoji: ResultContent.palmEmojis[i],
    );
  }

  // ---------------------------------------------------------------------------

  AnalysisResult _aura(
      SeededRandom r, FaceFeatures f, DateTime ts, String id, String l) {
    final int i = r.nextInt(0, ResultContent.auraGradients.length - 1);
    final String name = ResultContent.auraNames(l)[i];
    final String adj = r.pick(ResultContent.adjectives(l));
    final int score = r.nextScore(min: 55);
    return AnalysisResult(
      id: id,
      type: AnalysisType.auraScore,
      createdAt: ts,
      primaryScore: score,
      title: _t(l, '$name Aura', 'Aura $name', 'هالة $name'),
      subtitle: _t(l, 'You radiate $adj energy', 'Irradias energía $adj',
          'تُشِعّ طاقة $adj'),
      summary: '${r.pick(ResultContent.summaryOpeners(l))} ' +
          _t(
            l,
            'your aura is glowing today — lean into it and share that light!',
            '¡tu aura brilla hoy: aprovéchala y comparte esa luz!',
            'هالتك متوهّجة اليوم — استثمرها وشارك هذا النور!',
          ),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'positivity'), value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'magnetism'), value: r.nextScore(min: 50)),
        ResultMetric(label: ResultContent.label(l, 'calm'), value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'creativity'), value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: ResultContent.auraGradients[i],
      emoji: ResultContent.auraEmojis[i],
      extra: <String, String>{'aura': name},
    );
  }

  AnalysisResult _personality(
      SeededRandom r, FaceFeatures f, DateTime ts, String id, String l) {
    final int i = r.nextInt(0, ResultContent.personalityEmojis.length - 1);
    return AnalysisResult(
      id: id,
      type: AnalysisType.personality,
      createdAt: ts,
      primaryScore: r.nextScore(min: 60),
      title: ResultContent.personalityArchetypes(l)[i],
      subtitle: _t(l, 'Your personality archetype',
          'Tu arquetipo de personalidad', 'نمط شخصيتك'),
      summary: '${r.pick(ResultContent.summaryOpeners(l))} ' +
          _t(
            l,
            'a flattering, just-for-fun read of your vibe.',
            'una lectura halagadora y divertida de tu vibra.',
            'قراءة لطيفة وممتعة لطاقتك.',
          ),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'openness'), value: r.nextScore(min: 50)),
        ResultMetric(label: ResultContent.label(l, 'energy'), value: r.nextScore(min: 50)),
        ResultMetric(label: ResultContent.label(l, 'warmth'), value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'focus'), value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'boldness'), value: r.nextScore(min: 45)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 4),
      gradientName: AnalysisType.personality.gradient,
      emoji: ResultContent.personalityEmojis[i],
    );
  }

  AnalysisResult _firstImpression(
      SeededRandom r, FaceFeatures f, DateTime ts, String id, String l) {
    final String vibe = r.pick(ResultContent.firstImpressionVibes(l));
    return AnalysisResult(
      id: id,
      type: AnalysisType.firstImpression,
      createdAt: ts,
      primaryScore: _blend(f.smilingProbability, r.nextScore(min: 55)),
      title: _t(l, 'You read as $vibe', 'Transmites: $vibe', 'تبدو: $vibe'),
      subtitle: _t(l, 'First impression', 'Primera impresión', 'الانطباع الأول'),
      summary: '${r.pick(ResultContent.summaryOpeners(l))} ' +
          _t(
            l,
            'in the first seconds, people find you $vibe — own it!',
            'en los primeros segundos te perciben $vibe: ¡aprovéchalo!',
            'في الثواني الأولى يرونك $vibe — تميّز بذلك!',
          ),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'approachability'), value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'confidence'), value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'trustworthiness'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'charm'), value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: AnalysisType.firstImpression.gradient,
      emoji: '👀',
    );
  }

  AnalysisResult _leadership(
      SeededRandom r, FaceFeatures f, DateTime ts, String id, String l) {
    final String arche = r.pick(ResultContent.leadershipArchetypes(l));
    return AnalysisResult(
      id: id,
      type: AnalysisType.leadership,
      createdAt: ts,
      primaryScore: r.nextScore(min: 58),
      title: arche,
      subtitle: _t(l, 'Leadership style', 'Estilo de liderazgo', 'أسلوب القيادة'),
      summary: '${r.pick(ResultContent.summaryOpeners(l))} ' +
          _t(l, 'a fun take on how you lead.', 'una mirada divertida a cómo lideras.', 'لمحة ممتعة عن أسلوبك في القيادة.'),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'vision'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'decisiveness'), value: _blend(f.symmetry, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'influence'), value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'composure'), value: r.nextScore(min: 55)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: AnalysisType.leadership.gradient,
      emoji: '🏆',
    );
  }

  AnalysisResult _romantic(
      SeededRandom r, FaceFeatures f, DateTime ts, String id, String l) {
    final String style = r.pick(ResultContent.romanticStyles(l));
    return AnalysisResult(
      id: id,
      type: AnalysisType.romanticStyle,
      createdAt: ts,
      primaryScore: r.nextScore(min: 60),
      title: style,
      subtitle: _t(l, 'Your romantic style', 'Tu estilo romántico', 'أسلوبك الرومانسي'),
      summary: '${r.pick(ResultContent.summaryOpeners(l))} ' +
          _t(l, 'a playful read on how you love.', 'una lectura divertida de cómo amas.', 'قراءة مرحة لطريقتك في الحب.'),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'passion'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'loyalty'), value: r.nextScore(min: 60)),
        ResultMetric(label: ResultContent.label(l, 'playfulness'), value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'mystery'), value: r.nextScore(min: 40)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: AnalysisType.romanticStyle.gradient,
      emoji: '💖',
    );
  }

  AnalysisResult _celebrity(
      SeededRandom r, FaceFeatures f, DateTime ts, String id, String l) {
    final String vibe = r.pick(ResultContent.celebrityVibes(l));
    final int match = r.nextScore(min: 72);
    return AnalysisResult(
      id: id,
      type: AnalysisType.celebrityLookAlike,
      createdAt: ts,
      primaryScore: match,
      title: _t(l, 'You give off $vibe energy',
          'Transmites la energía de $vibe', 'تُشِعّ طاقة $vibe'),
      subtitle: _t(l, '$match% vibe match', '$match% de afinidad',
          '$match% تطابق طاقة'),
      summary: '${r.pick(ResultContent.summaryOpeners(l))} ' +
          _t(l, 'a fun vibe match — not a literal look-alike.',
              'una afinidad de vibra divertida, no un parecido literal.',
              'تطابق طاقة ممتع — وليس شبهًا حرفيًا.'),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'starPower'), value: r.nextScore(min: 60)),
        ResultMetric(label: ResultContent.label(l, 'screenPresence'), value: _blend(f.smilingProbability, r.nextScore())),
        ResultMetric(label: ResultContent.label(l, 'charisma'), value: r.nextScore(min: 60)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: AnalysisType.celebrityLookAlike.gradient,
      emoji: '⭐',
      extra: <String, String>{'vibe': vibe},
    );
  }

  AnalysisResult _friendship(FaceFeatures a, FaceFeatures b, DateTime ts,
      {String salt = '', String lang = 'en'}) {
    final String l = ResultContent.norm(lang);
    final SeededRandom r = SeededRandom.fromString(
      'friendship|${a.seedSignature}|${b.seedSignature}|$salt',
    );
    final int score = r.nextScore(min: 62);
    return AnalysisResult(
      id: 'friendship-${ts.microsecondsSinceEpoch}',
      type: AnalysisType.friendshipCompatibility,
      createdAt: ts,
      primaryScore: score,
      title: _t(l, '$score% Compatible', '$score% Compatibles', '$score% متوافقان'),
      subtitle: _t(l, 'Friendship compatibility', 'Compatibilidad de amistad', 'توافق الصداقة'),
      summary: _t(
        l,
        'You two have a $score% match — expect great adventures together!',
        '¡Tienen un $score% de afinidad: les esperan grandes aventuras!',
        'بينكما توافق $score% — تنتظركما مغامرات رائعة!',
      ),
      metrics: <ResultMetric>[
        ResultMetric(label: ResultContent.label(l, 'communication'), value: r.nextScore(min: 55)),
        ResultMetric(label: ResultContent.label(l, 'funFactor'), value: r.nextScore(min: 60)),
        ResultMetric(label: ResultContent.label(l, 'trust'), value: r.nextScore(min: 58)),
        ResultMetric(label: ResultContent.label(l, 'adventure'), value: r.nextScore(min: 50)),
      ],
      traits: r.pickMany(ResultContent.traits(l), 3),
      gradientName: AnalysisType.friendshipCompatibility.gradient,
      emoji: '🤝',
    );
  }

  AnalysisResult _fromDaily(
      AnalysisType type, DailyPrediction p, DateTime ts, String id, String l) {
    switch (type) {
      case AnalysisType.dailyLuck:
        return AnalysisResult(
          id: id,
          type: type,
          createdAt: ts,
          primaryScore: p.luck,
          title: _t(l, 'Daily Luck: ${p.luck}', 'Suerte diaria: ${p.luck}', 'حظ اليوم: ${p.luck}'),
          subtitle: _t(
            l,
            'Lucky color ${p.luckyColor} • Number ${p.luckyNumber}',
            'Color ${p.luckyColor} • Número ${p.luckyNumber}',
            'لون ${p.luckyColor} • رقم ${p.luckyNumber}',
          ),
          summary: p.message,
          metrics: <ResultMetric>[
            ResultMetric(label: ResultContent.label(l, 'luck'), value: p.luck),
            ResultMetric(label: ResultContent.label(l, 'energy'), value: p.energy),
            ResultMetric(label: ResultContent.label(l, 'productivity'), value: p.productivity),
            ResultMetric(label: ResultContent.label(l, 'social'), value: p.social),
          ],
          traits: <String>[p.luckyColor, '#${p.luckyNumber}'],
          gradientName: type.gradient,
          emoji: '🍀',
          extra: <String, String>{'luckyColor': p.luckyColor, 'luckyNumber': '${p.luckyNumber}'},
        );
      case AnalysisType.futureMood:
        return AnalysisResult(
          id: id,
          type: type,
          createdAt: ts,
          primaryScore: p.overall,
          title: _t(l, 'Mood Forecast: ${p.moodLabel}', 'Pronóstico: ${p.moodLabel}', 'توقّع المزاج: ${p.moodLabel}'),
          subtitle: _t(l, 'How your day may feel', 'Cómo se siente tu día', 'كيف قد يكون يومك'),
          summary: _t(
            l,
            'Your mood forecast is "${p.moodLabel}" ${p.moodEmoji}. ${p.message}',
            'Tu pronóstico de ánimo es "${p.moodLabel}" ${p.moodEmoji}. ${p.message}',
            'توقّع مزاجك هو «${p.moodLabel}» ${p.moodEmoji}. ${p.message}',
          ),
          metrics: <ResultMetric>[
            ResultMetric(label: ResultContent.label(l, 'morning'), value: p.energy),
            ResultMetric(label: ResultContent.label(l, 'afternoon'), value: p.productivity),
            ResultMetric(label: ResultContent.label(l, 'evening'), value: p.social),
            ResultMetric(label: ResultContent.label(l, 'overall'), value: p.overall),
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
          title: _t(l, 'Today\'s Positive Message', 'Mensaje positivo de hoy', 'رسالة اليوم الإيجابية'),
          subtitle: _t(l, 'A little reminder for you', 'Un pequeño recordatorio', 'تذكير صغير لك'),
          summary: p.affirmation,
          metrics: <ResultMetric>[
            ResultMetric(label: ResultContent.label(l, 'positivity'), value: 100),
            ResultMetric(label: ResultContent.label(l, 'selfLove'), value: 97),
            ResultMetric(label: ResultContent.label(l, 'gratitude'), value: 95),
          ],
          traits: <String>[
            _t(l, 'You matter', 'Importas', 'أنت مهم'),
            _t(l, 'Keep shining', 'Sigue brillando', 'واصل التألّق'),
          ],
          gradientName: type.gradient,
          emoji: '🌟',
        );
      default:
        throw ArgumentError('Not a daily type: $type');
    }
  }

  // ---------------------------------------------------------------------------

  /// Picks the localized string for [l].
  String _t(String l, String en, String es, String ar) =>
      l == 'es' ? es : (l == 'ar' ? ar : en);

  int _blend(double signal, int random) {
    final double v = (signal.clamp(0.0, 1.0) * 100 * 0.45) + (random * 0.55);
    return v.round().clamp(20, 99);
  }

  String _dayKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
