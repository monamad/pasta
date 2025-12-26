import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/session_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Category, GameTable, Session],
  daos: [CategoryDao, TableDao, SessionDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTest(super.executor);

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  @override
  int get schemaVersion => 1;
}

@DataClassName('CategoryData')
class Category extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get pricePerHour => real()();
}

@DataClassName('GameTableData')
class GameTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get categoryId => integer().references(Category, #id)();
  BoolColumn get isOccupied => boolean().withDefault(Constant(false))();
}

@DataClassName('SessionData')
class Session extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get tableId => integer().references(GameTable, #id)();

  DateTimeColumn get startTime => dateTime()();

  DateTimeColumn get expectedEndTime => dateTime().nullable()();
  DateTimeColumn get actualEndTime => dateTime().nullable()();
  RealColumn get totalPrice => real().nullable()();
  RealColumn get hourPrice => real()();

  TextColumn get status => text()
      .map(const SessionStatusConverter())
      .withDefault(Constant(SessionStatus.done.name))();
}

enum SessionStatus { done, occupied, reserved }

class SessionStatusConverter extends TypeConverter<SessionStatus, String> {
  const SessionStatusConverter();

  @override
  SessionStatus fromSql(String fromDb) {
    return SessionStatus.values.firstWhere((e) => e.name == fromDb);
  }

  @override
  String toSql(SessionStatus value) {
    return value.name;
  }
}
