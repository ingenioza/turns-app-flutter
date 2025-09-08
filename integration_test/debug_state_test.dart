import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:turns_flutter/core/injection/injection.dart';
import 'package:turns_flutter/firebase_options.dart';
import 'package:turns_flutter/presentation/app/app.dart';
import 'package:turns_flutter/presentation/bloc/participant/participant_bloc.dart';
import 'package:turns_flutter/presentation/bloc/participant/participant_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BLoC State Debug Tests', () {
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

    testWidgets('Monitor ParticipantBloc states during add participant', (tester) async {
      // Launch the app
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🚀 APP LAUNCHED - Monitoring BLoC states...');

      // Get the ParticipantBloc instance
      final context = tester.element(find.byType(Scaffold));
      final participantBloc = BlocProvider.of<ParticipantBloc>(context);

      // Listen to state changes
      participantBloc.stream.listen((state) {
        print('🔄 ParticipantBloc State Change: ${state.runtimeType}');
        if (state is ParticipantLoaded) {
          print('  📋 Participants count: ${state.participants.length}');
          for (final participant in state.participants) {
            print('    - ${participant.name} (ID: ${participant.id})');
          }
        } else if (state is ParticipantError) {
          print('  ❌ Error: ${state.message}');
        } else if (state is ParticipantOperationSuccess) {
          print('  ✅ Success: ${state.message}');
          print('  📋 Participants count: ${state.participants.length}');
        }
      });

      // Get initial state
      print('🔍 Initial state: ${participantBloc.state.runtimeType}');
      
      // Wait for app to fully load
      await tester.pump(const Duration(seconds: 2));
      print('🔍 State after loading: ${participantBloc.state.runtimeType}');
      
      if (participantBloc.state is ParticipantLoaded) {
        final state = participantBloc.state as ParticipantLoaded;
        print('📋 Initial participants: ${state.participants.length}');
      }

      // Find the FloatingActionButton to add participants
      final addButton = find.byType(FloatingActionButton);
      expect(addButton, findsOneWidget);
      print('✅ Found FloatingActionButton');

      // Tap the add button
      print('👆 Tapping add button...');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Check if dialog opened
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      print('✅ Dialog opened with TextField');

      // Enter participant name
      print('⌨️ Entering "TestUser"...');
      await tester.enterText(textField, 'TestUser');
      await tester.pump();

      // Find and tap the Add button in dialog
      final confirmButton = find.text('Add');
      expect(confirmButton, findsOneWidget);
      print('👆 Tapping Add button in dialog...');
      await tester.tap(confirmButton);

      // Wait for all async operations to complete
      print('⏱️ Waiting for state updates...');
      await tester.pump(); // Initial pump
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Check final state
      print('🔍 Final state: ${participantBloc.state.runtimeType}');
      
      if (participantBloc.state is ParticipantLoaded) {
        final state = participantBloc.state as ParticipantLoaded;
        print('📋 Final participants: ${state.participants.length}');
        for (final participant in state.participants) {
          print('  - ${participant.name} (ID: ${participant.id})');
        }
      } else if (participantBloc.state is ParticipantError) {
        final state = participantBloc.state as ParticipantError;
        print('❌ Final error: ${state.message}');
      }

      // Try to find TestUser in the UI
      final testUserText = find.text('TestUser');
      print('🔍 Looking for "TestUser" in UI: ${testUserText.evaluate().isNotEmpty ? "FOUND" : "NOT FOUND"}');

      // Print all text widgets for debugging
      print('🔍 All text widgets in UI:');
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
