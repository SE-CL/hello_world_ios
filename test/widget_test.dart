import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world_ios/main.dart';

void main() {
  testWidgets('显示 Hello World 页面', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('我的第一个应用'), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
    expect(find.text('应用特点'), findsOneWidget);

    await tester.tap(find.text('开始探索'));
    await tester.pump();
    expect(find.text('已准备好'), findsOneWidget);
  });
}
