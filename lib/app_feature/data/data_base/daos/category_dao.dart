import 'package:drift/drift.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
part 'category_dao.g.dart';

abstract class ICategoryDao {
  Future<List<CategoryData>> getAllCategories();
  Future<CategoryData?> getCategoryById(int id);
  Future<int> insertCategory(CategoryCompanion entry);
  Future<double> getCategoryPriceById(int id);
}

@DriftAccessor(tables: [Category])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin
    implements ICategoryDao {
  CategoryDao(super.db);

  @override
  Future<int> insertCategory(CategoryCompanion entry) =>
      into(category).insert(entry);
  @override
  Future<List<CategoryData>> getAllCategories() => select(category).get();
  @override
  Future<CategoryData?> getCategoryById(int id) =>
      (select(category)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  @override
  Future<double> getCategoryPriceById(int id) =>
      getCategoryById(id).then((cat) => cat!.pricePerHour);
}
