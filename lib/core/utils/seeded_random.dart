/// A small, fully deterministic pseudo-random generator.
///
/// We deliberately avoid `dart:math`'s `Random(seed)` and `String.hashCode`
/// for the seed because we need results that are stable **across app launches
/// and platforms** (e.g. a "Daily Luck" score must be identical every time the
/// user opens the app on the same day). This uses a stable FNV-1a hash to build
/// the seed and an xorshift32 sequence to produce numbers.
class SeededRandom {
  SeededRandom(int seed) : _state = seed == 0 ? 0x9E3779B9 : (seed & 0xFFFFFFFF);

  /// Build a generator from any string (stable across runs).
  factory SeededRandom.fromString(String input) =>
      SeededRandom(fnv1a32(input));

  int _state;

  /// FNV-1a 32-bit hash — deterministic and platform independent.
  static int fnv1a32(String input) {
    int hash = 0x811C9DC5;
    for (final int codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  int _next() {
    int x = _state;
    x ^= (x << 13) & 0xFFFFFFFF;
    x ^= x >> 17;
    x ^= (x << 5) & 0xFFFFFFFF;
    _state = x & 0xFFFFFFFF;
    return _state;
  }

  /// Double in [0, 1).
  double nextDouble() => _next() / 0x100000000;

  /// Integer in [min, max] inclusive.
  int nextInt(int min, int max) {
    if (max <= min) return min;
    return min + (nextDouble() * (max - min + 1)).floor();
  }

  /// A score in [min, max], biased gently toward the upper-middle so the app
  /// feels positive and encouraging (entertainment-first).
  int nextScore({int min = 35, int max = 99}) {
    // Average two draws -> triangular distribution centered mid-range, then
    // nudge upward so most results feel flattering.
    final double a = nextDouble();
    final double b = nextDouble();
    final double base = (a + b) / 2; // centered ~0.5
    final double nudged = (base * 0.7) + 0.3; // shift toward higher values
    return (min + nudged * (max - min)).round().clamp(min, max);
  }

  /// Pick one element deterministically.
  T pick<T>(List<T> items) => items[nextInt(0, items.length - 1)];

  /// Pick [count] distinct elements (or all, if count exceeds length).
  List<T> pickMany<T>(List<T> items, int count) {
    final List<T> pool = List<T>.of(items);
    final List<T> out = <T>[];
    final int n = count.clamp(0, pool.length);
    for (int i = 0; i < n; i++) {
      out.add(pool.removeAt(nextInt(0, pool.length - 1)));
    }
    return out;
  }
}
