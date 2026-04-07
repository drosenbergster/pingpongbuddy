import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpongbuddy/core/router/app_router.dart';
import 'package:pingpongbuddy/core/theme/app_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme(),
      routerConfig: _router,
    );
  }
}
