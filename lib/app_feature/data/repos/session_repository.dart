import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/data_base/daos/session_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/models/conflict_reservation_model.dart';
import 'package:pasta/app_feature/data/models/session_model_with_details.dart';
import 'package:pasta/core/helper/functions.dart';
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
    final sessionStatus = isTimeEqualByMinute(startTime, nowDateTime())
        ? SessionStatus.occupied
        : SessionStatus.reserved;
    // reserved
    if (durationHours != null) {
      expectedEndTime = startTime.add(
        Duration(minutes: (durationHours * 60).toInt()),
      );
    }

    // Check for conflicts
    final conflicts = await checkReservationConflicts(
      tableId: tableId,
      startTime: startTime,
      endTime: expectedEndTime ?? startTime.add(const Duration(hours: 10)),
    );

    if (conflicts.isNotEmpty) {
      throw ReservationConflictException(conflicts);
    }

    int id = await _sessionDao.createNewSession(
      tableId: tableId,
      startTime: startTime,
      expectedEndTime: expectedEndTime,
      sessionStatus: sessionStatus,
    );

    // updateTableStatus
    if (sessionStatus == SessionStatus.occupied) {
      await _tableDao.updateTableStatus(tableId);
    }

    double hourPrice = await _tableDao.getTablePriceById(tableId);
    var tablename = await _tableDao.getTableNameById(tableId);

    // if session not open create schedule notification for end of booking
    if (durationHours != null) {
      await _scheduleNotification(
        startTime,
        durationHours,
        id,
        tablename,
        hourPrice,
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
    final now = nowDateTime();

    // if session with spacified end time, use that to calculate duration
    if (sessionData.expectedEndTime != null) {
      // Use the earlier time between expectedEndTime and now (trim milliseconds)

      accualEndedTime = sessionData.expectedEndTime!.isBefore(now)
          ? sessionData.expectedEndTime!
          : now;
    } else {
      // else use current time to calculate duration as session was open , assign like this to overcome milliseconds issue
      accualEndedTime = now;
    }

    final durationInHours = diffInHours(accualEndedTime, sessionData.startTime);
    final totalPrice = sessionData.hourPrice * durationInHours;
    final session = await _sessionDao.getSessionById(sessionId);
    final result = await _sessionDao.endSession(
      sessionId,
      totalPrice,
      accualEndedTime,
      SessionStatus.done,
    );

    // updateTableStatus
    if (session!.status == SessionStatus.occupied) {
      await _tableDao.updateTableStatus(session.tableId);
    }
    //show notification
    if (sessionData.expectedEndTime == null) {
      await _createNotification(
        durationInHours,
        sessionId,
        sessionData,
        totalPrice,
      );
    }
    return result;
  }

  // check if reservate session become accupied
  Future<void> updateSessionStatus(SessionData sessionData) async {
    if (sessionData.status == SessionStatus.reserved) {
      final now = nowDateTime();
      if (isTimeEqualByMinute(sessionData.startTime, now) ||
          sessionData.startTime.isBefore(now)) {
        final updatedSession = sessionData.copyWith(
          status: SessionStatus.occupied,
        );
        await _sessionDao.updateSession(updatedSession);
        await _tableDao.updateTableStatus(sessionData.tableId);
      }
    }
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
    // Check for conflicts
    final conflicts = await checkReservationConflicts(
      tableId: sessionData.tableId,
      startTime: sessionData.expectedEndTime!,
      endTime: newExpectedEndTime,
    );

    if (conflicts.isNotEmpty) {
      throw ReservationConflictException(conflicts);
    }
    SessionData updatedSession = sessionData.copyWith(
      expectedEndTime: Value(newExpectedEndTime),
    );
    await _sessionDao.updateSession(updatedSession);

    await _notificationService.cancelBookingNotification(sessionId);
    await _notificationService.scheduleEndBookingNotification(
      endTime: newExpectedEndTime,
      notificationId: sessionId,
      tableName: await _tableDao.getTableNameById(sessionData.tableId),

      durationHours: diffInHours(newExpectedEndTime, sessionData.startTime),
      totalPrice:
          sessionData.hourPrice *
          diffInHours(newExpectedEndTime, sessionData.startTime),
    );
  }

  Future<List<SessionWithDetails>> getRunningSessions() async {
    final sessions = await _sessionDao.getRunningSessions();
    final now = DateTime.now();

    sessions.sort((a, b) {
      final aDuration = a.expectedEndTime != null
          ? a.expectedEndTime!.difference(now)
          : const Duration(days: 365 * 100);
      final bDuration = b.expectedEndTime != null
          ? b.expectedEndTime!.difference(now)
          : const Duration(days: 365 * 100);
      return aDuration.compareTo(bDuration);
    });
    return SessionWithDetails.fromSessions(sessions, _tableDao, _categoryDao);
  }

  Future<List<SessionWithDetails>> getReservedSessions() async {
    // First, update statuses of reserved sessions if needed
    await Future.wait(
      (await _sessionDao.getReservedSessions()).map(updateSessionStatus),
    );
    final sessions = await _sessionDao.getReservedSessions();

    final now = DateTime.now();

    sessions.sort((a, b) {
      final aDuration = a.expectedEndTime != null
          ? a.expectedEndTime!.difference(now)
          : const Duration(days: 365 * 100);
      final bDuration = b.expectedEndTime != null
          ? b.expectedEndTime!.difference(now)
          : const Duration(days: 365 * 100);
      return aDuration.compareTo(bDuration);
    });
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

  Future<List<SessionWithDetails>> getDoneSessions({
    int? limit,
    int? offset,
  }) async {
    final sessions = await _sessionDao.getDoneSessions(
      limit: limit,
      offset: offset,
    );
    return SessionWithDetails.fromSessions(sessions, _tableDao, _categoryDao);
  }

  Future<int> getRunningSessionCount() => _sessionDao.getRunningSessionCount();

  Future<List<ConflictingReservation>> checkReservationConflicts({
    required int tableId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final activeSessions = await _sessionDao.getActiveSessionsForTable(tableId);
    final conflicts = <ConflictingReservation>[];

    for (final session in activeSessions) {
      final sessionStart = session.startTime;
      DateTime sessionEnd;

      if (session.expectedEndTime != null) {
        sessionEnd = session.expectedEndTime!;
      } else {
        // For open sessions, assume 10 hours max
        sessionEnd = session.startTime.add(const Duration(hours: 10));
      }

      // Check if there's an overlap
      if (startTime.isBefore(sessionEnd) && endTime.isAfter(sessionStart)) {
        conflicts.add(
          ConflictingReservation(startTime: sessionStart, endTime: sessionEnd),
        );
      }
    }

    return conflicts;
  }

  Future<void> _scheduleNotification(
    DateTime startTime,
    double durationHours,
    int id,
    String tablename,
    double hourPrice,
  ) {
    return _notificationService.scheduleEndBookingNotification(
      endTime: (startTime).add(Duration(minutes: (durationHours * 60).toInt())),

      notificationId: id,
      tableName: tablename,
      durationHours: durationHours,
      totalPrice: hourPrice * durationHours,
    );
  }

  Future<void> _createNotification(
    double durationInHours,
    int sessionId,
    SessionData sessionData,
    double totalPrice,
  ) async {
    _notificationService.showSessionEnded(
      durationInHours: durationInHours,
      notificationId: sessionId,
      tableName: await _tableDao.getTableNameById(sessionData.tableId),
      totalPrice: totalPrice,
    );
  }
}

class ReservationConflictException implements Exception {
  final List<ConflictingReservation> conflicts;

  ReservationConflictException(this.conflicts);

  @override
  String toString() {
    return 'Table has conflicting reservations';
  }
}
