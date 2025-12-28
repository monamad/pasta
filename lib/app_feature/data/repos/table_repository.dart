import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';

class TableRepository {
  final ITableDao _dao;

  TableRepository(this._dao);

  Future<List<GameTableData>> getAll() {
    return _dao.getAllTables();
  }

  Future<List<GameTableData>> getAvailableByCategory(int categoryId) {
    return _dao.getAvailableTablesByCategory(categoryId);
  }

  Future<List<GameTableData>> getTablesByCategory(int categoryId) {
    return _dao.getTablesByCategory(categoryId);
  }

  Future<List<GameTableData>> getbusyTablesByCategory(int categoryId) async {
    final allTables = await _dao.getTablesByCategory(categoryId);

    return allTables.where((table) => table.isOccupied).toList();
  }

  Future<int> addTable(String name, int categoryId) {
    return _dao.insertTable(
      GameTableCompanion.insert(name: name, categoryId: categoryId),
    );
  }
}
