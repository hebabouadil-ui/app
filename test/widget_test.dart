import 'package:dream_ai/shared/widgets/disclaimer_banner.dart';
import 'package:dream_ai/shared/widgets/metric_bar.dart';
import 'package:dream_ai/shared/widgets/score_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('DisclaimerBanner shows the entertainment disclaimer',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(const DisclaimerBanner()));
    expect(find.textContaining('entertainment purposes'), findsOneWidget);
  });

  testWidgets('MetricBar renders its label and value',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(const MetricBar(label: 'Charisma', value: 82)));
    expect(find.text('Charisma'), findsOneWidget);
    expect(find.text('82'), findsOneWidget);
  });

  testWidgets('ScoreRing animates toward and displays its score',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(const ScoreRing(score: 73, label: 'Aura')));
    await tester.pumpAndSettle();
    expect(find.text('73'), findsOneWidget);
    expect(find.text('Aura'), findsOneWidget);
  });
}
