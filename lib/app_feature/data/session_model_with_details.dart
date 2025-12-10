import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';

class SessionWithDetails {
  final SessionData session;
  final GameTableData table;
  final CategoryData category;

  SessionWithDetails({
    required this.session,
    required this.table,
    required this.category,
  });

  static Future<List<SessionWithDetails>> fromSessions(
    List<SessionData> sessions,
    ITableDao tableDao,
    ICategoryDao categoryDao,
  ) async {
    final List<GameTableData?> tables = await Future.wait(
      sessions
          .map((session) => tableDao.getTableById(session.tableId))
          .toList(),
    );
    final List<CategoryData?> categorys = await Future.wait(
      tables
          .map((table) => categoryDao.getCategoryById(table!.categoryId))
          .toList(),
    );
    return List.generate(
      sessions.length,
      (index) => SessionWithDetails(
        session: sessions[index],
        table: tables[index]!,
        category: categorys[index]!,
      ),
    );
  }

  double get pricePerHour => category.pricePerHour;

  String get tableName => table.name;

  String get categoryName => category.name;

  DateTime get startTime => session.startTime;

  DateTime? get endTime => session.endTime;

  double get totalPrice => session.totalPrice;
  int? get durationMinutes => session.durationMinutes;
}
