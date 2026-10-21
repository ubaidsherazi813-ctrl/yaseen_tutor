import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Yaseen Tutor'),
        ),
      ),
    );

    expect(find.text('Yaseen Tutor'), findsOneWidget);
  });
}
