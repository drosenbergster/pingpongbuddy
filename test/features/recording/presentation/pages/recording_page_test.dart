import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/app/app.dart';

void main() {
  group('RecordingPage', () {
    testWidgets('has black background', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, Colors.black);
    });

    testWidgets('has history icon button in app bar', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byIcon(Icons.history),
          matching: find.byType(AppBar),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays Recording placeholder text', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Recording'), findsOneWidget);
    });
  });
}
