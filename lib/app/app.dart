import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import 'splash_screen.dart';

class NomadPuzzleApp extends StatefulWidget {
  const NomadPuzzleApp({super.key});

  @override
  State<NomadPuzzleApp> createState() => _NomadPuzzleAppState();
}

class _NomadPuzzleAppState extends State<NomadPuzzleApp> {
  bool _splashDone = false;
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(const AuthBootstrapRequested());
    _router = AppRouter.create(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Nomad Puzzle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
        builder: (context, child) {
          return Stack(
            children: [
              ?child,
              if (!_splashDone)
                SplashScreen(
                  onDone: () => setState(() => _splashDone = true),
                ),
            ],
          );
        },
      ),
    );
  }
}
