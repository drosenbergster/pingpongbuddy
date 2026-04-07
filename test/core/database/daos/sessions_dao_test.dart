import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/core/database/app_database.dart';
import 'package:pingpongbuddy/core/database/daos/sessions_dao.dart';

AppDatabase _createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}

SessionsCompanion _testSession({
  required String id,
  DateTime? recordedAt,
  String? videoPath,
  int? duration,
  String? analysisStatus,
  String? tier,
  String? thumbnailPath,
}) {
  return SessionsCompanion.insert(
    id: id,
    recordedAt: recordedAt ?? DateTime.utc(2026, 4, 7),
    videoPath: Value.absentIfNull(videoPath),
    duration: Value.absentIfNull(duration),
    analysisStatus: analysisStatus != null
        ? Value(analysisStatus)
        : const Value.absent(),
    tier: tier != null ? Value(tier) : const Value.absent(),
    thumbnailPath: Value.absentIfNull(thumbnailPath),
  );
}

void main() {
  group('SessionsDao', () {
    late AppDatabase db;
    late SessionsDao dao;

    setUp(() {
      db = _createTestDatabase();
      dao = SessionsDao(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('insertSession', () {
      test('inserts a session and returns row count', () async {
        final result = await dao.insertSession(
          _testSession(id: 'session-1'),
        );
        expect(result, 1);
      });

      test('inserts session with all fields populated', () async {
        final now = DateTime.utc(2026, 4, 7, 10, 30);
        await dao.insertSession(
          _testSession(
            id: 'session-full',
            recordedAt: now,
            videoPath: '/videos/test.mp4',
            duration: 1800,
            analysisStatus: 'completed',
            tier: 'pro',
            thumbnailPath: '/thumbnails/test.jpg',
          ),
        );

        final session = await dao.getSession('session-full');
        expect(session.id, 'session-full');
        expect(session.videoPath, '/videos/test.mp4');
        expect(
          session.recordedAt.toUtc(),
          now,
          reason: 'Drift stores as UTC int; compare via .toUtc()',
        );
        expect(session.duration, 1800);
        expect(session.analysisStatus, 'completed');
        expect(session.tier, 'pro');
        expect(session.thumbnailPath, '/thumbnails/test.jpg');
      });
    });

    group('getSession', () {
      test('retrieves an existing session by id', () async {
        await dao.insertSession(_testSession(id: 'get-test'));

        final session = await dao.getSession('get-test');
        expect(session.id, 'get-test');
      });

      test('throws when session does not exist', () async {
        expect(
          () => dao.getSession('nonexistent'),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('updateSession', () {
      test('updates an existing session', () async {
        await dao.insertSession(
          _testSession(id: 'update-test'),
        );

        final updated = await dao.updateSession(
          SessionsCompanion(
            id: const Value('update-test'),
            recordedAt: Value(DateTime.utc(2026, 4, 7)),
            analysisStatus: const Value('completed'),
            duration: const Value(600),
          ),
        );

        expect(updated, isTrue);

        final session = await dao.getSession('update-test');
        expect(session.analysisStatus, 'completed');
        expect(session.duration, 600);
      });
    });

    group('deleteSession', () {
      test('deletes a session and returns affected row count', () async {
        await dao.insertSession(_testSession(id: 'delete-test'));

        final deleted = await dao.deleteSession('delete-test');
        expect(deleted, 1);

        expect(
          () => dao.getSession('delete-test'),
          throwsA(isA<StateError>()),
        );
      });

      test('returns 0 when deleting nonexistent session', () async {
        final deleted = await dao.deleteSession('nonexistent');
        expect(deleted, 0);
      });
    });

    group('watchAllSessions', () {
      test('emits empty list initially', () async {
        final stream = dao.watchAllSessions();
        await expectLater(stream, emits(isEmpty));
      });

      test('emits sessions ordered by recordedAt descending', () async {
        final older = DateTime.utc(2026, 4, 5);
        final newer = DateTime.utc(2026, 4, 7);

        await dao.insertSession(
          _testSession(id: 'older', recordedAt: older),
        );
        await dao.insertSession(
          _testSession(id: 'newer', recordedAt: newer),
        );

        final sessions = await dao.watchAllSessions().first;
        expect(sessions, hasLength(2));
        expect(sessions.first.id, 'newer');
        expect(sessions.last.id, 'older');
      });

      test('stream updates when data changes', () async {
        final stream = dao.watchAllSessions();

        final first = await stream.first;
        expect(first, isEmpty);

        await dao.insertSession(_testSession(id: 'stream-test'));

        final second = await stream.first;
        expect(second, hasLength(1));
        expect(second.first.id, 'stream-test');
      });
    });

    group('atomic writes', () {
      test('transaction rolls back on failure', () async {
        await dao.insertSession(_testSession(id: 'atomic-test'));

        try {
          await db.transaction(() async {
            await dao.insertSession(
              _testSession(id: 'should-rollback'),
            );
            throw Exception('Simulated failure');
          });
        } on Exception {
          // Expected
        }

        final sessions = await dao.watchAllSessions().first;
        expect(sessions, hasLength(1));
        expect(sessions.first.id, 'atomic-test');
      });
    });
  });
}
