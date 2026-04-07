import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pingpongbuddy/core/constants/route_names.dart';

class SessionHistoryPage extends StatelessWidget {
  const SessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: const Center(
        child: Text('No sessions yet'),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Record session',
        onPressed: () => context.goNamed(RouteNames.record),
        child: const Icon(Icons.videocam),
      ),
    );
  }
}
