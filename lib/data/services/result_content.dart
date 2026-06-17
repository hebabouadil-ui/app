/// Curated, entertainment-only, **localized** copy banks used by
/// [ResultGenerator]. Banks are parallel arrays across languages (same length /
/// order) so the generator can pick an index once and resolve it per language.
/// Supported: en, es, ar (fallback en).
abstract final class ResultContent {
  static String norm(String? lang) =>
      (lang == 'es' || lang == 'ar') ? lang! : 'en';

  static List<T> _loc<T>(Map<String, List<T>> m, String lang) =>
      m[lang] ?? m['en']!;

  // ---- Aura (shared gradient + emoji, localized name) -----------------------
  static const List<String> auraGradients = <String>[
    'aura', 'royal', 'ocean', 'sunrise', 'romance', 'dusk',
  ];
  static const List<String> auraEmojis = <String>[
    '🔮', '✨', '🌊', '🌅', '🌸', '🌌',
  ];
  static const Map<String, List<String>> _auraNames = <String, List<String>>{
    'en': ['Radiant Violet', 'Electric Magenta', 'Ocean Teal', 'Golden Sunrise', 'Rose Quartz', 'Cosmic Indigo'],
    'es': ['Violeta Radiante', 'Magenta Eléctrico', 'Turquesa Océano', 'Amanecer Dorado', 'Cuarzo Rosa', 'Índigo Cósmico'],
    'ar': ['البنفسجي المشع', 'الأرجواني الكهربائي', 'الفيروزي المحيطي', 'الشروق الذهبي', 'الكوارتز الوردي', 'النيلي الكوني'],
  };
  static List<String> auraNames(String l) => _loc(_auraNames, l);

  // ---- Adjectives (8) -------------------------------------------------------
  static const Map<String, List<String>> _adjectives = <String, List<String>>{
    'en': ['magnetic', 'radiant', 'warm', 'bold', 'serene', 'playful', 'creative', 'charming'],
    'es': ['magnética', 'radiante', 'cálida', 'audaz', 'serena', 'divertida', 'creativa', 'encantadora'],
    'ar': ['جاذبة', 'مشِعّة', 'دافئة', 'جريئة', 'هادئة', 'مرحة', 'مبدعة', 'ساحرة'],
  };
  static List<String> adjectives(String l) => _loc(_adjectives, l);

  // ---- Personality archetypes (shared emoji) --------------------------------
  static const List<String> personalityEmojis = <String>[
    '💭', '⚡', '🧭', '🛡️', '🔭', '🦋', '♟️', '☀️',
  ];
  static const Map<String, List<String>> _personality = <String, List<String>>{
    'en': ['The Dreamer', 'The Spark', 'The Explorer', 'The Guardian', 'The Visionary', 'The Free Spirit', 'The Strategist', 'The Sunbeam'],
    'es': ['El Soñador', 'La Chispa', 'El Explorador', 'El Guardián', 'El Visionario', 'El Espíritu Libre', 'El Estratega', 'El Rayo de Sol'],
    'ar': ['الحالم', 'الشرارة', 'المستكشف', 'الحارس', 'صاحب الرؤية', 'الروح الحرة', 'الاستراتيجي', 'شعاع الشمس'],
  };
  static List<String> personalityArchetypes(String l) => _loc(_personality, l);

  // ---- Leadership archetypes (7) --------------------------------------------
  static const Map<String, List<String>> _leadership = <String, List<String>>{
    'en': ['The Quiet Captain', 'The Trailblazer', 'The People\'s Champion', 'The Visionary Founder', 'The Steady Anchor', 'The Bold Initiator', 'The Mentor'],
    'es': ['El Capitán Sereno', 'El Pionero', 'El Campeón del Equipo', 'El Fundador Visionario', 'El Ancla Firme', 'El Iniciador Audaz', 'El Mentor'],
    'ar': ['القائد الهادئ', 'الرائد', 'بطل الفريق', 'المؤسس صاحب الرؤية', 'المرتكز الثابت', 'المبادر الجريء', 'المُرشد'],
  };
  static List<String> leadershipArchetypes(String l) => _loc(_leadership, l);

