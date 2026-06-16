/// Curated, entertainment-only copy banks used by [ResultGenerator].
///
/// Nothing here is a factual, scientific, medical, or psychological claim — it
/// is intentionally playful flavor text.
abstract final class ResultContent {
  // Aura colors mapped to a signature gradient + emoji.
  static const List<({String name, String gradient, String emoji})> auras = [
    (name: 'Radiant Violet', gradient: 'aura', emoji: '🔮'),
    (name: 'Electric Magenta', gradient: 'royal', emoji: '✨'),
    (name: 'Ocean Teal', gradient: 'ocean', emoji: '🌊'),
    (name: 'Golden Sunrise', gradient: 'sunrise', emoji: '🌅'),
    (name: 'Rose Quartz', gradient: 'romance', emoji: '🌸'),
    (name: 'Cosmic Indigo', gradient: 'dusk', emoji: '🌌'),
    (name: 'Emerald Glow', gradient: 'ocean', emoji: '🍀'),
    (name: 'Solar Amber', gradient: 'sunrise', emoji: '🔆'),
  ];

  static const List<String> positiveAdjectives = [
    'magnetic', 'radiant', 'warm', 'bold', 'serene', 'playful', 'grounded',
    'luminous', 'curious', 'unstoppable', 'effortlessly cool', 'kind-hearted',
    'creative', 'fearless', 'charming',
  ];

  // Personality archetypes (fun, not a personality test).
  static const List<({String name, String emoji})> personalityArchetypes = [
    (name: 'The Dreamer', emoji: '💭'),
    (name: 'The Spark', emoji: '⚡'),
    (name: 'The Explorer', emoji: '🧭'),
    (name: 'The Guardian', emoji: '🛡️'),
    (name: 'The Visionary', emoji: '🔭'),
    (name: 'The Free Spirit', emoji: '🦋'),
    (name: 'The Strategist', emoji: '♟️'),
    (name: 'The Sunbeam', emoji: '☀️'),
  ];

  static const List<String> leadershipArchetypes = [
    'The Quiet Captain',
    'The Trailblazer',
    'The People\'s Champion',
    'The Visionary Founder',
    'The Steady Anchor',
    'The Bold Initiator',
    'The Mentor',
  ];

  static const List<String> romanticStyles = [
    'The Hopeless Romantic',
    'The Slow Burn',
    'The Adventurous Heart',
    'The Loyal Soul',
    'The Playful Flirt',
    'The Deep Feeler',
    'The Free-Spirited Lover',
  ];

  static const List<String> firstImpressionVibes = [
    'approachable and bright',
    'confident and composed',
    'mysterious and intriguing',
    'warm and trustworthy',
    'fun and easygoing',
    'sharp and ambitious',
    'calm and reassuring',
  ];

  // Framed as a "vibe match," never a literal identity claim.
  static const List<String> celebrityVibes = [
    'a charismatic pop icon',
    'a beloved movie lead',
    'a fearless adventurer-host',
    'a chart-topping artist',
    'a witty late-night favorite',
    'a timeless style icon',
    'a record-breaking athlete',
    'a visionary creator',
  ];

  static const List<({String emoji, String label})> moods = [
    (emoji: '😄', label: 'Upbeat & Bright'),
    (emoji: '😌', label: 'Calm & Centered'),
    (emoji: '🤩', label: 'Excited & Inspired'),
    (emoji: '😎', label: 'Cool & Confident'),
    (emoji: '🥰', label: 'Warm & Open'),
    (emoji: '🤔', label: 'Thoughtful & Focused'),
    (emoji: '🚀', label: 'Driven & Energized'),
  ];

  static const List<String> motivationalMessages = [
    'Small steps today, big leaps tomorrow. You\'ve got this!',
    'Your energy sets the tone — make it a good one.',
    'Today is a great day to surprise yourself.',
    'Trust your spark. The right doors are opening.',
    'Progress over perfection. Keep going!',
    'Good things are gravitating toward you today.',
    'You bring a light that rooms remember.',
    'Be bold. Future-you is cheering you on.',
  ];

  static const List<String> affirmations = [
    'You are exactly where you need to be.',
    'Your kindness is your superpower.',
    'You deserve good things, and they\'re coming.',
    'Your presence makes a difference.',
    'You are growing more confident every day.',
    'Today, you choose joy.',
    'You are capable of amazing things.',
  ];

  static const List<String> luckyColors = [
    'Violet', 'Coral', 'Teal', 'Gold', 'Sky Blue', 'Emerald', 'Magenta',
    'Sunset Orange', 'Rose', 'Silver',
  ];

  // General trait pool for chips.
  static const List<String> traits = [
    'Curious', 'Warm', 'Bold', 'Creative', 'Loyal', 'Witty', 'Driven',
    'Calm', 'Adventurous', 'Empathetic', 'Charismatic', 'Optimistic',
    'Resourceful', 'Playful', 'Focused', 'Generous', 'Magnetic', 'Grounded',
  ];

  static const List<String> summaryOpeners = [
    'The vibes are strong today —',
    'Here\'s what your glow is saying:',
    'The dream meter lit up:',
    'Reading your energy...',
    'Your aura whispered something fun:',
  ];
}
