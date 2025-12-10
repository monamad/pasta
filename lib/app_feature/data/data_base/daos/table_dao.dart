import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
part 'table_dao.g.dart';

abstract class ITableDao {
  Future<List<GameTableData>> getAllTables();
  Future<GameTableData?> getTableById(int id);
  Future<List<GameTableData>> getTablesByCategory(int categoryId);
  Future<List<GameTableData>> getAvailableTablesByCategory(int categoryId);
  Future<List<GameTableData>> getBusyTables();
  Future<int> numberOfBusyTables();
  Future<int> insertTable(GameTableCompanion entry);
}

@DriftAccessor(tables: [GameTable, Session])
class TableDao extends DatabaseAccessor<AppDatabase>
    with _$TableDaoMixin
    implements ITableDao {
  TableDao(super.db);

  @override
  Future<int> insertTable(GameTableCompanion entry) =>
      into(gameTable).insert(entry);

  @override
  Future<List<GameTableData>> getAllTables() => select(gameTable).get();

  @override
  Future<GameTableData?> getTableById(int id) =>
      (select(gameTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<List<GameTableData>> getTablesByCategory(int categoryId) => (select(
    gameTable,
  )..where((tbl) => tbl.categoryId.equals(categoryId))).get();

  @override
  Future<List<GameTableData>> getAvailableTablesByCategory(
    int categoryId,
  ) async {
    final query =
        select(gameTable).join([
            leftOuterJoin(
              session,
              session.tableId.equalsExp(gameTable.id) &
                  session.endTime.isNull(),
            ),
          ])
          ..where(gameTable.categoryId.equals(categoryId))
          ..where(session.id.isNull());

    final results = await query.get();
    return results.map((row) => row.readTable(gameTable)).toList();
  }

  @override
  Future<List<GameTableData>> getBusyTables() async {
    final query = (select(gameTable)).join([
      innerJoin(
        session,
        session.tableId.equalsExp(gameTable.id) & session.endTime.isNull(),
      ),
    ]);

    final results = await query.get();
    return results.map((row) => row.readTable(gameTable)).toList();
  }

  @override
  Future<int> numberOfBusyTables() {
    final query = selectOnly(gameTable)
      ..addColumns([gameTable.id])
      ..join([
        innerJoin(
          session,
          session.tableId.equalsExp(gameTable.id) & session.endTime.isNull(),
        ),
      ]);

    return query.get().then((rows) => rows.length);
  }
}