  // ---- Romantic styles (7) --------------------------------------------------
  static const Map<String, List<String>> _romantic = <String, List<String>>{
    'en': ['The Hopeless Romantic', 'The Slow Burn', 'The Adventurous Heart', 'The Loyal Soul', 'The Playful Flirt', 'The Deep Feeler', 'The Free-Spirited Lover'],
    'es': ['El Romántico Empedernido', 'El Amor Lento', 'El Corazón Aventurero', 'El Alma Leal', 'El Coqueto Juguetón', 'El Sentimental Profundo', 'El Amante de Espíritu Libre'],
    'ar': ['الرومانسي الحالم', 'الحب المتأنّي', 'القلب المغامر', 'الروح الوفيّة', 'المازح اللطيف', 'العميق المشاعر', 'المحب الحر'],
  };
  static List<String> romanticStyles(String l) => _loc(_romantic, l);

  // ---- First impression vibes (7) -------------------------------------------
  static const Map<String, List<String>> _firstImpression = <String, List<String>>{
    'en': ['approachable and bright', 'confident and composed', 'mysterious and intriguing', 'warm and trustworthy', 'fun and easygoing', 'sharp and ambitious', 'calm and reassuring'],
    'es': ['accesible y brillante', 'segura y serena', 'misteriosa e intrigante', 'cálida y confiable', 'divertida y relajada', 'aguda y ambiciosa', 'tranquila y reconfortante'],
    'ar': ['ودود ومشرق', 'واثق ورزين', 'غامض ومثير للاهتمام', 'دافئ وجدير بالثقة', 'مرح وسهل المعشر', 'ذكي وطموح', 'هادئ ومطمئن'],
  };
  static List<String> firstImpressionVibes(String l) => _loc(_firstImpression, l);

  // ---- Celebrity vibes (8) --------------------------------------------------
  static const Map<String, List<String>> _celebrity = <String, List<String>>{
    'en': ['a charismatic pop icon', 'a beloved movie lead', 'a fearless adventurer-host', 'a chart-topping artist', 'a witty late-night favorite', 'a timeless style icon', 'a record-breaking athlete', 'a visionary creator'],
    'es': ['un icono pop carismático', 'un protagonista de cine querido', 'un presentador aventurero', 'un artista número uno', 'un favorito ingenioso de la TV', 'un icono de estilo atemporal', 'un atleta que rompe récords', 'un creador visionario'],
    'ar': ['أيقونة بوب جذّابة', 'بطل سينمائي محبوب', 'مغامر مقدِّم برامج', 'فنان متصدّر للقوائم', 'نجم برامج مسائية لمّاح', 'أيقونة أناقة خالدة', 'رياضي محطّم للأرقام', 'مبدع صاحب رؤية'],
  };
  static List<String> celebrityVibes(String l) => _loc(_celebrity, l);

  // ---- Moods (shared emoji) -------------------------------------------------
  static const List<String> moodEmojis = <String>[
    '😄', '😌', '🤩', '😎', '🥰', '🤔', '🚀',
  ];
  static const Map<String, List<String>> _moods = <String, List<String>>{
    'en': ['Upbeat & Bright', 'Calm & Centered', 'Excited & Inspired', 'Cool & Confident', 'Warm & Open', 'Thoughtful & Focused', 'Driven & Energized'],
    'es': ['Animado y Brillante', 'Tranquilo y Centrado', 'Emocionado e Inspirado', 'Sereno y Seguro', 'Cálido y Abierto', 'Reflexivo y Concentrado', 'Motivado y Lleno de Energía'],
    'ar': ['مبتهج ومشرق', 'هادئ ومتّزن', 'متحمّس وملهَم', 'رائق وواثق', 'دافئ ومنفتح', 'متأمّل ومركّز', 'مندفع ونشِط'],
  };
  static List<String> moodLabels(String l) => _loc(_moods, l);

