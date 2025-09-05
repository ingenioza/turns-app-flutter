import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:turns_flutter/presentation/pages/home/home_page.dart';

void main() {
  testWidgets('HomePage displays correctly', (WidgetTester tester) async {
    // Build the HomePage widget directly
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Verify that the home page loads correctly
    expect(find.text('Welcome to Turns!'), findsOneWidget);
    expect(find.text('Your turn-taking app is ready.'), findsOneWidget);
    expect(find.text('Foundation setup completed! 🎉'), findsOneWidget);
    expect(find.byIcon(Icons.group), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
