import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/injection/injection.dart';
import 'presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (gracefully handle missing config in dev)
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    // Allow app to boot without Firebase when GoogleService-Info.plist is missing.
    debugPrint('[Firebase] Initialization skipped: $e');
    debugPrint('$st');
  }
  
  // Configure dependency injection
  await configureDependencies();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const TurnsApp());
}
