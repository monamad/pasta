import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/data_base/daos/session_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/session_model_with_details.dart';
import 'package:pasta/core/notifications/local_notification_service.dart';

class SessionRepository {
  final ISessionDao _sessionDao;
  final ITableDao _tableDao;
  final ICategoryDao _categoryDao;
  final ILocalNotificationService _notificationService;

  SessionRepository(
    this._sessionDao,
    this._tableDao,
    this._categoryDao,
    this._notificationService,
  );

  Future<int> startSession({
    required int tableId,
    required DateTime startTime,
    double? durationHours,
  }) async {
    DateTime? expectedEndTime;

    if (durationHours != null) {
      expectedEndTime = startTime.add(
        Duration(minutes: (durationHours * 60).toInt()),
      );
      // Adjust expectedEndTime to remove milliseconds
      expectedEndTime = DateTime(
        expectedEndTime.year,
        expectedEndTime.month,
        expectedEndTime.day,
        expectedEndTime.hour,
        expectedEndTime.minute,
        expectedEndTime.second,
      );
    }
    final running = await _sessionDao.getRunningSessionByTableId(tableId);

    if (running != null) {
      throw Exception("Table is already busy!");
    }

    int id = await _sessionDao.createNewSession(
      tableId: tableId,
      startTime: startTime,
      expectedEndTime: expectedEndTime,
    );
    double hourPrice = await _tableDao
        .getTableById(tableId)
        .then((table) => table!.categoryId)
        .then((categoryId) => _categoryDao.getCategoryById(categoryId))
        .then((category) => category!.pricePerHour);
    var tablename = await _tableDao.getTableById(tableId);

    // if session not open create schedule notification for end of booking
    if (durationHours != null) {
      await _notificationService.scheduleEndBookingNotification(
        endTime: (startTime).add(
          Duration(minutes: (durationHours * 60).toInt()),
        ),

        notificationId: id,
        tableName: tablename!.name,
        durationHours: durationHours,
        totalPrice: hourPrice * durationHours,
      );
    }
    return id;
  }

  Future<double> endSession(int sessionId) async {
    late final DateTime accualEndedTime;

    final sessionData = await _sessionDao.getSessionById(sessionId);

    if (sessionData == null) {
      throw Exception('Session not found');
    }
    // if session with spacified end time, use that to calculate duration
    if (sessionData.expectedEndTime != null) {
      accualEndedTime = sessionData.expectedEndTime!;
    } else {
      // else use current time to calculate duration as session was open , assign like this to overcome milliseconds issue
      accualEndedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );
    }
    final durationInHours =
        accualEndedTime.difference(sessionData.startTime).inMinutes / 60;
    final totalPrice = sessionData.hourPrice * durationInHours;
    await _sessionDao.endSession(sessionId, totalPrice, accualEndedTime);
    if (sessionData.expectedEndTime == null) {
      //show notification
      await _notificationService.showSessionEnded(
        durationInHours: durationInHours,
        notificationId: sessionId,
        tableName: await _tableDao
            .getTableById(sessionData.tableId)
            .then((table) => table!.name),

        totalPrice: totalPrice,
      );
    }
    return totalPrice;
  }

  Future<void> extendSession(int sessionId, int additionalMinutes) async {
    final sessionData = await _sessionDao.getSessionById(sessionId);

    if (sessionData == null) {
      throw Exception('Session not found');
    }

    if (sessionData.expectedEndTime == null) {
      throw Exception('Cannot extend an open session');
    }

    DateTime newExpectedEndTime;

    newExpectedEndTime = sessionData.expectedEndTime!.add(
      Duration(minutes: additionalMinutes),
    );
    SessionData updatedSession = sessionData.copyWith(
      expectedEndTime: Value(newExpectedEndTime),
    );
    await _sessionDao.updateSession(updatedSession);

    await _notificationService.cancelBookingNotification(sessionId);
    await _notificationService.scheduleEndBookingNotification(
      endTime: newExpectedEndTime,
      notificationId: sessionId,
      tableName: await _tableDao
          .getTableById(sessionData.tableId)
          .then((table) => table!.name),
      durationHours:
          newExpectedEndTime
              .difference(sessionData.startTime)
              .inMinutes
              .toDouble() /
          60,
      totalPrice:
          sessionData.hourPrice *
          newExpectedEndTime
              .difference(sessionData.startTime)
              .inMinutes
              .toDouble() /
          60,
    );
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
