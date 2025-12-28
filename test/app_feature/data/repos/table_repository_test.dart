import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';

void main() {
  late AppDatabase db;
  late TableRepository repository;

  setUp(() {
    db = _createTestDatabase();
    repository = TableRepository(db.tableDao);
  });

  tearDown(() async {
    await db.close();
  });

  group('TableRepository', () {
    test('getAll - should return all tables', () async {
      final categoryId1 = await _createCategory(db, 'Console', 50.0);
      final categoryId2 = await _createCategory(db, 'Billiard', 40.0);

      await repository.addTable('Console 1', categoryId1);
      await repository.addTable('Console 2', categoryId1);
      await repository.addTable('Billiard 1', categoryId2);

      final tables = await repository.getAll();

      expect(tables.length, 3);
      expect(
        tables.map((t) => t.name),
        containsAll(['Console 1', 'Console 2', 'Billiard 1']),
      );
    });

    test('getAll - should return empty list when no tables', () async {
      final tables = await repository.getAll();

      expect(tables, isEmpty);
    });

    test(
      'getAvailableByCategory - should return all tables when none are busy',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        await repository.addTable('Console 1', categoryId);
        await repository.addTable('Console 2', categoryId);

        final availableTables = await repository.getAvailableByCategory(
          categoryId,
        );

        expect(availableTables.length, 2);
      },
    );
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


