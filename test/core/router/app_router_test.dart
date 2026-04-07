import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/app/app.dart';

void main() {
  group('appRouter', () {
    testWidgets('initial route shows recording page', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Recording'), findsOneWidget);
    });

    testWidgets(
      'navigating to sessions shows session history page',
      (tester) async {
        await tester.pumpWidget(const App());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.history));
        await tester.pumpAndSettle();

        expect(find.text('Sessions'), findsOneWidget);
        expect(find.text('No sessions yet'), findsOneWidget);
      },
    );

    testWidgets(
      'navigating from sessions back to record via FAB',
      (tester) async {
        await tester.pumpWidget(const App());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.history));
        await tester.pumpAndSettle();

        expect(find.text('Sessions'), findsOneWidget);

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Recording'), findsOneWidget);
      },
    );
  });
}
