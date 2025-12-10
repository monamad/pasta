import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
part 'session_dao.g.dart';

abstract class ISessionDao {
  Future<List<SessionData>> getAllsession();
  Future<SessionData?> getSessionById(int id);
  Future<List<SessionData>> getRunningsessions();
  Future<int> getRunningsessionCount();
  Future<SessionData?> getRunningSessionByTableId(int tableId);
  Future<int> createNewSession({
    required int tableId,
    int? durationMinutes,
    DateTime? startTime,
  });
  Future<void> endSession(int sessionId, double totalPrice);
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
  Future<List<SessionData>> getRunningsessions() =>
      (select(session)..where(
            (tbl) =>
                tbl.endTime.isNull() |
                tbl.endTime.isBiggerThanValue(DateTime.now()),
          ))
          .get();

  @override
  Future<int> getRunningsessionCount() async {
    final query = selectOnly(session)
      ..addColumns([session.id.count()])
      ..where(
        session.endTime.isNull() |
            session.endTime.isBiggerThanValue(DateTime.now()),
      );

    final result = await query.getSingle();
    return result.read(session.id.count()) ?? 0;
  }

  @override
  Future<SessionData?> getRunningSessionByTableId(int tableId) =>
      (select(session)
            ..where((tbl) => tbl.tableId.equals(tableId))
            ..where(
              (tbl) =>
                  tbl.endTime.isNull() |
                  tbl.endTime.isBiggerThanValue(DateTime.now()),
            ))
          .getSingleOrNull();

  @override
  Future<int> createNewSession({
    required int tableId,
    int? durationMinutes,
    DateTime? startTime,
  }) async {
    return await into(session).insert(
      SessionCompanion.insert(
        tableId: tableId,
        startTime: startTime ?? DateTime.now(),
        durationMinutes: Value(durationMinutes),
        endTime: Value(null),
        // durationMinutes == null
        //     ? Value(null)
        //     : Value(DateTime.now().add(Duration(minutes: durationMinutes))),
      ),
    );
  }

  @override
  Future<void> endSession(int sessionId, double totalPrice) async {
    await (update(session)..where((tbl) => tbl.id.equals(sessionId))).write(
      SessionCompanion(
        endTime: Value(DateTime.now()),
        totalPrice: Value(totalPrice),
      ),
    );
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
          ..where((tbl) => tbl.endTime.isNotNull())
          ..where((tbl) => tbl.endTime.isBiggerOrEqualValue(start))
          ..where((tbl) => tbl.endTime.isSmallerOrEqualValue(end)))
        .get();
  }
}
