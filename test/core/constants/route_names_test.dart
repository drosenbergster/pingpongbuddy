import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/core/constants/route_names.dart';

void main() {
  group('RouteNames', () {
    test('record is "record"', () {
      expect(RouteNames.record, 'record');
    });

    test('sessions is "sessions"', () {
      expect(RouteNames.sessions, 'sessions');
    });
  });
}
