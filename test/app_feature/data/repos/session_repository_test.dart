import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/core/notifications/local_notification_service.dart';

void main() {
  late AppDatabase db;
  late SessionRepository repository;

  setUp(() {
    db = _createTestDatabase();
    repository = SessionRepository(
      db.sessionDao,
      db.tableDao,
      db.categoryDao,
      _MockNotificationService(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('SessionRepository - Start Session', () {
    test(
      'startSession - should create new session with default values',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);

        final sessionId = await repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId,
        );

        expect(sessionId, greaterThan(0));
        final session = await db.sessionDao.getSessionById(sessionId);
        expect(session, isNotNull);
        expect(session!.tableId, tableId);
        expect(session.actualEndTime, isNull);
        expect(session.hourPrice, 50.0);
        expect(session.status, isTrue);
        expect(session.totalPrice, isNull);
      },
    );

    test(
      'startSession - should create session with custom start time',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);
        final customStartTime = DateTime.now().subtract(Duration(hours: 1));

        final sessionId = await repository.startSession(
          tableId: tableId,
          startTime: customStartTime,
        );

        final session = await db.sessionDao.getSessionById(sessionId);
        expect(
          session!.startTime.difference(customStartTime).inSeconds,
          lessThan(1),
        );
      },
    );

    test(
      'startSession - should create session with expected end time',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);

        final sessionId = await repository.startSession(
          startTime: DateTime.now(),

          tableId: tableId,
          durationHours: 2.0,
        );

        final session = await db.sessionDao.getSessionById(sessionId);
        expect(session!.expectedEndTime, isNotNull);
        expect(
          session.expectedEndTime!
              .difference(session.startTime.add(Duration(minutes: 120)))
              .inSeconds,
          lessThan(1),
        );
      },
    );

    test(
      'startSession - should create session with both custom start and expected end time',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);
        final customStartTime = DateTime.now().subtract(Duration(minutes: 30));

        final sessionId = await repository.startSession(
          tableId: tableId,
          startTime: customStartTime,
          durationHours: 1.0,
        );

        final session = await db.sessionDao.getSessionById(sessionId);
        expect(
          session!.startTime.difference(customStartTime).inSeconds,
          lessThan(1),
        );
        expect(session.expectedEndTime, isNotNull);
      },
    );

    test('startSession - should inherit price from category', () async {
      final categoryId = await _createCategory(db, 'VIP', 120.0);
      final tableId = await _createTable(db, 'VIP 1', categoryId);

      final sessionId = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId,
      );

      final session = await db.sessionDao.getSessionById(sessionId);
      expect(session!.hourPrice, 120.0);
    });

    test('startSession - should throw when table is already busy', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);
      await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId,
      );

      expect(
        () => repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId,
        ),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('already busy'),
          ),
        ),
      );
    });

    test(
      'startSession - should allow new session after previous ended',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);
        final firstSessionId = await repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId,
        );
        await repository.endSession(firstSessionId);

        final secondSessionId = await repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId,
        );

        expect(secondSessionId, greaterThan(firstSessionId));
        final session = await db.sessionDao.getSessionById(secondSessionId);
        expect(session, isNotNull);
        expect(session!.actualEndTime, isNull);
      },
    );
  });

  group('SessionRepository - End Session', () {
    test(
      'endSession - should calculate correct price for exact duration',
      () async {
        final categoryId = await _createCategory(db, 'Console', 60.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);

        // Create session directly with past start time
        final sessionId = await db.sessionDao.createNewSession(
          tableId: tableId,
          startTime: DateTime.now().subtract(Duration(minutes: 30)),
        );

        final totalPrice = await repository.endSession(sessionId);

        // 30 minutes = 0.5 hours * 60 = 30
        expect(totalPrice, closeTo(30.0, 1.0));
      },
    );

    test('endSession - should calculate correct price for 1 hour', () async {
      final categoryId = await _createCategory(db, 'Console', 100.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);

      final sessionId = await db.sessionDao.createNewSession(
        tableId: tableId,
        startTime: DateTime.now().subtract(Duration(hours: 1)),
      );

      final totalPrice = await repository.endSession(sessionId);

      expect(totalPrice, closeTo(100.0, 2.0));
    });

    test('endSession - should calculate correct price for 2.5 hours', () async {
      final categoryId = await _createCategory(db, 'VIP', 80.0);
      final tableId = await _createTable(db, 'VIP 1', categoryId);

      final sessionId = await db.sessionDao.createNewSession(
        tableId: tableId,
        startTime: DateTime.now().subtract(Duration(minutes: 150)),
      );

      final totalPrice = await repository.endSession(sessionId);

      // 150 minutes = 2.5 hours * 80 = 200
      expect(totalPrice, closeTo(200.0, 3.0));
    });

    test('endSession - should handle very short sessions', () async {
      final categoryId = await _createCategory(db, 'Console', 60.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);
      final sessionId = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId,
      );

      // End immediately
      final totalPrice = await repository.endSession(sessionId);

      expect(totalPrice, greaterThanOrEqualTo(0.0));
      expect(totalPrice, lessThan(1.0)); // Should be very small
    });

    test('endSession - should throw when session not found', () async {
      expect(
        () => repository.endSession(999),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('not found'),
          ),
        ),
      );
    });
  });

  group('SessionRepository - Get Running Sessions', () {
    test('getRunning - should return all running sessions', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId1 = await _createTable(db, 'Console 1', categoryId);
      final tableId2 = await _createTable(db, 'Console 2', categoryId);

      final sessionId1 = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId1,
      );
      final sessionId2 = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId2,
      );

      final runningSessions = await repository.getRunning();

      expect(runningSessions.length, 2);
      expect(runningSessions.any((s) => s.session.id == sessionId1), isTrue);
      expect(runningSessions.any((s) => s.session.id == sessionId2), isTrue);
    });

    test('getRunning - should exclude ended sessions', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId1 = await _createTable(db, 'Console 1', categoryId);
      final tableId2 = await _createTable(db, 'Console 2', categoryId);

      final sessionId1 = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId1,
      );
      final sessionId2 = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId2,
      );
      await repository.endSession(sessionId1);

      final runningSessions = await repository.getRunning();

      expect(runningSessions.length, 1);
      expect(runningSessions[0].session.id, sessionId2);
    });

    test(
      'getRunning - should return empty list when no running sessions',
      () async {
        final runningSessions = await repository.getRunning();

        expect(runningSessions, isEmpty);
      },
    );

    test(
      'getRunning - should return empty list when all sessions ended',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId1 = await _createTable(db, 'Console 1', categoryId);
        final tableId2 = await _createTable(db, 'Console 2', categoryId);

        final sessionId1 = await repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId1,
        );
        final sessionId2 = await repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId2,
        );
        await repository.endSession(sessionId1);
        await repository.endSession(sessionId2);

        final runningSessions = await repository.getRunning();

        expect(runningSessions, isEmpty);
      },
    );
  });

  group('SessionRepository - Revenue Calculations', () {
    test('getTotalTodayRevenue - should return 0 when no sessions', () async {
      final revenue = await repository.getTotalTodayRevenue();
      expect(revenue, 0.0);
    });

    test(
      'getTotalTodayRevenue - should sum all today ended sessions',
      () async {
        final categoryId = await _createCategory(db, 'Console', 60.0);
        final tableId1 = await _createTable(db, 'Console 1', categoryId);
        final tableId2 = await _createTable(db, 'Console 2', categoryId);

        // Create and end first session
        final sessionId1 = await db.sessionDao.createNewSession(
          tableId: tableId1,
          startTime: DateTime.now().subtract(Duration(minutes: 60)),
        );
        await repository.endSession(sessionId1);

        // Create and end second session
        final sessionId2 = await db.sessionDao.createNewSession(
          tableId: tableId2,
          startTime: DateTime.now().subtract(Duration(minutes: 30)),
        );
        await repository.endSession(sessionId2);

        final revenue = await repository.getTotalTodayRevenue();

        // Should be approximately 60 + 30 = 90
        expect(revenue, greaterThan(80.0));
        expect(revenue, lessThan(100.0));
      },
    );

    test('getTotalTodayRevenue - should exclude running sessions', () async {
      final categoryId = await _createCategory(db, 'Console', 60.0);
      final tableId1 = await _createTable(db, 'Console 1', categoryId);
      final tableId2 = await _createTable(db, 'Console 2', categoryId);

      // End one session
      final sessionId1 = await db.sessionDao.createNewSession(
        tableId: tableId1,
        startTime: DateTime.now().subtract(Duration(minutes: 60)),
      );
      await repository.endSession(sessionId1);

      // Keep one running
      await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId2,
      );

      final revenue = await repository.getTotalTodayRevenue();

      // Should only count the ended session
      expect(revenue, closeTo(60.0, 2.0));
    });

    test('getTotalMonthRevenue - should return 0 when no sessions', () async {
      final revenue = await repository.getTotalMonthRevenue();
      expect(revenue, 0.0);
    });

    test(
      'getTotalMonthRevenue - should sum all month ended sessions',
      () async {
        final categoryId = await _createCategory(db, 'Console', 60.0);
        final tableId1 = await _createTable(db, 'Console 1', categoryId);
        final tableId2 = await _createTable(db, 'Console 2', categoryId);

        final sessionId1 = await db.sessionDao.createNewSession(
          tableId: tableId1,
          startTime: DateTime.now().subtract(Duration(minutes: 60)),
        );
        await repository.endSession(sessionId1);

        final sessionId2 = await db.sessionDao.createNewSession(
          tableId: tableId2,
          startTime: DateTime.now().subtract(Duration(minutes: 120)),
        );
        await repository.endSession(sessionId2);

        final revenue = await repository.getTotalMonthRevenue();

        // Should be approximately 60 + 120 = 180
        expect(revenue, greaterThan(170.0));
        expect(revenue, lessThan(190.0));
      },
    );
  });

  group('SessionRepository - Get Done Sessions', () {
    test(
      'getAllSessions - should return empty list when no sessions',
      () async {
        final sessions = await repository.getDoneSessions();
        expect(sessions, isEmpty);
      },
    );

    test('getAllSessions - should return all ended sessions', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId1 = await _createTable(db, 'Console 1', categoryId);
      final tableId2 = await _createTable(db, 'Console 2', categoryId);

      final sessionId1 = await repository.startSession(
        startTime: DateTime.now().subtract(Duration(minutes: 61)),
        tableId: tableId1,
      );
      final sessionId2 = await repository.startSession(
        startTime: DateTime.now().subtract(Duration(minutes: 61)),
        tableId: tableId2,
      );

      await repository.endSession(sessionId1);
      await repository.endSession(sessionId2);

      final sessions = await repository.getDoneSessions();

      expect(sessions.length, 2);
      expect(sessions.every((s) => s.actualEndTime != null), isTrue);
    });
  });

  group('SessionDao - Direct Methods', () {
    test('getRunningsessionCount - should return correct count', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId1 = await _createTable(db, 'Console 1', categoryId);
      final tableId2 = await _createTable(db, 'Console 2', categoryId);

      await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId1,
      );
      await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId2,
      );

      final count = await db.sessionDao.getRunningSessionCount();

      expect(count, 2);
    });

    test(
      'getRunningsessionCount - should return 0 when no running sessions',
      () async {
        final count = await db.sessionDao.getRunningSessionCount();
        expect(count, 0);
      },
    );

    test(
      'getRunningSessionByTableId - should return session for specific table',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);
        final sessionId = await repository.startSession(
          startTime: DateTime.now(),
          tableId: tableId,
        );

        final session = await db.sessionDao.getRunningSessionByTableId(tableId);

        expect(session, isNotNull);
        expect(session!.id, sessionId);
        expect(session.tableId, tableId);
      },
    );

    test(
      'getRunningSessionByTableId - should return null when table free',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId = await _createTable(db, 'Console 1', categoryId);

        final session = await db.sessionDao.getRunningSessionByTableId(tableId);

        expect(session, isNull);
      },
    );

    test('updateSession - should update session fields', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);
      final sessionId = await repository.startSession(
        startTime: DateTime.now(),
        tableId: tableId,
      );

      var session = await db.sessionDao.getSessionById(sessionId);
      final newExpectedEndTime = DateTime.now().add(Duration(hours: 3));
      await db.sessionDao.updateSession(
        session!.copyWith(expectedEndTime: Value(newExpectedEndTime)),
      );

      session = await db.sessionDao.getSessionById(sessionId);
      expect(session!.expectedEndTime, isNotNull);
      expect(
        session.expectedEndTime!.difference(newExpectedEndTime).inSeconds,
        lessThan(1),
      );
    });
  });
}

AppDatabase _createTestDatabase() {
  return AppDatabase.forTest(NativeDatabase.memory());
}

Future<int> _createCategory(
  AppDatabase db,
  String name,
  double pricePerHour,
) async {
  return await db.categoryDao.insertCategory(
    CategoryCompanion.insert(name: name, pricePerHour: pricePerHour),
  );
}

Future<int> _createTable(AppDatabase db, String name, int categoryId) async {
  return await db.tableDao.insertTable(
    GameTableCompanion.insert(name: name, categoryId: categoryId),
  );
}

class _MockNotificationService implements ILocalNotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<void> showSessionEnded({
    required double durationInHours,
    required int notificationId,
    required String tableName,
    required double totalPrice,
  }) async {}

  @override
  Future<void> scheduleEndBookingNotification({
    required DateTime endTime,
    required int notificationId,
    required String tableName,
    required double durationHours,
    required double totalPrice,
  }) async {}

  @override
  Future<void> cancelBookingNotification(int notificationId) async {}
}
