// VGV test convention: allow non-const widget constructors in tests.
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders PingPongBuddy text', (tester) async {
      await tester.pumpWidget(App());
      expect(find.text('PingPongBuddy'), findsOneWidget);
    });
  });
}
