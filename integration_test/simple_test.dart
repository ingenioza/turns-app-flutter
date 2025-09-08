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

  group('Turns App E2E Tests', () {
    setUpAll(() async {
      // Initialize Firebase and dependencies like in main.dart
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await configureDependencies();
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });

    testWidgets('Core Turn-Taking Functionality Debug', (WidgetTester tester) async {
      // Launch the app
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🎯 APP LAUNCHED - Analyzing UI elements...');

      // Debug: Print all widgets in the current tree
      print('📋 WIDGET TREE ANALYSIS:');
      final allWidgets = find.byType(Widget);
      print('Total widgets found: ${allWidgets.evaluate().length}');

      // Look for common button types
      print('🔍 SEARCHING FOR BUTTONS:');
      
      // FloatingActionButton
      final fabs = find.byType(FloatingActionButton);
      print('FloatingActionButton count: ${fabs.evaluate().length}');

      // ElevatedButton
      final elevatedButtons = find.byType(ElevatedButton);
      print('ElevatedButton count: ${elevatedButtons.evaluate().length}');
      for (final buttonElement in elevatedButtons.evaluate()) {
        final widget = buttonElement.widget as ElevatedButton;
        print('  - ElevatedButton: ${widget.onPressed != null ? "ENABLED" : "DISABLED"}');
        if (widget.child is Text) {
          final text = (widget.child as Text).data;
          print('    Text: "$text"');
        }
      }

      // IconButton
      final iconButtons = find.byType(IconButton);
      print('IconButton count: ${iconButtons.evaluate().length}');

      // TextButton
      final textButtons = find.byType(TextButton);
      print('TextButton count: ${textButtons.evaluate().length}');

      print('🔍 SEARCHING FOR TEXT CONTENT:');
      final commonTexts = [
        'Add Participant',
        'Spin the Wheel!',
        'Participants',
        'Add',
        'Spin',
      ];

      for (final text in commonTexts) {
        final finder = find.text(text);
        print('Text "$text": ${finder.evaluate().isNotEmpty ? "FOUND" : "NOT FOUND"}');
      }

      print('🔍 SEARCHING FOR ICONS:');
      final commonIcons = [
        Icons.add,
        Icons.play_arrow,
        Icons.group,
      ];

      for (final icon in commonIcons) {
        final finder = find.byIcon(icon);
        print('Icon $icon: ${finder.evaluate().isNotEmpty ? "FOUND" : "NOT FOUND"}');
      }

      // Look for TextField widgets
      print('🔍 SEARCHING FOR INPUT FIELDS:');
      final textFields = find.byType(TextField);
      print('TextField count: ${textFields.evaluate().length}');

      final textFormFields = find.byType(TextFormField);
      print('TextFormField count: ${textFormFields.evaluate().length}');

      // Test if we can find and tap an add button
      print('🧪 TESTING ADD PARTICIPANT FUNCTIONALITY:');
      
      // Try to find add button by different methods
      Finder? addButton;
      
      // Method 1: FloatingActionButton
      if (fabs.evaluate().isNotEmpty) {
        addButton = fabs.first;
        print('✅ Found FloatingActionButton for adding participants');
      }
      
      // Method 2: Text-based search
      if (addButton == null) {
        final textAdd = find.text('Add');
        if (textAdd.evaluate().isNotEmpty) {
          addButton = textAdd.first;
          print('✅ Found "Add" text button');
        }
      }

      // Method 3: Icon-based search
      if (addButton == null) {
        final iconAdd = find.byIcon(Icons.add);
        if (iconAdd.evaluate().isNotEmpty) {
          addButton = iconAdd.first;
          print('✅ Found add icon button');
        }
      }

      if (addButton != null) {
        print('🧪 ATTEMPTING TO ADD PARTICIPANT:');
        try {
          await tester.tap(addButton);
          await tester.pumpAndSettle();
          print('✅ Successfully tapped add button');

          // Look for input field after tapping add
          await tester.pump(const Duration(seconds: 1));
          final textField = find.byType(TextField);
          final textFormField = find.byType(TextFormField);
          
          Finder? inputField;
          if (textField.evaluate().isNotEmpty) {
            inputField = textField;
          } else if (textFormField.evaluate().isNotEmpty) {
            inputField = textFormField;
          }
          
          if (inputField != null) {
            print('✅ Input field appeared after tapping add');
            await tester.enterText(inputField, 'Alice');
            await tester.pumpAndSettle();
            print('✅ Entered text: Alice');

            // Look for confirm button
            final confirmButtons = [
              find.text('Save'),
              find.text('Add'),
              find.text('OK'),
              find.text('Confirm'),
            ];

            for (final confirmFinder in confirmButtons) {
              if (confirmFinder.evaluate().isNotEmpty) {
                await tester.tap(confirmFinder);
                await tester.pumpAndSettle();
                print('✅ Tapped confirm button');
                break;
              }
            }

            // Check if participant was added
            final aliceText = find.text('Alice');
            if (aliceText.evaluate().isNotEmpty) {
              print('✅ SUCCESS: Alice appears in participant list');
            } else {
              print('❌ ISSUE: Alice not found in participant list');
            }

          } else {
            print('❌ No input field appeared after tapping add button');
          }

        } catch (e) {
          print('❌ Error tapping add button: $e');
        }
      } else {
        print('❌ CRITICAL: No add button found');
      }

      // Test spin button functionality
      print('🧪 TESTING SPIN BUTTON FUNCTIONALITY:');
      
      final spinFinders = [
        find.text('Spin the Wheel!'),
        find.text('Spin'),
        find.byIcon(Icons.play_arrow),
      ];

      Finder? spinButton;
      for (final finder in spinFinders) {
        if (finder.evaluate().isNotEmpty) {
          spinButton = finder;
          print('✅ Found spin button: ${finder.description}');
          break;
        }
      }

      if (spinButton != null) {
        // Check if the button is enabled
        final buttonWidget = tester.widget(spinButton) as ElevatedButton;
        if (buttonWidget.onPressed != null) {
          print('✅ Spin button is ENABLED');
          try {
            await tester.tap(spinButton);
            await tester.pumpAndSettle();
            print('✅ Successfully executed spin');
          } catch (e) {
            print('❌ Error executing spin: $e');
          }
        } else {
          print('❌ CRITICAL ISSUE: Spin button is DISABLED');
          print('   This means participants are not being recognized as active');
        }
      } else {
        print('❌ CRITICAL: No spin button found');
      }

      print('🎉 DIAGNOSTIC COMPLETED');
    });

    testWidgets('Simple Participant Addition Test', (WidgetTester tester) async {
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🧪 SIMPLE TEST: Adding participants and checking state...');

      // Find any button that could be used to add participants
      final allButtons = [
        find.byType(FloatingActionButton),
        find.byType(ElevatedButton),
        find.byType(TextButton),
        find.byType(IconButton),
      ];

      for (final buttonFinder in allButtons) {
        if (buttonFinder.evaluate().isNotEmpty) {
          print('Found ${buttonFinder.runtimeType}: ${buttonFinder.evaluate().length} instances');
        }
      }

      // Try the most likely add participant flow
      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab.first);
        await tester.pumpAndSettle();
        
        // After tapping, check what appeared
        final textFields = find.byType(TextField);
        if (textFields.evaluate().isNotEmpty) {
          print('✅ Text field appeared - participant addition UI working');
        } else {
          print('❌ No text field appeared after FAB tap');
        }
      }

      print('✅ Simple test completed');
    });
  });
}
