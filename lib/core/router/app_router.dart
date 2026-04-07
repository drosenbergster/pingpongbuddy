import 'package:go_router/go_router.dart';
import 'package:pingpongbuddy/core/constants/route_names.dart';
import 'package:pingpongbuddy/features/recording/presentation/pages/recording_page.dart';
import 'package:pingpongbuddy/features/session_history/presentation/pages/session_history_page.dart';

GoRouter createAppRouter() => GoRouter(
      initialLocation: '/record',
      routes: [
        GoRoute(
          path: '/record',
          name: RouteNames.record,
          builder: (context, state) => const RecordingPage(),
        ),
        GoRoute(
          path: '/sessions',
          name: RouteNames.sessions,
          builder: (context, state) => const SessionHistoryPage(),
        ),
      ],
    );
