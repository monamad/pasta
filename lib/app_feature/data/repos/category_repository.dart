import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';

class CategoryRepository {
  final ICategoryDao _dao;

  CategoryRepository(this._dao);

  Future<List<CategoryData>> getAll() {
    return _dao.getAllCategories();
  }

  Future<CategoryData?> getById(int id) {
    return _dao.getCategoryById(id);
  }

  Future<int> create(String name, double pricePerHour) {
    return _dao.insertCategory(
      CategoryCompanion.insert(name: name, pricePerHour: pricePerHour),
    );
  }
}
