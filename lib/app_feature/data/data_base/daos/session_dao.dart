import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
part 'session_dao.g.dart';

abstract class ISessionDao {
  Future<List<SessionData>> getAllsession();
  Future<SessionData?> getSessionById(int id);
  Future<List<SessionData>> getRunningSessions();
  Future<List<SessionData>> getDoneSessions({int? limit, int? offset});
  Future<int> getRunningSessionCount();
  Future<List<SessionData>> getReservedSessions();
  Future<List<SessionData>> getActiveSessionsForTable(int tableId);
  Future<int> createNewSession({
    required int tableId,
    DateTime? startTime,
    DateTime? expectedEndTime,
    required SessionStatus sessionStatus,
  });
  Future<double> endSession(
    int sessionId,
    double totalPrice,
    DateTime? endedTime,
    SessionStatus sessionStatus,
  );
  Future<void> updateSession(SessionData session);
  Future<List<SessionData>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  );
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
    final sessions = await (select(
      session,
    )..where((ses) => ses.status.equals(SessionStatus.occupied.name))).get();

    return sessions;
  }

  @override
  Future<int> createNewSession({
    required int tableId,
    DateTime? startTime,
    DateTime? expectedEndTime,
    required SessionStatus sessionStatus,
  }) async {
    final tableData = await (select(
      gameTable,
    )..where((tbl) => tbl.id.equals(tableId))).getSingleOrNull();
    if (tableData == null) {
      throw Exception('tableData not found');
    }
    //get category price
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
        status: Value(sessionStatus),
      ),
    );
  }

  @override
  Future<double> endSession(
    int sessionId,
    double totalPrice,
    DateTime? endedTime,
    SessionStatus sessionStatus,
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
        status: Value(sessionStatus),
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
  Future<int> getRunningSessionCount() async {
    final query = selectOnly(session)
      ..addColumns([session.id.count()])
      ..where(session.status.equals(SessionStatus.occupied.name));

    final result = await query.getSingle();
    return result.read(session.id.count()) ?? 0;
  }

  @override
  Future<List<SessionData>> getDoneSessions({int? limit, int? offset}) {
    final query = select(session)
      ..where((tbl) => tbl.status.equals(SessionStatus.done.name))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.actualEndTime)]);

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    return query.get();
  }

  @override
  Future<List<SessionData>> getReservedSessions() {
    return (select(
      session,
    )..where((tbl) => tbl.status.equals(SessionStatus.reserved.name))).get();
  }

  @override
  Future<List<SessionData>> getActiveSessionsForTable(int tableId) {
    return (select(session)
          ..where((tbl) => tbl.tableId.equals(tableId))
          ..where(
            (tbl) =>
                tbl.status.equals(SessionStatus.occupied.name) |
                tbl.status.equals(SessionStatus.reserved.name),
          ))
        .get();
  }
}
