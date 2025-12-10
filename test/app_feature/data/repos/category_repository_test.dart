import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/category_repository.dart';

void main() {
  late AppDatabase db;
  late CategoryRepository repository;

  setUp(() {
    db = _createTestDatabase();
    repository = CategoryRepository(db.categoryDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('CategoryRepository', () {
    test('create - should insert new category', () async {
      final id = await repository.create('Console', 50.0);

      expect(id, greaterThan(0));
      final category = await repository.getById(id);
      expect(category, isNotNull);
      expect(category!.name, 'Console');
      expect(category.pricePerHour, 50.0);
    });

    test('getAll - should return all categories', () async {
      await repository.create('Console', 50.0);
      await repository.create('Billiard', 40.0);
      await repository.create('Ping Pong', 40.0);

      final categories = await repository.getAll();

      expect(categories.length, 3);
      expect(
        categories.map((c) => c.name),
        containsAll(['Console', 'Billiard', 'Ping Pong']),
      );
    });

    test('getAll - should return empty list when no categories', () async {
      final categories = await repository.getAll();

      expect(categories, isEmpty);
    });

    test('getById - should return category when exists', () async {
      final id = await repository.create('Snooker', 60.0);

      final category = await repository.getById(id);

      expect(category, isNotNull);
      expect(category!.id, id);
      expect(category.name, 'Snooker');
      expect(category.pricePerHour, 60.0);
    });

    test('getById - should return null when category does not exist', () async {
      final category = await repository.getById(999);

      expect(category, isNull);
    });
  });
}

AppDatabase _createTestDatabase() {
  return AppDatabase.forTest(NativeDatabase.memory());
}
