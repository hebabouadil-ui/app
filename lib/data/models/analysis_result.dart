import 'analysis_type.dart';

/// A single sub-score within a result (e.g. "Charisma 82").
class ResultMetric {
  const ResultMetric({
    required this.label,
    required this.value,
    this.note,
  });

  final String label;
  final int value; // 0-100
  final String? note;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'label': label,
        'value': value,
        'note': note,
      };

  factory ResultMetric.fromJson(Map<String, dynamic> json) => ResultMetric(
        label: json['label'] as String,
        value: (json['value'] as num).toInt(),
        note: json['note'] as String?,
      );
}

/// The generated, entertainment-only outcome of an experience.
class AnalysisResult {
  const AnalysisResult({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.primaryScore,
    required this.title,
    required this.summary,
    required this.metrics,
    required this.traits,
    required this.gradientName,
    required this.emoji,
    this.subtitle,
    this.extra,
  });

  final String id;
  final AnalysisType type;
  final DateTime createdAt;

  /// Headline 0-100 score (e.g. Aura Score).
  final int primaryScore;

  /// Short headline, e.g. "Radiant Violet Aura".
  final String title;
  final String? subtitle;

  /// One-paragraph fun description.
  final String summary;

  /// Sub-scores shown as bars/gauges.
  final List<ResultMetric> metrics;

  /// Trait chips, e.g. ["Curious", "Warm", "Bold"].
  final List<String> traits;

  final String gradientName;
  final String emoji;

  /// Free-form extras (e.g. celebrity name, lucky color).
  final Map<String, String>? extra;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type.id,
        'createdAt': createdAt.toIso8601String(),
        'primaryScore': primaryScore,
        'title': title,
        'subtitle': subtitle,
        'summary': summary,
        'metrics': metrics.map((ResultMetric m) => m.toJson()).toList(),
        'traits': traits,
        'gradientName': gradientName,
        'emoji': emoji,
        'extra': extra,
      };

  factory AnalysisResult.fromJson(Map<String, dynamic> json) => AnalysisResult(
        id: json['id'] as String,
        type: AnalysisType.fromId(json['type'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        primaryScore: (json['primaryScore'] as num).toInt(),
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        summary: json['summary'] as String,
        metrics: (json['metrics'] as List<dynamic>)
            .map((dynamic e) =>
                ResultMetric.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        traits: (json['traits'] as List<dynamic>).cast<String>(),
        gradientName: json['gradientName'] as String,
        emoji: json['emoji'] as String,
        extra: (json['extra'] as Map?)?.cast<String, String>(),
      );
}
