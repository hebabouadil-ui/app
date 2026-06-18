/// A large, localized library of rich, multi-sentence uplifting messages.
///
/// Powers the **Daily Oracle** feature and the **Today's Positive Message**
/// result, so users always get something substantial (never "2–3 words").
/// Entertainment only. Supported langs: en, es, ar (fallback en).
abstract final class OracleContent {
  static const Map<String, List<({String theme, String text})>> _cards =
      <String, List<({String theme, String text})>>{
    'en': <({String theme, String text})>[
      (theme: 'Trust', text: 'Trust the quiet voice inside you today — it has been right all along. Something you have been waiting for is closer than it appears.'),
      (theme: 'Kindness', text: 'Your kindness is a magnet for good things. Don\'t be surprised when the world returns it to you twofold this week.'),
      (theme: 'Courage', text: 'A door you thought was closed is simply waiting for your knock. Be brave enough to reach for the handle.'),
      (theme: 'Timing', text: 'You are not behind. You are exactly on your own perfect timeline, and quiet momentum is building beneath your feet.'),
      (theme: 'Release', text: 'Let go of one small worry today. In the space it leaves, something lighter and brighter has room to grow.'),
      (theme: 'Energy', text: 'The energy you give the world is on its way back to find you. Make it warm, make it bold, make it yours.'),
      (theme: 'Connection', text: 'A new connection is quietly forming. Stay open, smile first, and watch what begins to unfold around you.'),
      (theme: 'Voice', text: 'Your ideas matter more than you think. Say the one you have been holding back — it is meant to be heard.'),
      (theme: 'Rest', text: 'Rest is not the opposite of progress. Today, gentleness with yourself will carry you further than force ever could.'),
      (theme: 'Curiosity', text: 'Luck favors the curious. Say yes to the small adventure that finds you, and let it surprise you.'),
      (theme: 'Strength', text: 'You have survived every difficult day so far — a perfect record. Today is no match for who you have become.'),
      (theme: 'Creation', text: 'Something you create this week will outlive the doubt you feel today. Begin it anyway; future-you is grateful.'),
      (theme: 'Abundance', text: 'Notice how much is already going right. Gratitude turns what you have into more than enough.'),
      (theme: 'Growth', text: 'The part of you that feels challenged today is the exact part that is about to grow. Lean in gently.'),
    ],
    'es': <({String theme, String text})>[
      (theme: 'Confianza', text: 'Confía hoy en esa voz tranquila dentro de ti: siempre ha tenido razón. Algo que esperabas está más cerca de lo que parece.'),
      (theme: 'Bondad', text: 'Tu bondad atrae cosas buenas. No te sorprendas si el mundo te la devuelve el doble esta semana.'),
      (theme: 'Valor', text: 'Una puerta que creías cerrada solo espera que llames. Ten el valor de girar el picaporte.'),
      (theme: 'Tiempo', text: 'No vas atrasado. Estás justo en tu propio tiempo perfecto, y el impulso crece poco a poco bajo tus pies.'),
      (theme: 'Soltar', text: 'Suelta hoy una pequeña preocupación. En el espacio que deja, algo más ligero y brillante puede crecer.'),
      (theme: 'Energía', text: 'La energía que das al mundo viene de regreso hacia ti. Que sea cálida, audaz y tuya.'),
      (theme: 'Conexión', text: 'Una nueva conexión se está formando. Mantente abierto, sonríe primero y observa lo que comienza a suceder.'),
      (theme: 'Voz', text: 'Tus ideas importan más de lo que crees. Di esa que estás guardando: merece ser escuchada.'),
      (theme: 'Descanso', text: 'Descansar no es lo opuesto al progreso. Hoy, tratarte con suavidad te llevará más lejos que la fuerza.'),
      (theme: 'Curiosidad', text: 'La suerte favorece a los curiosos. Di sí a la pequeña aventura que te encuentre y deja que te sorprenda.'),
      (theme: 'Fortaleza', text: 'Has superado cada día difícil hasta ahora: un récord perfecto. Hoy no es rival para quien te has vuelto.'),
      (theme: 'Crear', text: 'Algo que crees esta semana vivirá más que la duda de hoy. Empiézalo igual; tu yo futuro te lo agradecerá.'),
      (theme: 'Abundancia', text: 'Nota cuánto va ya bien. La gratitud convierte lo que tienes en más que suficiente.'),
      (theme: 'Crecimiento', text: 'La parte de ti que hoy se siente desafiada es justo la que está por crecer. Acércate con calma.'),
    ],
    'ar': <({String theme, String text})>[
      (theme: 'ثقة', text: 'ثِق اليوم بذلك الصوت الهادئ في داخلك — لطالما كان على حق. ما تنتظره أقرب مما يبدو.'),
      (theme: 'لطف', text: 'لطفك يجذب الخير. لا تتفاجأ حين يردّه لك العالم ضعفين هذا الأسبوع.'),
      (theme: 'شجاعة', text: 'بابٌ ظننته مغلقًا ينتظر طرقتك فقط. كن شجاعًا بما يكفي لتمدّ يدك إلى المقبض.'),
      (theme: 'توقيت', text: 'أنت لست متأخرًا. أنت تمامًا في توقيتك المثالي، والزخم يتنامى بهدوء تحت قدميك.'),
      (theme: 'تحرّر', text: 'تخلَّ اليوم عن قلق صغير. في المساحة التي يتركها سينمو شيء أخفّ وأكثر إشراقًا.'),
      (theme: 'طاقة', text: 'الطاقة التي تمنحها للعالم في طريقها إليك. اجعلها دافئة وجريئة وخاصة بك.'),
      (theme: 'تواصل', text: 'علاقة جديدة تتشكّل بهدوء. ابقَ منفتحًا، وابتسم أولًا، وراقب ما يبدأ حولك.'),
      (theme: 'صوت', text: 'أفكارك أهم مما تظن. قُل تلك التي كنت تكتمها — فهي تستحق أن تُسمع.'),
      (theme: 'راحة', text: 'الراحة ليست نقيض التقدّم. اليوم، لطفك بنفسك سيمضي بك أبعد مما تفعل القسوة.'),
      (theme: 'فضول', text: 'الحظ يحابي الفضوليين. قُل نعم للمغامرة الصغيرة التي تجدك، ودعها تفاجئك.'),
      (theme: 'قوة', text: 'لقد تجاوزت كل يوم صعب حتى الآن — سجلّ كامل. اليوم لا يضاهي من أصبحت عليه.'),
      (theme: 'إبداع', text: 'شيء تصنعه هذا الأسبوع سيبقى أطول من شكوك اليوم. ابدأه على أي حال؛ نسختك المستقبلية ممتنّة.'),
      (theme: 'وفرة', text: 'لاحظ كم من الأمور تسير على ما يرام بالفعل. الامتنان يحوّل ما تملكه إلى أكثر من كافٍ.'),
      (theme: 'نمو', text: 'الجزء الذي يشعر بالتحدّي فيك اليوم هو تحديدًا ما سينمو قريبًا. اقترب منه برفق.'),
    ],
  };

  static List<({String theme, String text})> cards(String lang) =>
      _cards[lang] ?? _cards['en']!;

  /// Just the message texts (used by the Positive Message result).
  static List<String> messages(String lang) =>
      cards(lang).map((c) => c.text).toList();
}
