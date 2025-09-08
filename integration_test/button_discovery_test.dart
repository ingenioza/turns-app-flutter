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

  group('Button Discovery Tests', () {
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

    testWidgets('Find all buttons and text', (tester) async {
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🚀 APP LAUNCHED - Discovering all buttons...');

      // Find all ElevatedButtons
      final elevatedButtons = find.byType(ElevatedButton);
      print('📱 ElevatedButton count: ${elevatedButtons.evaluate().length}');
      
      for (int i = 0; i < elevatedButtons.evaluate().length; i++) {
        final button = tester.widget<ElevatedButton>(elevatedButtons.at(i));
        final isEnabled = button.onPressed != null;
        print('  Button $i: enabled=$isEnabled');
        
        // Try to find any child text
        final buttonElement = elevatedButtons.evaluate().elementAt(i);
        final textWidgets = find.descendant(
          of: find.byWidget(buttonElement.widget),
          matching: find.byType(Text),
        );
        
        for (final textElement in textWidgets.evaluate()) {
          final textWidget = textElement.widget as Text;
          print('    Text: "${textWidget.data}"');
        }
      }

      // Find all text widgets
      print('\n📝 All Text widgets:');
      final allTexts = find.byType(Text);
      for (final element in allTexts.evaluate()) {
        final widget = element.widget as Text;
        if (widget.data != null && widget.data!.trim().isNotEmpty) {
          print('  Text: "${widget.data}"');
        }
      }

      // Try different search methods for Spin button
      print('\n🔍 Searching for Spin button:');
      
      final spinText = find.text('Spin the Wheel!');
      print('  find.text("Spin the Wheel!"): ${spinText.evaluate().length}');
      
      final spinContaining = find.textContaining('Spin');
      print('  find.textContaining("Spin"): ${spinContaining.evaluate().length}');
      
      final playIcon = find.byIcon(Icons.play_arrow);
      print('  find.byIcon(Icons.play_arrow): ${playIcon.evaluate().length}');

      // If we found the spin text, check its button parent
      if (spinText.evaluate().isNotEmpty) {
        print('\n✅ Found "Spin the Wheel!" text - checking parent button...');
        
        try {
          final buttonParent = find.ancestor(
            of: spinText,
            matching: find.byType(ElevatedButton),
          );
          
          if (buttonParent.evaluate().isNotEmpty) {
            final button = tester.widget<ElevatedButton>(buttonParent);
            final isEnabled = button.onPressed != null;
            print('  Parent ElevatedButton enabled: $isEnabled');
            
            if (isEnabled) {
              print('  🎯 Testing button tap...');
              await tester.tap(buttonParent);
              await tester.pump(const Duration(milliseconds: 100));
              print('  ✅ Button tap successful!');
            }
          } else {
            print('  ❌ No ElevatedButton parent found');
          }
        } catch (e) {
          print('  ❌ Error finding button parent: $e');
        }
      }

      // Check if there are any widgets taking up space
      print('\n📐 Widget hierarchy around buttons:');
      final scaffold = find.byType(Scaffold);
      if (scaffold.evaluate().isNotEmpty) {
        print('  ✅ Scaffold found');
        
        final body = find.descendant(
          of: scaffold,
          matching: find.byType(Column),
        );
        print('  Column widgets: ${body.evaluate().length}');
      }
    });
  });
}
