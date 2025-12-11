import 'package:drift/drift.dart';
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
    DateTime? startTime,
    double? durationHours,
  }) async {
    final running = await _sessionDao.getRunningSessionByTableId(tableId);

    if (running != null) {
      throw Exception("Table is already busy!");
    }

    return _sessionDao.createNewSession(
      tableId: tableId,
      startTime: startTime,
      expectedEndTime: durationHours != null
          ? (startTime ?? DateTime.now()).add(
              Duration(minutes: (durationHours * 60).toInt()),
            )
          : null,
    );
  }

  Future<double> endSession(int sessionId) async {
    final sessionData = await _sessionDao.getSessionById(sessionId);
    if (sessionData == null) {
      throw Exception('Session not found');
    }

    final durationInHours =
        DateTime.now().difference(sessionData.startTime).inMinutes / 60;
    final totalPrice = sessionData.hourPrice * durationInHours;

    return await _sessionDao.endSession(sessionId, totalPrice);
  }

  Future<void> extendSession(int sessionId, int additionalMinutes) async {
    final sessionData = await _sessionDao.getSessionById(sessionId);
    if (sessionData == null) {
      throw Exception('Session not found');
    }

    DateTime newExpectedEndTime;

    newExpectedEndTime = sessionData.expectedEndTime!.add(
      Duration(minutes: additionalMinutes),
    );
    SessionData updatedSession = sessionData.copyWith(
      expectedEndTime: Value(newExpectedEndTime),
    );
    await _sessionDao.updateSession(updatedSession);
  }

  Future<List<SessionWithDetails>> getRunning() async {
    final sessions = await _sessionDao.getRunningSessions();
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
      (sum, session) => sum + (session.totalPrice ?? 0.0),
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
      (sum, session) => sum + (session.totalPrice ?? 0.0),
    );
  }



  Future<List<SessionWithDetails>> getDoneSessions() async {
    final sessions = await _sessionDao.getDoneSessions();
    return SessionWithDetails.fromSessions(sessions, _tableDao, _categoryDao);
  }
}
