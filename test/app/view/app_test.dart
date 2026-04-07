// VGV test convention: allow non-const widget constructors in tests.
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders with router and shows recording page', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      expect(find.text('Recording'), findsOneWidget);
    });

    testWidgets('uses MaterialApp.router', (tester) async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
