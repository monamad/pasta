import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/data_base/daos/session_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/session_model_with_details.dart';

class SessionRepository {
  final ISessionDao _sessionDao;
  final ITableDao _tableDao;
  final ICategoryDao _categoryDao;

  SessionRepository(this._sessionDao, this._tableDao, this._categoryDao);

  Future<int> startSession({
    required int tableId,
    int? durationMinutes,
    DateTime? startTime,
  }) async {
    final running = await _sessionDao.getRunningSessionByTableId(tableId);

    if (running != null) {
      throw Exception("Table is already busy!");
    }

    return _sessionDao.createNewSession(
      tableId: tableId,
      durationMinutes: durationMinutes,
      startTime: startTime,
    );
  }

  Future<double> endSession(int sessionId) async {
    final session = await _sessionDao.getSessionById(sessionId);

    if (session == null) {
      throw Exception("Session not found.");
    }

    if (session.endTime != null) {
      throw Exception("Session already ended.");
    }

    // get the table data -> from it we get the category -> from it the price per hour
    final table = await _tableDao.getTableById(session.tableId);
    if (table == null) throw Exception("Table not found.");

    final category = await _categoryDao.getCategoryById(table.categoryId);
    if (category == null) throw Exception("Category not found.");

    final pricePerHour = category.pricePerHour;

    final now = DateTime.now();
    final diff = now.difference(session.startTime);
    final minutes = diff.inMinutes;

    final totalPrice = (minutes / 60) * pricePerHour;

    await _sessionDao.endSession(sessionId, totalPrice);
    return totalPrice;
  }

  Future<List<SessionWithDetails>> getRunning() async {
    final sessions = await _sessionDao.getRunningsessions();
    return SessionWithDetails.fromSessions(sessions, _tableDao, _categoryDao);
  }

  Future<double> getTotalTodayRevenue() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final sessions = await _sessionDao.getSessionsByDateRange(
      startOfDay,
      endOfDay,
    );

    return sessions.fold<double>(
      0.0,
      (sum, session) => sum + session.totalPrice,
    );
  }

  Future<double> getTotalMonthRevenue() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final sessions = await _sessionDao.getSessionsByDateRange(
      startOfMonth,
      endOfMonth,
    );

    return sessions.fold<double>(
      0.0,
      (sum, session) => sum + session.totalPrice,
    );
  }

  Future<List<SessionData>> getAllSessions() async {
    return await _sessionDao.getAllsession();
  }
}