  // ---- Motivational messages (6) --------------------------------------------
  static const Map<String, List<String>> _messages = <String, List<String>>{
    'en': [
      'Small steps today, big leaps tomorrow. You\'ve got this!',
      'Your energy sets the tone — make it a good one.',
      'Today is a great day to surprise yourself.',
      'Trust your spark. The right doors are opening.',
      'Good things are gravitating toward you today.',
      'Be bold. Future-you is cheering you on.',
    ],
    'es': [
      'Pequeños pasos hoy, grandes saltos mañana. ¡Tú puedes!',
      'Tu energía marca el tono: que sea buena.',
      'Hoy es un gran día para sorprenderte a ti mismo.',
      'Confía en tu chispa. Las puertas correctas se abren.',
      'Hoy las cosas buenas gravitan hacia ti.',
      'Sé audaz. Tu yo del futuro te anima.',
    ],
    'ar': [
      'خطوات صغيرة اليوم، قفزات كبيرة غدًا. أنت قادر!',
      'طاقتك تحدّد الأجواء — اجعلها رائعة.',
      'اليوم يوم رائع لتفاجئ نفسك.',
      'ثِق بشرارتك. الأبواب الصحيحة تُفتح.',
      'الأشياء الجميلة تنجذب إليك اليوم.',
      'كن جريئًا. نسختك المستقبلية تشجّعك.',
    ],
  };
  static List<String> motivationalMessages(String l) => _loc(_messages, l);

  // ---- Affirmations (6) -----------------------------------------------------
  static const Map<String, List<String>> _affirmations = <String, List<String>>{
    'en': [
      'You are exactly where you need to be.',
      'Your kindness is your superpower.',
      'You deserve good things, and they\'re coming.',
      'Your presence makes a difference.',
      'You are growing more confident every day.',
      'You are capable of amazing things.',
    ],
    'es': [
      'Estás exactamente donde debes estar.',
      'Tu amabilidad es tu superpoder.',
      'Mereces cosas buenas, y están llegando.',
      'Tu presencia marca la diferencia.',
      'Cada día eres más seguro de ti mismo.',
      'Eres capaz de cosas increíbles.',
    ],
    'ar': [
      'أنت تمامًا حيث يجب أن تكون.',
      'لطفك هو قوّتك الخارقة.',
      'تستحق الأشياء الجميلة، وهي قادمة.',
      'حضورك يصنع فرقًا.',
      'تزداد ثقةً بنفسك كل يوم.',
      'أنت قادر على أشياء مذهلة.',
    ],
  };
  static List<String> affirmations(String l) => _loc(_affirmations, l);

  // ---- Lucky colors (8) -----------------------------------------------------
  static const Map<String, List<String>> _luckyColors = <String, List<String>>{
    'en': ['Violet', 'Coral', 'Teal', 'Gold', 'Sky Blue', 'Emerald', 'Magenta', 'Rose'],
    'es': ['Violeta', 'Coral', 'Turquesa', 'Dorado', 'Azul Cielo', 'Esmeralda', 'Magenta', 'Rosa'],
    'ar': ['بنفسجي', 'مرجاني', 'فيروزي', 'ذهبي', 'أزرق سماوي', 'زمرّدي', 'أرجواني', 'وردي'],
  };
  static List<String> luckyColors(String l) => _loc(_luckyColors, l);

  // ---- Trait chips (12) -----------------------------------------------------
  static const Map<String, List<String>> _traits = <String, List<String>>{
    'en': ['Curious', 'Warm', 'Bold', 'Creative', 'Loyal', 'Witty', 'Driven', 'Calm', 'Adventurous', 'Charismatic', 'Optimistic', 'Magnetic'],
    'es': ['Curioso', 'Cálido', 'Audaz', 'Creativo', 'Leal', 'Ingenioso', 'Decidido', 'Tranquilo', 'Aventurero', 'Carismático', 'Optimista', 'Magnético'],
    'ar': ['فضولي', 'دافئ', 'جريء', 'مبدع', 'وفيّ', 'لمّاح', 'طموح', 'هادئ', 'مغامر', 'جذّاب', 'متفائل', 'آسِر'],
  };
  static List<String> traits(String l) => _loc(_traits, l);

