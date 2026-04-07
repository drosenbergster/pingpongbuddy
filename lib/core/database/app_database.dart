import 'package:drift/drift.dart';
import 'package:pingpongbuddy/core/database/daos/sessions_dao.dart';
import 'package:pingpongbuddy/core/database/tables/sessions.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Sessions], daos: [SessionsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // Step-by-step migrations added here as schema evolves:
        // if (from < 2) { await m.addColumn(...); }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
