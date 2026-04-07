import 'package:drift/drift.dart';

class Sessions extends Table {
  TextColumn get id => text()();

  TextColumn get videoPath => text().nullable()();

  DateTimeColumn get recordedAt => dateTime()();

  IntColumn get duration => integer().nullable()();

  TextColumn get analysisStatus =>
      text().withDefault(const Constant('pending'))();

  TextColumn get tier => text().withDefault(const Constant('free'))();

  TextColumn get thumbnailPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