  // ---- Summary openers (5) --------------------------------------------------
  static const Map<String, List<String>> _openers = <String, List<String>>{
    'en': ['The vibes are strong today —', 'Here\'s what your glow is saying:', 'Reading your energy...', 'Your aura whispered something fun:', 'The dream meter lit up:'],
    'es': ['Las vibras están fuertes hoy —', 'Esto dice tu brillo:', 'Leyendo tu energía...', 'Tu aura susurró algo divertido:', 'El medidor de sueños se encendió:'],
    'ar': ['الطاقة قويّة اليوم —', 'هذا ما تقوله إشراقتك:', 'نقرأ طاقتك...', 'همست هالتك بشيء ممتع:', 'أضاء مقياس الأحلام:'],
  };
  static List<String> summaryOpeners(String l) => _loc(_openers, l);

  // ---- Palm reading ---------------------------------------------------------
  static const List<String> palmEmojis = <String>[
    '🖐️', '✋', '🤚', '🌿', '🧭', '🔮', '👑',
  ];
  static const Map<String, List<String>> _palmArche = <String, List<String>>{
    'en': ['The Creator\'s Hand', 'The Dreamer\'s Palm', 'The Achiever\'s Hand', 'The Healer\'s Palm', 'The Adventurer\'s Hand', 'The Old Soul\'s Palm', 'The Leader\'s Hand'],
    'es': ['La Mano del Creador', 'La Palma del Soñador', 'La Mano del Triunfador', 'La Palma del Sanador', 'La Mano del Aventurero', 'La Palma del Alma Vieja', 'La Mano del Líder'],
    'ar': ['كف المبدع', 'كف الحالم', 'كف المُنجِز', 'كف الشافي', 'كف المغامر', 'كف الروح العتيقة', 'كف القائد'],
  };
  static List<String> palmArchetypes(String l) => _loc(_palmArche, l);

  static const Map<String, List<String>> _palmFortunes = <String, List<String>>{
    'en': [
      'your lines point to a bright new chapter — say yes to an opportunity soon.',
      'a strong heart line: genuine connections are forming around you.',
      'your head line is sharp — trust your first instinct this week.',
      'a bold life line: vitality and big moves are on your side now.',
      'your fate line is rising — a small, brave risk could pay off.',
      'a lucky crossing in your palm — watch for a happy surprise.',
    ],
    'es': [
      'tus líneas apuntan a un nuevo capítulo brillante: di sí pronto a una oportunidad.',
      'una línea del corazón fuerte: se forman conexiones genuinas a tu alrededor.',
      'tu línea de la cabeza está aguda: confía en tu primer instinto esta semana.',
      'una línea de la vida audaz: la vitalidad y los grandes pasos están de tu lado.',
      'tu línea del destino sube: un pequeño riesgo valiente podría dar fruto.',
      'un cruce de suerte en tu palma: atento a una grata sorpresa.',
    ],
    'ar': [
      'خطوطك تشير إلى فصل جديد مشرق — قل نعم لفرصة قريبًا.',
      'خط قلب قوي: علاقات صادقة تتشكّل من حولك.',
      'خط رأسك حاد — ثِق بحدسك الأول هذا الأسبوع.',
      'خط حياة جريء: الحيوية والخطوات الكبيرة في صفّك الآن.',
      'خط حظّك يرتفع — مخاطرة صغيرة شجاعة قد تثمر.',
      'تقاطع حظّ في كفّك — ترقّب مفاجأة سعيدة.',
    ],
  };
  static List<String> palmFortunes(String l) => _loc(_palmFortunes, l);

