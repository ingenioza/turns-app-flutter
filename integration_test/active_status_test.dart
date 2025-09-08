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

  group('Participant Active Status Tests', () {
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

    testWidgets('Check participant isActive status', (tester) async {
      await tester.pumpWidget(const TurnsApp());
      await tester.pumpAndSettle();

      print('🚀 APP LAUNCHED - Checking participant active status...');

      final context = tester.element(find.byType(Scaffold));
      final participantBloc = BlocProvider.of<ParticipantBloc>(context);

      // Check initial participants
      if (participantBloc.state is ParticipantOperationSuccess) {
        final state = participantBloc.state as ParticipantOperationSuccess;
        print('📋 Initial participants (${state.participants.length}):');
        for (final participant in state.participants) {
          print('  - ${participant.name}: isActive=${participant.isActive}, turnCount=${participant.turnCount}');
        }
        
        final activeCount = state.participants.where((p) => p.isActive).length;
        print('✅ Active participants: $activeCount');
        print('🔄 Total participants: ${state.participants.length}');
      }

      // Add a new participant
      print('\n👆 Adding new participant...');
      final addButton = find.byType(FloatingActionButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'ActiveTest');
      await tester.pump();

      final confirmButton = find.text('Add');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      // Check participants after adding
      if (participantBloc.state is ParticipantOperationSuccess) {
        final state = participantBloc.state as ParticipantOperationSuccess;
        print('\n📋 Participants after adding (${state.participants.length}):');
        for (final participant in state.participants) {
          print('  - ${participant.name}: isActive=${participant.isActive}, turnCount=${participant.turnCount}');
        }
        
        final activeCount = state.participants.where((p) => p.isActive).length;
        print('✅ Active participants: $activeCount');
        print('🔄 Total participants: ${state.participants.length}');
        
        // Check if button should be enabled
        final shouldBeEnabled = activeCount > 0;
        print('🎯 Button should be enabled: $shouldBeEnabled');
      }

      // Test the actual button widget
      print('\n🔍 Checking button widget...');
      final buttonFinder = find.descendant(
        of: find.byType(ElevatedButton),
        matching: find.text('Spin the Wheel!'),
      );
      
      if (buttonFinder.evaluate().isNotEmpty) {
        final elevatedButtonFinder = find.ancestor(
          of: buttonFinder,
          matching: find.byType(ElevatedButton),
        );
        
        if (elevatedButtonFinder.evaluate().isNotEmpty) {
          final button = tester.widget<ElevatedButton>(elevatedButtonFinder);
          final isEnabled = button.onPressed != null;
          print('🔘 Spin button enabled: $isEnabled');
          
          if (isEnabled) {
            print('✅ Button is enabled - testing tap...');
            await tester.tap(elevatedButtonFinder);
            await tester.pump(const Duration(milliseconds: 200));
            print('✅ Button tap successful!');
          } else {
            print('❌ Button is disabled');
          }
        }
      } else {
        print('❌ Could not find Spin the Wheel button');
      }
    });
  });
}
