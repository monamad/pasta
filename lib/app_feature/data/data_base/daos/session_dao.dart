import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
part 'session_dao.g.dart';

abstract class ISessionDao {
  Future<List<SessionData>> getAllsession();
  Future<SessionData?> getSessionById(int id);
  Future<List<SessionData>> getRunningSessions();
  Future<int> getRunningSessionCount();
  Future<SessionData?> getRunningSessionByTableId(int tableId);
  Future<int> createNewSession({
    required int tableId,
    DateTime? startTime,
    DateTime? expectedEndTime,
  });
  Future<double> endSession(
    int sessionId,
    double totalPrice,
    DateTime? endedTime,
  );
  Future<void> updateSession(SessionData session);
  Future<List<SessionData>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<List<SessionData>> getDoneSessions();
}

@DriftAccessor(tables: [Session])
class SessionDao extends DatabaseAccessor<AppDatabase>
    with _$SessionDaoMixin
    implements ISessionDao {
  SessionDao(super.db);

  @override
  Future<List<SessionData>> getAllsession() => select(session).get();

  @override
  Future<SessionData?> getSessionById(int id) =>
      (select(session)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  @override
  Future<List<SessionData>> getRunningSessions() async {
    //ToDo optimize sorting at the query level
    final sessions = await (select(
      session,
    )..where((tbl) => tbl.actualEndTime.isNull())).get();

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

    return sessions;
  }

  @override
  Future<int> getRunningSessionCount() async {
    final query = selectOnly(session)
      ..addColumns([session.id.count()])
      ..where(session.actualEndTime.isNull());

    final result = await query.getSingle();
    return result.read(session.id.count()) ?? 0;
  }

  @override
  Future<SessionData?> getRunningSessionByTableId(int tableId) =>
      (select(session)
            ..where((tbl) => tbl.tableId.equals(tableId))
            ..where((tbl) => tbl.actualEndTime.isNull()))
          .getSingleOrNull();

  @override
  Future<int> createNewSession({
    required int tableId,
    DateTime? startTime,
    DateTime? expectedEndTime,
  }) async {
   
    final tableData = await (select(
      gameTable,
    )..where((tbl) => tbl.id.equals(tableId))).getSingleOrNull();
    if (tableData == null) {
      throw Exception('tableData not found');
    }
    final categoryData = await (select(
      category,
    )..where((tbl) => tbl.id.equals(tableData.categoryId))).getSingleOrNull();

    return await into(session).insert(
      SessionCompanion.insert(
        tableId: tableId,
        startTime: startTime ?? DateTime.now(),
        expectedEndTime: expectedEndTime != null
            ? Value(expectedEndTime)
            : Value(null),
        hourPrice: categoryData!.pricePerHour,
      ),
    );
  }

  @override
  Future<double> endSession(
    int sessionId,
    double totalPrice,
    DateTime? endedTime,
  ) async {
    //canceled session
    if (totalPrice <= 0) {
      //remove this session
      await (delete(session)..where((tbl) => tbl.id.equals(sessionId))).go();
      return 0;
    }
    await (update(session)..where((tbl) => tbl.id.equals(sessionId))).write(
      SessionCompanion(
        actualEndTime: Value(endedTime ?? DateTime.now()),
        totalPrice: Value(totalPrice),
      ),
    );
    return totalPrice;
  }

  @override
  Future<void> updateSession(SessionData data) async {
    await update(session).replace(data);
  }

  @override
  Future<List<SessionData>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    return (select(session)
          ..where((tbl) => tbl.actualEndTime.isNotNull())
          ..where((tbl) => tbl.actualEndTime.isBiggerOrEqualValue(start))
          ..where((tbl) => tbl.actualEndTime.isSmallerOrEqualValue(end)))
        .get();
  }

  @override
  Future<List<SessionData>> getDoneSessions() {
    return (select(session)
          ..where((tbl) => tbl.actualEndTime.isNotNull())
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.actualEndTime)]))
        .get();
  }
}