  // ---- Metric labels --------------------------------------------------------
  static const Map<String, Map<String, String>> _labels =
      <String, Map<String, String>>{
    'positivity': {'en': 'Positivity', 'es': 'Positividad', 'ar': 'الإيجابية'},
    'magnetism': {'en': 'Magnetism', 'es': 'Magnetismo', 'ar': 'الجاذبية'},
    'calm': {'en': 'Calm', 'es': 'Calma', 'ar': 'الهدوء'},
    'creativity': {'en': 'Creativity', 'es': 'Creatividad', 'ar': 'الإبداع'},
    'openness': {'en': 'Openness', 'es': 'Apertura', 'ar': 'الانفتاح'},
    'energy': {'en': 'Energy', 'es': 'Energía', 'ar': 'الطاقة'},
    'warmth': {'en': 'Warmth', 'es': 'Calidez', 'ar': 'الدفء'},
    'focus': {'en': 'Focus', 'es': 'Concentración', 'ar': 'التركيز'},
    'boldness': {'en': 'Boldness', 'es': 'Audacia', 'ar': 'الجرأة'},
    'approachability': {'en': 'Approachability', 'es': 'Cercanía', 'ar': 'سهولة التواصل'},
    'confidence': {'en': 'Confidence', 'es': 'Confianza', 'ar': 'الثقة'},
    'trustworthiness': {'en': 'Trustworthiness', 'es': 'Fiabilidad', 'ar': 'الجدارة بالثقة'},
    'charm': {'en': 'Charm', 'es': 'Encanto', 'ar': 'السحر'},
    'vision': {'en': 'Vision', 'es': 'Visión', 'ar': 'الرؤية'},
    'decisiveness': {'en': 'Decisiveness', 'es': 'Decisión', 'ar': 'الحسم'},
    'influence': {'en': 'Influence', 'es': 'Influencia', 'ar': 'التأثير'},
    'composure': {'en': 'Composure', 'es': 'Aplomo', 'ar': 'رباطة الجأش'},
    'passion': {'en': 'Passion', 'es': 'Pasión', 'ar': 'الشغف'},
    'loyalty': {'en': 'Loyalty', 'es': 'Lealtad', 'ar': 'الولاء'},
    'playfulness': {'en': 'Playfulness', 'es': 'Picardía', 'ar': 'المرح'},
    'mystery': {'en': 'Mystery', 'es': 'Misterio', 'ar': 'الغموض'},
    'starPower': {'en': 'Star Power', 'es': 'Estrella', 'ar': 'بريق النجومية'},
    'screenPresence': {'en': 'Screen Presence', 'es': 'Presencia', 'ar': 'الحضور'},
    'charisma': {'en': 'Charisma', 'es': 'Carisma', 'ar': 'الكاريزما'},
    'communication': {'en': 'Communication', 'es': 'Comunicación', 'ar': 'التواصل'},
    'funFactor': {'en': 'Fun Factor', 'es': 'Diversión', 'ar': 'المتعة'},
    'trust': {'en': 'Trust', 'es': 'Confianza', 'ar': 'الثقة'},
    'adventure': {'en': 'Adventure', 'es': 'Aventura', 'ar': 'المغامرة'},
    'lifeLine': {'en': 'Life Line', 'es': 'Línea de la vida', 'ar': 'خط الحياة'},
    'heartLine': {'en': 'Heart Line', 'es': 'Línea del corazón', 'ar': 'خط القلب'},
    'headLine': {'en': 'Head Line', 'es': 'Línea de la cabeza', 'ar': 'خط الرأس'},
    'fateLine': {'en': 'Fate Line', 'es': 'Línea del destino', 'ar': 'خط القدر'},
    'luck': {'en': 'Luck', 'es': 'Suerte', 'ar': 'الحظ'},
    'productivity': {'en': 'Productivity', 'es': 'Productividad', 'ar': 'الإنتاجية'},
    'social': {'en': 'Social', 'es': 'Social', 'ar': 'الاجتماعي'},
    'morning': {'en': 'Morning', 'es': 'Mañana', 'ar': 'الصباح'},
    'afternoon': {'en': 'Afternoon', 'es': 'Tarde', 'ar': 'بعد الظهر'},
    'evening': {'en': 'Evening', 'es': 'Noche', 'ar': 'المساء'},
    'overall': {'en': 'Overall', 'es': 'General', 'ar': 'الإجمالي'},
    'selfLove': {'en': 'Self-Love', 'es': 'Amor propio', 'ar': 'حب الذات'},
    'gratitude': {'en': 'Gratitude', 'es': 'Gratitud', 'ar': 'الامتنان'},
  };

  static String label(String l, String key) =>
      _labels[key]?[l] ?? _labels[key]?['en'] ?? key;
}
