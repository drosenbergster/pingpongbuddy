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
