import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/daily_prediction.dart';
import 'service_providers.dart';
import 'user_provider.dart';

/// Today's deterministic prediction. Salted with the user id so two people get
/// different (but personally stable) daily fortunes — better for sharing.
final todayPredictionProvider = Provider<DailyPrediction>((Ref ref) {
  final generator = ref.watch(resultGeneratorProvider);
  final String salt = ref.watch(userProvider).id;
  return generator.generateDailyPrediction(DateTime.now(), salt: salt);
});

/// A short upcoming forecast (next 5 days) for the predictions screen.
final upcomingPredictionsProvider =
    Provider<List<DailyPrediction>>((Ref ref) {
  final generator = ref.watch(resultGeneratorProvider);
  final String salt = ref.watch(userProvider).id;
  final DateTime today = DateTime.now();
  return List<DailyPrediction>.generate(5, (int i) {
    return generator.generateDailyPrediction(
      today.add(Duration(days: i)),
      salt: salt,
    );
  });
});
