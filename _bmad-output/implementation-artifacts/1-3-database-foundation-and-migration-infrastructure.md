# Story 1.3: Database Foundation & Migration Infrastructure

Status: review

## Story

As a developer,
I want Drift database tables with versioned schema migrations,
so that the app can evolve its data model without ever losing player data.

## Acceptance Criteria

1. **Given** Drift is configured
   **When** the sessions table is created
   **Then** it stores session metadata (id, timestamp, duration, video path, analysis status, thumbnail path)

2. **Given** any schema change
   **When** a migration is applied
   **Then** it follows step-by-step versioned migration with explicit version numbers and migration hooks

3. **Given** a previous database version
   **When** the app updates
   **Then** 100% of historical session data is preserved

4. **Given** unexpected app termination
   **When** the app restarts
   **Then** no corrupted database state or orphaned temp files exist

5. **Given** a session data write operation
   **When** it executes
   **Then** it is atomic — partial writes do not corrupt existing data

6. **Given** the target device
   **When** minimum device floor is checked
   **Then** it supports 4GB RAM, GPU-capable SoC, Android API 31+, iPhone 12+

## Tasks / Subtasks

- [x] Task 1: Create the `Sessions` Drift table definition (AC: #1)
  - [x] Create `lib/core/database/tables/sessions.dart`
  - [x] Define `Sessions` class extending `Table` with columns: `id` (text, primary key, UUID), `videoPath` (text, nullable), `recordedAt` (dateTime, stored as UTC ms int), `duration` (integer, nullable — in seconds), `analysisStatus` (text — enum-mapped), `tier` (text — 'free' or 'pro'), `thumbnailPath` (text, nullable)
  - [x] Run `dart run build_runner build --delete-conflicting-outputs` to verify generation

- [x] Task 2: Create the `AppDatabase` class with migration infrastructure (AC: #2, #3)
  - [x] Create `lib/core/database/app_database.dart`
  - [x] Annotate with `@DriftDatabase(tables: [Sessions])` — only `Sessions` for now, other tables added in future stories
  - [x] Set `schemaVersion` to `1`
  - [x] Implement `MigrationStrategy` with:
    - `onCreate`: calls `m.createAll()`
    - `onUpgrade`: uses step-by-step migration pattern (empty for v1, but the pattern is established)
    - `beforeOpen`: enables `PRAGMA foreign_keys = ON`
  - [x] Run code generation and verify `app_database.g.dart` is produced

- [x] Task 3: Create a connection factory for opening the database (AC: #4, #5)
  - [x] Create `lib/core/database/connection/native.dart`
  - [x] Use `NativeDatabase` from `package:drift/native.dart` with `LazyDatabase` for deferred file opening
  - [x] Place database file at `getApplicationDocumentsDirectory()` / `pingpongbuddy.sqlite`
  - [x] Wrap in `LazyDatabase` so file I/O happens off the main isolate during open
  - [x] Add `path_provider` dependency to `pubspec.yaml` if not already present

- [x] Task 4: Create `SessionsDao` with basic CRUD operations (AC: #1, #5)
  - [x] Create `lib/core/database/daos/sessions_dao.dart`
  - [x] Annotate with `@DriftAccessor(tables: [Sessions])`
  - [x] Implement: `watchAllSessions()` (reactive stream, ordered by `recordedAt` descending), `getSession(String id)`, `insertSession(SessionsCompanion)`, `updateSession(SessionsCompanion)`, `deleteSession(String id)`
  - [x] All write operations use Drift's built-in transaction wrapping for atomicity (AC: #5)
  - [x] Run code generation and verify `sessions_dao.g.dart` is produced

- [x] Task 5: Register database and DAO in GetIt (AC: #1)
  - [x] Update `lib/core/di/injection_container.dart`
  - [x] Register `AppDatabase` as a singleton (async init: open database, enable PRAGMA)
  - [x] Register `SessionsDao` as a singleton dependent on `AppDatabase`
  - [x] Update `bootstrap.dart` if needed to support async DI initialization

- [x] Task 6: Configure `build.yaml` for Drift code generation (AC: #2)
  - [x] Create `build.yaml` in project root
  - [x] Set `store_date_time_values_as_text: false` (store as integer — UTC ms since epoch per architecture)
  - [x] Configure `databases` section for `make-migrations` command support

- [x] Task 7: Write tests (AC: #1–5)
  - [x] Unit test: `Sessions` table has expected columns with correct types and constraints
  - [x] Unit test: `SessionsDao` CRUD — insert, read, update, delete using in-memory database
  - [x] Unit test: `SessionsDao.watchAllSessions()` emits correct stream updates
  - [x] Unit test: `AppDatabase` migration strategy — `onCreate` creates tables, `beforeOpen` enables FK pragma
  - [x] Unit test: atomic write — insert inside transaction rolls back on failure
  - [x] Run `dart analyze` — zero warnings
  - [x] Run `flutter test` — all tests pass

## Dev Notes

### Drift Setup Pattern

Drift ^2.32.1 is already in `pubspec.yaml` along with `drift_dev ^2.32.1` and `build_runner ^2.13.1`. `sqlite3_flutter_libs ^0.5.32` provides the native SQLite binary.

The primary dependency to add is `path_provider` (for `getApplicationDocumentsDirectory`):

```yaml
# pubspec.yaml — add under dependencies:
path_provider: ^2.1.5
```

### File Structure

```
lib/core/database/
├── app_database.dart          # @DriftDatabase class, migration strategy
├── app_database.g.dart        # Generated
├── connection/
│   └── native.dart            # NativeDatabase + LazyDatabase factory
├── tables/
│   └── sessions.dart          # Sessions table definition
└── daos/
    └── sessions_dao.dart      # SessionsDao with CRUD
    └── sessions_dao.g.dart    # Generated
```

Test mirror:

```
test/core/database/
├── app_database_test.dart
├── daos/
│   └── sessions_dao_test.dart
└── migrations/                # Empty for v1, pattern established for future
```

### Sessions Table Schema

Per the architecture, store DateTimes as UTC milliseconds since epoch (`int` column). Convert to local time only in the presentation layer.

```dart
import 'package:drift/drift.dart';

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get videoPath => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get duration => integer().nullable()();
  TextColumn get analysisStatus => text().withDefault(const Constant('pending'))();
  TextColumn get tier => text().withDefault(const Constant('free'))();
  TextColumn get thumbnailPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Column rationale:**
- `id`: UUID string, generated client-side (no auto-increment — supports offline-first)
- `videoPath`: nullable because video can be deleted while session record is retained (`video_deleted` status)
- `recordedAt`: non-null, set at session creation
- `duration`: nullable — unknown until recording stops; stored in seconds
- `analysisStatus`: enum-like text — values: `pending`, `analyzing`, `completed`, `failed`, `video_deleted`
- `tier`: `free` or `pro` — captures which tier the session was recorded under
- `thumbnailPath`: nullable — generated after recording, path to thumbnail image file

**DateTime storage:** Drift stores `DateTimeColumn` as integer (Unix timestamp) by default when `store_date_time_values_as_text` is `false` in `build.yaml`. This matches the architecture requirement.

### Database Connection Factory

```dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pingpongbuddy.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

`NativeDatabase.createInBackground` opens the database on a background isolate, preventing jank on app startup. `LazyDatabase` defers file I/O until the first query.

Note: `path` package is a transitive dependency already available — no need to add to `pubspec.yaml`. Verify with `flutter pub deps -- path` if unsure.

### Migration Strategy Pattern

For schema version 1, the migration is simple — just create all tables. The pattern must be established so that future schema changes follow it consistently:

```dart
@override
int get schemaVersion => 1;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Step-by-step migrations will be added here as:
      // if (from < 2) { await m.addColumn(...); }
      // if (from < 3) { await m.createTable(...); }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
```

When future stories add tables (strokes, landmarks, etc.), they will:
1. Add the table class to the `@DriftDatabase(tables: [...])` annotation
2. Bump `schemaVersion`
3. Add a migration step in `onUpgrade`
4. Run `dart run drift_dev make-migrations` to generate schema snapshot
5. Write a migration test verifying data preservation

### DAO Pattern

```dart
@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

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
```

### GetIt Registration

Update `lib/core/di/injection_container.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:pingpongbuddy/core/database/app_database.dart';
import 'package:pingpongbuddy/core/database/connection/native.dart';
import 'package:pingpongbuddy/core/database/daos/sessions_dao.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl
    ..registerLazySingleton<AppDatabase>(() => AppDatabase(openConnection()))
    ..registerLazySingleton<SessionsDao>(() => SessionsDao(sl<AppDatabase>()));
}
```

`registerLazySingleton` is appropriate — database is created once and lives for app lifetime. `LazyDatabase` handles deferred initialization, so no need for async registration.

### build.yaml Configuration

```yaml
targets:
  $default:
    builders:
      drift_dev:
        options:
          store_date_time_values_as_text: false
          named_parameters: true
          databases:
            pingpongbuddy: lib/core/database/app_database.dart
```

The `databases` entry enables `dart run drift_dev make-migrations` for future schema snapshot generation.

### Testing Strategy

**In-memory database for tests:** Use `NativeDatabase.memory()` for fast, isolated tests that don't touch the filesystem:

```dart
AppDatabase createTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}
```

**DAO tests:** Insert data, read it back, verify equality. Test stream emissions for `watchAllSessions`. Test that deleting returns the correct count.

**Atomic write test:** Begin a transaction, insert a row, throw an exception mid-transaction, verify the row was NOT persisted.

**Migration test:** For v1 this is minimal — verify that `onCreate` creates the sessions table and it can accept inserts. The real migration tests become critical starting with v2.

For all database tests, add `sqlite3_flutter_libs` to the test environment by importing it. If tests fail with "sqlite3 not found", use `import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';` in the test file or ensure the native SQLite binary is available.

**Important:** Database tests should use `package:test/test.dart`, not `package:flutter_test/flutter_test.dart`, unless widget testing is needed. Drift's `NativeDatabase.memory()` works in pure Dart tests.

### Architecture Compliance

- **AR2:** Step-by-step migration infrastructure established before first table — this story IS AR2
- **NFR15:** Zero data loss on update — migration pattern set up to enforce this for all future schema changes
- **NFR18-19:** Crash recovery + atomic writes — SQLite transactions and PRAGMA foreign_keys
- **Anti-pattern guard:** No direct Drift access from BLoCs — DAO is the access layer, registered in GetIt. BLoCs consume repositories (added in feature stories), which consume DAOs
- **Import rule:** All imports use `package:pingpongbuddy/...` — never relative
- **File naming:** `snake_case` — `app_database.dart`, `sessions.dart`, `sessions_dao.dart`
- **DateTime convention:** Store as UTC integer. Convert to local only in presentation layer.
- **Naming conventions:** Table class `Sessions` (PascalCase plural), columns `camelCase`, DAO `SessionsDao` (PascalCase + Dao), migrations `v{N}.dart`

### What NOT to Do

- Do NOT create all 10 tables from the architecture doc — only `Sessions` is needed now. Other tables are added in their respective stories (strokes in Epic 3, baselines in Epic 6, etc.)
- Do NOT create repository interfaces yet — those come with feature stories that need them
- Do NOT implement video ↔ DB synchronization — that comes with Story 1.6 (Video Recording Session)
- Do NOT use `freezed` for table definitions — Drift generates its own data classes via code generation
- Do NOT store DateTimes as text — use integer (UTC ms since epoch) per architecture
- Do NOT use auto-incrementing integer IDs — use UUID text for offline-first support
- Do NOT implement `make-migrations` snapshot for v1 — the first snapshot is taken before v2 migration. For now, just verify the pattern is in place.
- Do NOT register BLoCs in this story — only database + DAO registrations in GetIt

### Previous Story (1.2) Intelligence

- Design system foundation is complete and committed. All theme extensions working.
- `lib/core/database/` directory exists with empty `tables/`, `daos/`, `migrations/` subdirectories (from VGV scaffold)
- `lib/core/di/injection_container.dart` has a placeholder `configureDependencies()` — ready to populate
- `bootstrap.dart` calls `configureDependencies()` before `runApp` — async init is already supported
- `pubspec.yaml` already has `drift: ^2.32.1`, `sqlite3_flutter_libs: ^0.5.32`, `get_it: ^9.2.1`, `drift_dev: ^2.32.1`, `build_runner: ^2.13.1`
- `build_runner` pipeline verified working in Story 1.1
- `very_good_analysis` lints are strict — watch for `sort_constructors_first`, `prefer_int_literals`, `public_member_api_docs` if enabled

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Data Architecture] — Sessions table fields, migration strategy, video ↔ DB sync rules
- [Source: _bmad-output/planning-artifacts/architecture.md#Day-One Architectural Decisions] — Drift schema versioning mandate (AR2)
- [Source: _bmad-output/planning-artifacts/architecture.md#Target Project Structure] — `core/database/` with tables, daos, migrations subdirectories
- [Source: _bmad-output/planning-artifacts/architecture.md#Implementation Patterns] — Repository pattern, GetIt registration, no direct Drift from BLoCs
- [Source: _bmad-output/planning-artifacts/architecture.md#Drift Database Naming] — Table PascalCase plural, column camelCase, DAO + "Dao", migration v{N}.dart
- [Source: _bmad-output/planning-artifacts/architecture.md#Testing Strategy] — 100% line coverage for core/database
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.3] — Acceptance criteria, NFR15/18/19/33 coverage
- [Source: Drift docs — simolus3/drift] — Table definition, DAO annotation, MigrationStrategy, step-by-step migrations, NativeDatabase

## Dev Agent Record

### Agent Model Used

Claude claude-4.6-opus (via Cursor)

### Debug Log References

- `dart analyze` — zero issues
- `flutter test --no-test-assets` — 39/39 tests pass (20 existing from Stories 1.1/1.2 + 19 new database tests)
- `dart run build_runner build --delete-conflicting-outputs` — generated `app_database.g.dart` and `sessions_dao.g.dart` successfully
- `path_provider: ^2.1.5` added (was transitive, now explicit)
- `path: ^1.9.1` added (was transitive, required explicit by `very_good_analysis` `depend_on_referenced_packages` lint)
- `very_good_analysis` lint fixes: `avoid_types_on_closure_parameters` on MigrationStrategy closures, `matching_super_parameters` on DAO constructor
- DateTime stored as UTC integer per architecture; tests compare via `.toUtc()` since Drift reads back as local time
- `build.yaml` configured with `store_date_time_values_as_text: false` and `named_parameters: true`
- `bootstrap.dart` already supports async DI via `configureDependencies()` — no changes needed

### Completion Notes List

- Created `Sessions` table with 7 columns: id (text PK), videoPath, recordedAt, duration, analysisStatus (default 'pending'), tier (default 'free'), thumbnailPath
- Created `AppDatabase` with `MigrationStrategy` — `onCreate` creates all tables, `onUpgrade` pattern established for future step-by-step migrations, `beforeOpen` enables FK pragma
- Created `LazyDatabase` + `NativeDatabase.createInBackground` connection factory — defers file I/O and runs on background isolate
- Created `SessionsDao` with full CRUD: `watchAllSessions()` (reactive stream, descending by recordedAt), `getSession`, `insertSession`, `updateSession`, `deleteSession`
- Registered `AppDatabase` and `SessionsDao` as lazy singletons in GetIt
- 8 AppDatabase tests (table creation, column verification, PK, defaults, nullability, FK pragma, schema version)
- 11 SessionsDao tests (insert, insert-all-fields, get, get-nonexistent, update, delete, delete-nonexistent, watch-empty, watch-ordered, watch-updates, atomic-rollback)
- Zero regressions — all 20 pre-existing tests pass

### File List

New: `lib/core/database/tables/sessions.dart`, `lib/core/database/app_database.dart`, `lib/core/database/app_database.g.dart`, `lib/core/database/connection/native.dart`, `lib/core/database/daos/sessions_dao.dart`, `lib/core/database/daos/sessions_dao.g.dart`, `build.yaml`, `test/core/database/app_database_test.dart`, `test/core/database/daos/sessions_dao_test.dart`
Modified: `pubspec.yaml`, `lib/core/di/injection_container.dart`
