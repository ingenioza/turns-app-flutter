import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:turns_flutter/core/injection/injection.dart';
import 'package:turns_flutter/firebase_options.dart';
import 'package:turns_flutter/presentation/app/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Button Enablement Tests', () {
    setUpAll(() async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await configureDependencies();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });

    testWidgets('Test Spin the Wheel button enablement', (tester) async {
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🚀 APP LAUNCHED - Testing button enablement...');

      // Check initial state of Spin the Wheel button
      final spinButtonFinder = find.text('Spin the Wheel!');
      expect(spinButtonFinder, findsOneWidget);
      
      // Get the button widget to check if it's enabled
      final spinButton = tester.widget<ElevatedButton>(
        find.ancestor(
          of: spinButtonFinder,
          matching: find.byType(ElevatedButton),
        ),
      );
      
      print('🔍 Initial button state: enabled = ${spinButton.onPressed != null}');

      // Add a participant
      print('👆 Adding a participant...');
      final addButton = find.byType(FloatingActionButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Enter participant name
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'ButtonTest');
      await tester.pump();

      // Confirm addition
      final confirmButton = find.text('Add');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      
      print('✅ Participant added, checking button state...');

      // Wait for state to update
      await tester.pump(const Duration(milliseconds: 500));

      // Check button state after adding participant
      final spinButtonAfter = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Spin the Wheel!'),
          matching: find.byType(ElevatedButton),
        ),
      );
      
      print('🔍 Button state after adding participant: enabled = ${spinButtonAfter.onPressed != null}');

      // Test if we can actually tap the button
      if (spinButtonAfter.onPressed != null) {
        print('✅ Button is enabled - testing tap...');
        await tester.tap(find.text('Spin the Wheel!'));
        await tester.pumpAndSettle();
        print('✅ Successfully tapped Spin the Wheel button!');
      } else {
        print('❌ Button is still disabled after adding participant');
      }

      // Check for any result from spinning
      final resultTexts = [
        'Selected',
        'Winner',
        'Turn for',
        'ButtonTest',
      ];
      
      for (final text in resultTexts) {
        final finder = find.textContaining(text);
        if (finder.evaluate().isNotEmpty) {
          print('🎯 Found result indicator: "$text"');
        }
      }

      print('🔍 Final UI state:');
      final allTexts = find.byType(Text);
      for (final element in allTexts.evaluate()) {
        final widget = element.widget as Text;
        if (widget.data != null && widget.data!.trim().isNotEmpty) {
          print('  Text: "${widget.data}"');
        }
      }
    });
  });
}
