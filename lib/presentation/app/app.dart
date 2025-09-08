import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/injection/injection.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/participant/participant_bloc.dart';
import '../bloc/turn/turn_bloc.dart';
import '../routes/app_router.dart';

class TurnsApp extends StatelessWidget {
  const TurnsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ParticipantBloc>(
          create: (context) => getIt<ParticipantBloc>(),
        ),
        BlocProvider<TurnBloc>(
          create: (context) => getIt<TurnBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Turns',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
