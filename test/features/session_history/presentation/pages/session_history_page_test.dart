import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/app/app.dart';

void main() {
  group('SessionHistoryPage', () {
    Future<void> navigateToSessionHistory(WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
    }

    testWidgets('has Sessions title in app bar', (tester) async {
      await navigateToSessionHistory(tester);
      expect(find.text('Sessions'), findsOneWidget);
    });

    testWidgets('displays no sessions placeholder text', (tester) async {
      await navigateToSessionHistory(tester);
      expect(find.text('No sessions yet'), findsOneWidget);
    });

    testWidgets('has record FAB with videocam icon', (tester) async {
      await navigateToSessionHistory(tester);

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.videocam), findsOneWidget);
    });
  });
}
