import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world_ios/main.dart';

void main() {
  testWidgets('calculator page renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CalculatorPage()));
    expect(find.text('Reward Calculator'), findsOneWidget);
    expect(find.textContaining('Average:'), findsOneWidget);
  });
}
