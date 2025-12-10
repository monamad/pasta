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
    test('addTable - should insert new table', () async {
      final categoryId = await _createCategory(db, 'Console', 50.0);

      final id = await repository.addTable('Console 1', categoryId);

      expect(id, greaterThan(0));
      final table = await repository.getById(id);
      expect(table, isNotNull);
      expect(table!.name, 'Console 1');
      expect(table.categoryId, categoryId);
    });

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

    test('getById - should return table when exists', () async {
      final categoryId = await _createCategory(db, 'Snooker', 60.0);
      final id = await repository.addTable('Snooker 1', categoryId);

      final table = await repository.getById(id);

      expect(table, isNotNull);
      expect(table!.id, id);
      expect(table.name, 'Snooker 1');
      expect(table.categoryId, categoryId);
    });

    test('getById - should return null when table does not exist', () async {
      final table = await repository.getById(999);

      expect(table, isNull);
    });

    test(
      'getByCategory - should return tables for specific category',
      () async {
        final consoleId = await _createCategory(db, 'Console', 50.0);
        final billiardId = await _createCategory(db, 'Billiard', 40.0);

        await repository.addTable('Console 1', consoleId);
        await repository.addTable('Console 2', consoleId);
        await repository.addTable('Billiard 1', billiardId);

        final consoleTables = await repository.getByCategory(consoleId);

        expect(consoleTables.length, 2);
        expect(consoleTables.every((t) => t.categoryId == consoleId), isTrue);
      },
    );

    test(
      'getByCategory - should return empty list when no tables for category',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);

        final tables = await repository.getByCategory(categoryId);

        expect(tables, isEmpty);
      },
    );

    test(
      'getAvailableByCategory - should return only tables without active sessions',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId1 = await repository.addTable('Console 1', categoryId);
        final tableId2 = await repository.addTable('Console 2', categoryId);

        await _createSession(db, tableId1);

        final availableTables = await repository.getAvailableByCategory(
          categoryId,
        );

        expect(availableTables.length, 1);
        expect(availableTables[0].id, tableId2);
      },
    );

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

    test(
      'getBusyTables - should return only tables with active sessions',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        final tableId1 = await repository.addTable('Console 1', categoryId);
        final tableId2 = await repository.addTable('Console 2', categoryId);
        await repository.addTable('Console 3', categoryId);

        await _createSession(db, tableId1);
        await _createSession(db, tableId2);

        final busyTables = await repository.getBusyTables();

        expect(busyTables.length, 2);
        expect(busyTables.map((t) => t.id), containsAll([tableId1, tableId2]));
      },
    );

    test(
      'getBusyTables - should return empty list when no active sessions',
      () async {
        final categoryId = await _createCategory(db, 'Console', 50.0);
        await repository.addTable('Console 1', categoryId);

        final busyTables = await repository.getBusyTables();

        expect(busyTables, isEmpty);
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

Future<int> _createSession(AppDatabase db, int tableId) async {
  return await db.sessionDao.createNewSession(tableId: tableId);
}
