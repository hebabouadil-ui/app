import 'package:dream_ai/data/models/analysis_type.dart';
import 'package:dream_ai/data/models/face_features.dart';
import 'package:dream_ai/data/services/result_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ResultGenerator gen = ResultGenerator();
  final DateTime fixedDay = DateTime(2026, 6, 16, 9, 30);

  group('ResultGenerator.generate', () {
    test('produces a valid result for every analysis type', () {
      for (final AnalysisType type in AnalysisType.values) {
        final result = gen.generate(
          type: type,
          features: const FaceFeatures.none(),
          now: fixedDay,
        );
        expect(result.primaryScore, inInclusiveRange(0, 100));
        expect(result.title, isNotEmpty);
        expect(result.summary, isNotEmpty);
        expect(result.gradientName, isNotEmpty);
        for (final m in result.metrics) {
          expect(m.value, inInclusiveRange(0, 100));
        }
      }
    });

    test('positive message is always a perfect score', () {
      final result = gen.generate(
        type: AnalysisType.positiveMessage,
        features: const FaceFeatures.none(),
        now: fixedDay,
      );
      expect(result.primaryScore, 100);
    });

    test('trait-based experiences are stable for the same face', () {
      const FaceFeatures face = FaceFeatures(
        faceFound: true,
        smilingProbability: 0.8,
        symmetry: 0.7,
        landmarkCount: 6,
      );
      final a = gen.generate(
          type: AnalysisType.personality, features: face, now: fixedDay);
      final b = gen.generate(
          type: AnalysisType.personality, features: face, now: fixedDay);
      expect(a.title, b.title);
      expect(a.primaryScore, b.primaryScore);
    });
  });

  group('ResultGenerator.generateDailyPrediction', () {
    test('is deterministic per day + salt', () {
      final p1 = gen.generateDailyPrediction(fixedDay, salt: 'user-1');
      final p2 = gen.generateDailyPrediction(fixedDay, salt: 'user-1');
      expect(p1.luck, p2.luck);
      expect(p1.moodLabel, p2.moodLabel);
      expect(p1.luckyNumber, p2.luckyNumber);
    });

    test('overall is the mean of the four scores', () {
      final p = gen.generateDailyPrediction(fixedDay, salt: 'x');
      final int expected =
          ((p.luck + p.energy + p.productivity + p.social) / 4).round();
      expect(p.overall, expected);
    });

    test('lucky number is within 1..99', () {
      for (int d = 1; d <= 28; d++) {
        final p = gen.generateDailyPrediction(DateTime(2026, 6, d), salt: 's');
        expect(p.luckyNumber, inInclusiveRange(1, 99));
      }
    });
  });
}
