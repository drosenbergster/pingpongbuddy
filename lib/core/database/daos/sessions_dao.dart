import 'package:drift/drift.dart';
import 'package:pingpongbuddy/core/database/app_database.dart';
import 'package:pingpongbuddy/core/database/tables/sessions.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.attachedDatabase);

  Stream<List<Session>> watchAllSessions() {
    return (select(sessions)
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .watch();
  }

  Future<Session> getSession(String id) {
    return (select(sessions)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insertSession(SessionsCompanion entry) {
    return into(sessions).insert(entry);
  }

  Future<bool> updateSession(SessionsCompanion entry) {
    return update(sessions).replace(entry);
  }

  Future<int> deleteSession(String id) {
    return (delete(sessions)..where((t) => t.id.equals(id))).go();
  }
}
