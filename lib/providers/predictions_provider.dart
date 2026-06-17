import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/daily_prediction.dart';
import 'service_providers.dart';
import 'settings_provider.dart';
import 'user_provider.dart';

/// Active language for predictions (chosen locale → device → en). Watched so
/// the predictions regenerate when the user switches language.
String _lang(Ref ref) {
  final Locale? chosen =
      ref.watch(settingsProvider.select((SettingsState s) => s.locale));
  return chosen?.languageCode ??
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
}

/// Today's deterministic prediction, localized and salted with the user id.
final todayPredictionProvider = Provider<DailyPrediction>((Ref ref) {
  final generator = ref.watch(resultGeneratorProvider);
  final String salt = ref.watch(userProvider).id;
  return generator.generateDailyPrediction(DateTime.now(),
      salt: salt, lang: _lang(ref));
});

/// A short upcoming forecast (next 5 days) for the predictions screen.
final upcomingPredictionsProvider =
    Provider<List<DailyPrediction>>((Ref ref) {
  final generator = ref.watch(resultGeneratorProvider);
  final String salt = ref.watch(userProvider).id;
  final String lang = _lang(ref);
  final DateTime today = DateTime.now();
  return List<DailyPrediction>.generate(5, (int i) {
    return generator.generateDailyPrediction(
      today.add(Duration(days: i)),
      salt: salt,
      lang: lang,
    );
  });
});
