import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/storage_keys.dart';

/// Thin, typed wrapper around Hive. Complex models are stored as JSON strings
/// to avoid hand-written TypeAdapters (keeps the schema flexible and the build
/// free of code-generation steps).
class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  late Box<dynamic> _settings;
  late Box<dynamic> _user;
  late Box<dynamic> _gamification;
  late Box<dynamic> _results;
  late Box<dynamic> _predictions;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _settings = await Hive.openBox<dynamic>(StorageKeys.settingsBox);
    _user = await Hive.openBox<dynamic>(StorageKeys.userBox);
    _gamification = await Hive.openBox<dynamic>(StorageKeys.gamificationBox);
    _results = await Hive.openBox<dynamic>(StorageKeys.resultsBox);
    _predictions = await Hive.openBox<dynamic>(StorageKeys.predictionsBox);
    _initialized = true;
  }

  Box<dynamic> _box(String name) {
    switch (name) {
      case StorageKeys.settingsBox:
        return _settings;
      case StorageKeys.userBox:
        return _user;
      case StorageKeys.gamificationBox:
        return _gamification;
      case StorageKeys.resultsBox:
        return _results;
      case StorageKeys.predictionsBox:
        return _predictions;
      default:
        throw ArgumentError('Unknown box: $name');
    }
  }

  // ---- Primitives -----------------------------------------------------------

  T? read<T>(String box, String key, {T? defaultValue}) {
    final dynamic v = _box(box).get(key, defaultValue: defaultValue);
    return v as T?;
  }

  Future<void> write(String box, String key, dynamic value) =>
      _box(box).put(key, value);

  Future<void> delete(String box, String key) => _box(box).delete(key);

  // ---- JSON helpers ---------------------------------------------------------

  Map<String, dynamic>? readJson(String box, String key) {
    final String? raw = _box(box).get(key) as String?;
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> writeJson(
          String box, String key, Map<String, dynamic> value) =>
      _box(box).put(key, jsonEncode(value));

  /// Append a JSON object to a capped, most-recent-first list stored under
  /// [key]. Used for the result history feed.
  Future<void> pushJsonList(
    String box,
    String key,
    Map<String, dynamic> value, {
    int maxItems = 100,
  }) async {
    final List<String> list = readStringList(box, key);
    list.insert(0, jsonEncode(value));
    if (list.length > maxItems) list.removeRange(maxItems, list.length);
    await _box(box).put(key, list);
  }

  List<Map<String, dynamic>> readJsonList(String box, String key) {
    return readStringList(box, key)
        .map((String s) => Map<String, dynamic>.from(jsonDecode(s) as Map))
        .toList();
  }

  List<String> readStringList(String box, String key) {
    final dynamic raw = _box(box).get(key);
    if (raw == null) return <String>[];
    return (raw as List<dynamic>).cast<String>();
  }

  Future<void> clearAll() async {
    await _settings.clear();
    await _user.clear();
    await _gamification.clear();
    await _results.clear();
    await _predictions.clear();
  }
}
