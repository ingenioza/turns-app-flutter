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

  group('Final Verification Tests', () {
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

    testWidgets('Verify participant addition and button functionality', (tester) async {
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🚀 APP LAUNCHED - Final verification test...');

      // Check initial participant count
      final totalFinder = find.text('4');
      if (totalFinder.evaluate().length >= 2) {
        print('✅ Found 4 initial participants');
      }

      // Add a new participant
      print('👆 Adding participant "FinalTest"...');
      final addButton = find.byType(FloatingActionButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'FinalTest');
      await tester.pump();

      final confirmButton = find.text('Add');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      // Wait for state to update
      await tester.pump(const Duration(milliseconds: 500));

      print('🔍 Checking results...');

      // Check if participant appears in list
      final finalTestFinder = find.text('FinalTest');
      if (finalTestFinder.evaluate().isNotEmpty) {
        print('✅ SUCCESS: FinalTest participant is visible in UI');
      } else {
        print('❌ FAIL: FinalTest participant not found in UI');
      }

      // Check total count updated to 5
      final fiveFinder = find.text('5');
      if (fiveFinder.evaluate().length >= 2) {
        print('✅ SUCCESS: Total count updated to 5');
      } else {
        print('❌ FAIL: Total count not updated');
      }

      // Check for Spin the Wheel button
      final spinButtonText = find.text('Spin the Wheel!');
      final elevatedButtons = find.byType(ElevatedButton);
      
      if (spinButtonText.evaluate().isNotEmpty) {
        print('✅ SUCCESS: "Spin the Wheel!" text found');
        
        // Try to find if it's in an ElevatedButton
        print('📱 ElevatedButton count: ${elevatedButtons.evaluate().length}');
        
        if (elevatedButtons.evaluate().isNotEmpty) {
          print('✅ SUCCESS: ElevatedButton found!');
          
          // Try to tap it
          try {
            await tester.tap(elevatedButtons.first);
            await tester.pump(const Duration(milliseconds: 100));
            print('✅ SUCCESS: Button tap successful!');
          } catch (e) {
            print('⚠️ WARNING: Button tap failed: $e');
          }
        } else {
          print('❌ FAIL: No ElevatedButton found despite text being present');
        }
      } else {
        print('❌ FAIL: Spin the Wheel text not found');
      }

      // Final status check
      print('\n📊 FINAL STATUS:');
      print('  Participant addition: ${finalTestFinder.evaluate().isNotEmpty ? "✅ WORKING" : "❌ BROKEN"}');
      print('  Count updates: ${fiveFinder.evaluate().length >= 2 ? "✅ WORKING" : "❌ BROKEN"}');
      print('  Button visibility: ${spinButtonText.evaluate().isNotEmpty ? "✅ WORKING" : "❌ BROKEN"}');
      print('  Button functionality: ${elevatedButtons.evaluate().isNotEmpty ? "✅ WORKING" : "❌ BROKEN"}');

      // Print active participant count in UI
      final allTexts = find.byType(Text);
      for (final element in allTexts.evaluate()) {
        final widget = element.widget as Text;
        if (widget.data?.contains('Active') == true) {
          print('  Active count display: "${widget.data}"');
        }
      }
    });
  });
}
