import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Just verify that basic Flutter functionality works
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Test App'),
          ),
        ),
      ),
    );

    expect(find.text('Test App'), findsOneWidget);
  });
}
