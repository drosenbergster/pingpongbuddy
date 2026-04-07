import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/core/database/app_database.dart';

AppDatabase _createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}

void main() {
  group('AppDatabase', () {
    late AppDatabase db;

    setUp(() {
      db = _createTestDatabase();
    });

    tearDown(() async {
      await db.close();
    });

    test('creates sessions table on first open', () async {
      final result = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='sessions'",
      ).get();

      expect(result, hasLength(1));
      expect(result.first.data['name'], 'sessions');
    });

    test('sessions table has expected columns', () async {
      final result = await db.customSelect(
        'PRAGMA table_info(sessions)',
      ).get();

      final columnNames =
          result.map((row) => row.data['name'] as String).toSet();

      expect(
        columnNames,
        containsAll(<String>[
          'id',
          'video_path',
          'recorded_at',
          'duration',
          'analysis_status',
          'tier',
          'thumbnail_path',
        ]),
      );
    });

    test('id is the primary key', () async {
      final result = await db.customSelect(
        'PRAGMA table_info(sessions)',
      ).get();

      final idRow = result.firstWhere(
        (row) => row.data['name'] == 'id',
      );

      expect(idRow.data['pk'], 1);
    });

    test('analysis_status defaults to pending', () async {
      await db.into(db.sessions).insert(
            SessionsCompanion.insert(
              id: 'test-1',
              recordedAt: DateTime.utc(2026, 4, 7),
            ),
          );

      final session = await (db.select(db.sessions)
            ..where((t) => t.id.equals('test-1')))
          .getSingle();

      expect(session.analysisStatus, 'pending');
    });

    test('tier defaults to free', () async {
      await db.into(db.sessions).insert(
            SessionsCompanion.insert(
              id: 'test-1',
              recordedAt: DateTime.utc(2026, 4, 7),
            ),
          );

      final session = await (db.select(db.sessions)
            ..where((t) => t.id.equals('test-1')))
          .getSingle();

      expect(session.tier, 'free');
    });

    test('nullable columns accept null values', () async {
      await db.into(db.sessions).insert(
            SessionsCompanion.insert(
              id: 'test-1',
              recordedAt: DateTime.utc(2026, 4, 7),
            ),
          );

      final session = await (db.select(db.sessions)
            ..where((t) => t.id.equals('test-1')))
          .getSingle();

      expect(session.videoPath, isNull);
      expect(session.duration, isNull);
      expect(session.thumbnailPath, isNull);
    });

    test('foreign_keys pragma is enabled', () async {
      final result =
          await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(result.data['foreign_keys'], 1);
    });

    test('schemaVersion is 1', () {
      expect(db.schemaVersion, 1);
    });
  });
}
