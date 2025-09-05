import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../routes/app_router.dart';

class TurnsApp extends StatelessWidget {
  const TurnsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Turns',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
