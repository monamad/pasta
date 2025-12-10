import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';

void main() {
  late AppDatabase db;
  late SessionRepository repository;

  setUp(() {
    db = _createTestDatabase();
    repository = SessionRepository(db.sessionDao, db.tableDao, db.categoryDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('SessionRepository', () {
    test('startSession - should create new session', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);

      final sessionId = await repository.startSession(tableId: tableId);

      expect(sessionId, greaterThan(0));
      final session = await db.sessionDao.getSessionById(sessionId);
      expect(session, isNotNull);
      expect(session!.tableId, tableId);
      expect(session.endTime, isNull);
    });

    test('startSession - should create session with duration', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);

      final sessionId = await repository.startSession(
        tableId: tableId,
        durationMinutes: 120,
      );

      final session = await db.sessionDao.getSessionById(sessionId);
      expect(session!.durationMinutes, 120);
    });

    test('startSession - should throw when table is already busy', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);
      await repository.startSession(tableId: tableId);

      expect(
        () => repository.startSession(tableId: tableId),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('already busy'),
          ),
        ),
      );
    });

    test('endSession - should end session and calculate price', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);
      final sessionId = await repository.startSession(tableId: tableId);

      await Future.delayed(Duration(milliseconds: 100));
      final totalPrice = await repository.endSession(sessionId);

      expect(totalPrice, greaterThanOrEqualTo(0.0));
      final session = await db.sessionDao.getSessionById(sessionId);
      expect(session!.endTime, isNotNull);
      expect(session.totalPrice, totalPrice);
    });

    test(
      'endSession - should calculate correct price based on duration',
      () async {
        final categoryId = await _createCategory(
          db,
          'Console',
          60.0,
        ); // 60 per hour
        final tableId = await _createTable(db, 'Console 1', categoryId);

        final sessionId = await db.sessionDao.createNewSession(
          tableId: tableId,
        );

        final session = await db.sessionDao.getSessionById(sessionId);
        final testStartTime = DateTime.now().subtract(Duration(minutes: 30));
        await db.sessionDao.updateSession(
          session!.copyWith(startTime: testStartTime),
        );

        final totalPrice = await repository.endSession(sessionId);

        expect(
          totalPrice,
          closeTo(30.0, 1.0),
        ); // 30 minutes = 0.5 hours * 60 = 30
      },
    );

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

    test('endSession - should throw when session already ended', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);
      final tableId = await _createTable(db, 'Console 1', categoryId);
      final sessionId = await repository.startSession(tableId: tableId);
      await repository.endSession(sessionId);

      expect(
        () => repository.endSession(sessionId),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('already ended'),
          ),
        ),
      );
    });

    test('endSession - should throw when table not found', () async {
      final sessionId = await db.sessionDao.createNewSession(tableId: 999);

      expect(
        () => repository.endSession(sessionId),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Table not found'),
          ),
        ),
      );
    });

    // test('getRunning - should return all running sessions', () async {
    //   final categoryId = await _createCategory(db, 'Console', 50.0);
    //   final tableId1 = await _createTable(db, 'Console 1', categoryId);
    //   final tableId2 = await _createTable(db, 'Console 2', categoryId);

    //   final sessionId1 = await repository.startSession(tableId: tableId1);
    //   final sessionId2 = await repository.startSession(tableId: tableId2);
    //   await repository.endSession(sessionId1);

    //   final runningSessions = await repository.getRunning();

    //   expect(runningSessions.length, 1);
    //   expect(runningSessions[0].id, sessionId2);
    // });

    test(
      'getRunning - should return empty list when no running sessions',
      () async {
        final runningSessions = await repository.getRunning();

        expect(runningSessions, isEmpty);
      },
    );

    test(
      'countRunning - should return correct count of running sessions',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId1 = await _createTable(db, 'Console 1', categoryId);
        final tableId2 = await _createTable(db, 'Console 2', categoryId);
        final tableId3 = await _createTable(db, 'Console 3', categoryId);

        await repository.startSession(tableId: tableId1);
        await repository.startSession(tableId: tableId2);
        await repository.startSession(tableId: tableId3);

        final count = await repository.countRunning();

        expect(count, 3);
      },
    );

    test('countRunning - should return 0 when no running sessions', () async {
      final count = await repository.countRunning();

      expect(count, 0);
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
