import 'package:get_it/get_it.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/session_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/repos/category_repository.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  // DAOs
  getIt.registerLazySingleton<ICategoryDao>(
    () => getIt<AppDatabase>().categoryDao,
  );
  getIt.registerLazySingleton<ITableDao>(() => getIt<AppDatabase>().tableDao);
  getIt.registerLazySingleton<SessionDao>(
    () => getIt<AppDatabase>().sessionDao,
  );
  getIt.registerLazySingleton<ISessionDao>(
    () => getIt<AppDatabase>().sessionDao,
  );
  // Repositories
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepository(getIt<ICategoryDao>()),
  );
  getIt.registerLazySingleton<TableRepository>(
    () => TableRepository(getIt<ITableDao>()),
  );
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepository(
      getIt<ISessionDao>(),
      getIt<ITableDao>(),
      getIt<ICategoryDao>(),
    ),
  );
}
