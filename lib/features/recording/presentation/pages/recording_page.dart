import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpongbuddy/core/constants/route_names.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Session history',
            onPressed: () => context.goNamed(RouteNames.sessions),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Recording',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
