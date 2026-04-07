import 'package:flutter/material.dart';
import 'package:pingpongbuddy/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      home: const Scaffold(
        body: Center(
          child: Text('PingPongBuddy'),
        ),
      ),
    );
  }
}
