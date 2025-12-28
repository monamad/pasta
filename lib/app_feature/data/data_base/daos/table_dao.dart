import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
part 'table_dao.g.dart';

abstract class ITableDao {
  Future<List<GameTableData>> getAllTables();
  Future<String> getTableNameById(int id);
  Future<List<GameTableData>> getAvailableTablesByCategory(int categoryId);
  Future<bool> getTableStatus(int tableId);
  Future<int> insertTable(GameTableCompanion entry);
  Future<double> getTablePriceById(int id);
  Future<GameTableData?> getTableById(int id);
  Future<bool> updateTableStatus(int tableId);
  Future<List<GameTableData>> getTablesByCategory(int categoryId);
}

@DriftAccessor(tables: [GameTable, Category])
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
  Future<String> getTableNameById(int id) =>
      getTableById(id).then((table) => table!.name);

  @override
  Future<double> getTablePriceById(int id) async {
    int x = await getTableById(id).then((table) => table!.categoryId);
    return await (select(category)..where((cat) => cat.id.equals(x)))
        .getSingle()
        .then((catRow) => catRow.pricePerHour);
  }

  @override
  Future<List<GameTableData>> getAvailableTablesByCategory(
    int categoryId,
  ) async {
    return await (select(gameTable)..where(
          (tbl) =>
              tbl.isOccupied.equals(false) & tbl.categoryId.equals(categoryId),
        ))
        .get();
  }

  @override
  Future<List<GameTableData>> getTablesByCategory(int categoryId) async {
    return await (select(
      gameTable,
    )..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  }

  @override
  Future<bool> getTableStatus(int tableId) =>
      getTableById(tableId).then((table) => table!.isOccupied);
  @override
  Future<GameTableData?> getTableById(int id) =>
      (select(gameTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<bool> updateTableStatus(int tableId) async {
    final table = await getTableById(tableId);

    final newStatus = !table!.isOccupied;

    await (update(gameTable)..where((tbl) => tbl.id.equals(tableId))).write(
      GameTableCompanion(isOccupied: Value(newStatus)),
    );

    return newStatus;
  }
}
