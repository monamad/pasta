// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoryTable extends Category
    with TableInfo<$CategoryTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerHourMeta = const VerificationMeta(
    'pricePerHour',
  );
  @override
  late final GeneratedColumn<double> pricePerHour = GeneratedColumn<double>(
    'price_per_hour',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, pricePerHour];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_per_hour')) {
      context.handle(
        _pricePerHourMeta,
        pricePerHour.isAcceptableOrUnknown(
          data['price_per_hour']!,
          _pricePerHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerHourMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pricePerHour: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_hour'],
      )!,
    );
  }

  @override
  $CategoryTable createAlias(String alias) {
    return $CategoryTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  final int id;
  final String name;
  final double pricePerHour;
  const CategoryData({
    required this.id,
    required this.name,
    required this.pricePerHour,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price_per_hour'] = Variable<double>(pricePerHour);
    return map;
  }

  CategoryCompanion toCompanion(bool nullToAbsent) {
    return CategoryCompanion(
      id: Value(id),
      name: Value(name),
      pricePerHour: Value(pricePerHour),
    );
  }

  factory CategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pricePerHour: serializer.fromJson<double>(json['pricePerHour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'pricePerHour': serializer.toJson<double>(pricePerHour),
    };
  }

  CategoryData copyWith({int? id, String? name, double? pricePerHour}) =>
      CategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        pricePerHour: pricePerHour ?? this.pricePerHour,
      );
  CategoryData copyWithCompanion(CategoryCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pricePerHour: data.pricePerHour.present
          ? data.pricePerHour.value
          : this.pricePerHour,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pricePerHour: $pricePerHour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, pricePerHour);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.pricePerHour == this.pricePerHour);
}

class CategoryCompanion extends UpdateCompanion<CategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> pricePerHour;
  const CategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pricePerHour = const Value.absent(),
  });
  CategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double pricePerHour,
  }) : name = Value(name),
       pricePerHour = Value(pricePerHour);
  static Insertable<CategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? pricePerHour,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pricePerHour != null) 'price_per_hour': pricePerHour,
    });
  }

  CategoryCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? pricePerHour,
  }) {
    return CategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pricePerHour: pricePerHour ?? this.pricePerHour,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pricePerHour.present) {
      map['price_per_hour'] = Variable<double>(pricePerHour.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pricePerHour: $pricePerHour')
          ..write(')'))
        .toString();
  }
}

class $GameTableTable extends GameTable
    with TableInfo<$GameTableTable, GameTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category (id)',
    ),
  );
  static const VerificationMeta _isOccupiedMeta = const VerificationMeta(
    'isOccupied',
  );
  @override
  late final GeneratedColumn<bool> isOccupied = GeneratedColumn<bool>(
    'is_occupied',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_occupied" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, categoryId, isOccupied];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('is_occupied')) {
      context.handle(
        _isOccupiedMeta,
        isOccupied.isAcceptableOrUnknown(data['is_occupied']!, _isOccupiedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      isOccupied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_occupied'],
      )!,
    );
  }

  @override
  $GameTableTable createAlias(String alias) {
    return $GameTableTable(attachedDatabase, alias);
  }
}

class GameTableData extends DataClass implements Insertable<GameTableData> {
  final int id;
  final String name;
  final int categoryId;
  final bool isOccupied;
  const GameTableData({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.isOccupied,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<int>(categoryId);
    map['is_occupied'] = Variable<bool>(isOccupied);
    return map;
  }

  GameTableCompanion toCompanion(bool nullToAbsent) {
    return GameTableCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
      isOccupied: Value(isOccupied),
    );
  }

  factory GameTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      isOccupied: serializer.fromJson<bool>(json['isOccupied']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
      'isOccupied': serializer.toJson<bool>(isOccupied),
    };
  }

  GameTableData copyWith({
    int? id,
    String? name,
    int? categoryId,
    bool? isOccupied,
  }) => GameTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    isOccupied: isOccupied ?? this.isOccupied,
  );
  GameTableData copyWithCompanion(GameTableCompanion data) {
    return GameTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isOccupied: data.isOccupied.present
          ? data.isOccupied.value
          : this.isOccupied,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('isOccupied: $isOccupied')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, categoryId, isOccupied);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.isOccupied == this.isOccupied);
}

class GameTableCompanion extends UpdateCompanion<GameTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> categoryId;
  final Value<bool> isOccupied;
  const GameTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isOccupied = const Value.absent(),
  });
  GameTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int categoryId,
    this.isOccupied = const Value.absent(),
  }) : name = Value(name),
       categoryId = Value(categoryId);
  static Insertable<GameTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? categoryId,
    Expression<bool>? isOccupied,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (isOccupied != null) 'is_occupied': isOccupied,
    });
  }

  GameTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? categoryId,
    Value<bool>? isOccupied,
  }) {
    return GameTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isOccupied.present) {
      map['is_occupied'] = Variable<bool>(isOccupied.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('isOccupied: $isOccupied')
          ..write(')'))
        .toString();
  }
}

class $SessionTable extends Session with TableInfo<$SessionTable, SessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tableIdMeta = const VerificationMeta(
    'tableId',
  );
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
    'table_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES game_table (id)',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedEndTimeMeta = const VerificationMeta(
    'expectedEndTime',
  );
  @override
  late final GeneratedColumn<DateTime> expectedEndTime =
      GeneratedColumn<DateTime>(
        'expected_end_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actualEndTimeMeta = const VerificationMeta(
    'actualEndTime',
  );
  @override
  late final GeneratedColumn<DateTime> actualEndTime =
      GeneratedColumn<DateTime>(
        'actual_end_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalPriceMeta = const VerificationMeta(
    'totalPrice',
  );
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
    'total_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourPriceMeta = const VerificationMeta(
    'hourPrice',
  );
  @override
  late final GeneratedColumn<double> hourPrice = GeneratedColumn<double>(
    'hour_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SessionStatus.done.name),
      ).withConverter<SessionStatus>($SessionTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableId,
    startTime,
    expectedEndTime,
    actualEndTime,
    totalPrice,
    hourPrice,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_id')) {
      context.handle(
        _tableIdMeta,
        tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tableIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('expected_end_time')) {
      context.handle(
        _expectedEndTimeMeta,
        expectedEndTime.isAcceptableOrUnknown(
          data['expected_end_time']!,
          _expectedEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('actual_end_time')) {
      context.handle(
        _actualEndTimeMeta,
        actualEndTime.isAcceptableOrUnknown(
          data['actual_end_time']!,
          _actualEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('total_price')) {
      context.handle(
        _totalPriceMeta,
        totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta),
      );
    }
    if (data.containsKey('hour_price')) {
      context.handle(
        _hourPriceMeta,
        hourPrice.isAcceptableOrUnknown(data['hour_price']!, _hourPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_hourPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      expectedEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expected_end_time'],
      ),
      actualEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_end_time'],
      ),
      totalPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_price'],
      ),
      hourPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hour_price'],
      )!,
      status: $SessionTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $SessionTable createAlias(String alias) {
    return $SessionTable(attachedDatabase, alias);
  }

  static TypeConverter<SessionStatus, String> $converterstatus =
      const SessionStatusConverter();
}

class SessionData extends DataClass implements Insertable<SessionData> {
  final int id;
  final int tableId;
  final DateTime startTime;
  final DateTime? expectedEndTime;
  final DateTime? actualEndTime;
  final double? totalPrice;
  final double hourPrice;
  final SessionStatus status;
  const SessionData({
    required this.id,
    required this.tableId,
    required this.startTime,
    this.expectedEndTime,
    this.actualEndTime,
    this.totalPrice,
    required this.hourPrice,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_id'] = Variable<int>(tableId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || expectedEndTime != null) {
      map['expected_end_time'] = Variable<DateTime>(expectedEndTime);
    }
    if (!nullToAbsent || actualEndTime != null) {
      map['actual_end_time'] = Variable<DateTime>(actualEndTime);
    }
    if (!nullToAbsent || totalPrice != null) {
      map['total_price'] = Variable<double>(totalPrice);
    }
    map['hour_price'] = Variable<double>(hourPrice);
    {
      map['status'] = Variable<String>(
        $SessionTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  SessionCompanion toCompanion(bool nullToAbsent) {
    return SessionCompanion(
      id: Value(id),
      tableId: Value(tableId),
      startTime: Value(startTime),
      expectedEndTime: expectedEndTime == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedEndTime),
      actualEndTime: actualEndTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualEndTime),
      totalPrice: totalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPrice),
      hourPrice: Value(hourPrice),
      status: Value(status),
    );
  }

  factory SessionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionData(
      id: serializer.fromJson<int>(json['id']),
      tableId: serializer.fromJson<int>(json['tableId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      expectedEndTime: serializer.fromJson<DateTime?>(json['expectedEndTime']),
      actualEndTime: serializer.fromJson<DateTime?>(json['actualEndTime']),
      totalPrice: serializer.fromJson<double?>(json['totalPrice']),
      hourPrice: serializer.fromJson<double>(json['hourPrice']),
      status: serializer.fromJson<SessionStatus>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tableId': serializer.toJson<int>(tableId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'expectedEndTime': serializer.toJson<DateTime?>(expectedEndTime),
      'actualEndTime': serializer.toJson<DateTime?>(actualEndTime),
      'totalPrice': serializer.toJson<double?>(totalPrice),
      'hourPrice': serializer.toJson<double>(hourPrice),
      'status': serializer.toJson<SessionStatus>(status),
    };
  }

  SessionData copyWith({
    int? id,
    int? tableId,
    DateTime? startTime,
    Value<DateTime?> expectedEndTime = const Value.absent(),
    Value<DateTime?> actualEndTime = const Value.absent(),
    Value<double?> totalPrice = const Value.absent(),
    double? hourPrice,
    SessionStatus? status,
  }) => SessionData(
    id: id ?? this.id,
    tableId: tableId ?? this.tableId,
    startTime: startTime ?? this.startTime,
    expectedEndTime: expectedEndTime.present
        ? expectedEndTime.value
        : this.expectedEndTime,
    actualEndTime: actualEndTime.present
        ? actualEndTime.value
        : this.actualEndTime,
    totalPrice: totalPrice.present ? totalPrice.value : this.totalPrice,
    hourPrice: hourPrice ?? this.hourPrice,
    status: status ?? this.status,
  );
  SessionData copyWithCompanion(SessionCompanion data) {
    return SessionData(
      id: data.id.present ? data.id.value : this.id,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      expectedEndTime: data.expectedEndTime.present
          ? data.expectedEndTime.value
          : this.expectedEndTime,
      actualEndTime: data.actualEndTime.present
          ? data.actualEndTime.value
          : this.actualEndTime,
      totalPrice: data.totalPrice.present
          ? data.totalPrice.value
          : this.totalPrice,
      hourPrice: data.hourPrice.present ? data.hourPrice.value : this.hourPrice,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionData(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('startTime: $startTime, ')
          ..write('expectedEndTime: $expectedEndTime, ')
          ..write('actualEndTime: $actualEndTime, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('hourPrice: $hourPrice, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tableId,
    startTime,
    expectedEndTime,
    actualEndTime,
    totalPrice,
    hourPrice,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionData &&
          other.id == this.id &&
          other.tableId == this.tableId &&
          other.startTime == this.startTime &&
          other.expectedEndTime == this.expectedEndTime &&
          other.actualEndTime == this.actualEndTime &&
          other.totalPrice == this.totalPrice &&
          other.hourPrice == this.hourPrice &&
          other.status == this.status);
}

class SessionCompanion extends UpdateCompanion<SessionData> {
  final Value<int> id;
  final Value<int> tableId;
  final Value<DateTime> startTime;
  final Value<DateTime?> expectedEndTime;
  final Value<DateTime?> actualEndTime;
  final Value<double?> totalPrice;
  final Value<double> hourPrice;
  final Value<SessionStatus> status;
  const SessionCompanion({
    this.id = const Value.absent(),
    this.tableId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.expectedEndTime = const Value.absent(),
    this.actualEndTime = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.hourPrice = const Value.absent(),
    this.status = const Value.absent(),
  });
  SessionCompanion.insert({
    this.id = const Value.absent(),
    required int tableId,
    required DateTime startTime,
    this.expectedEndTime = const Value.absent(),
    this.actualEndTime = const Value.absent(),
    this.totalPrice = const Value.absent(),
    required double hourPrice,
    this.status = const Value.absent(),
  }) : tableId = Value(tableId),
       startTime = Value(startTime),
       hourPrice = Value(hourPrice);
  static Insertable<SessionData> custom({
    Expression<int>? id,
    Expression<int>? tableId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? expectedEndTime,
    Expression<DateTime>? actualEndTime,
    Expression<double>? totalPrice,
    Expression<double>? hourPrice,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableId != null) 'table_id': tableId,
      if (startTime != null) 'start_time': startTime,
      if (expectedEndTime != null) 'expected_end_time': expectedEndTime,
      if (actualEndTime != null) 'actual_end_time': actualEndTime,
      if (totalPrice != null) 'total_price': totalPrice,
      if (hourPrice != null) 'hour_price': hourPrice,
      if (status != null) 'status': status,
    });
  }

  SessionCompanion copyWith({
    Value<int>? id,
    Value<int>? tableId,
    Value<DateTime>? startTime,
    Value<DateTime?>? expectedEndTime,
    Value<DateTime?>? actualEndTime,
    Value<double?>? totalPrice,
    Value<double>? hourPrice,
    Value<SessionStatus>? status,
  }) {
    return SessionCompanion(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      startTime: startTime ?? this.startTime,
      expectedEndTime: expectedEndTime ?? this.expectedEndTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      totalPrice: totalPrice ?? this.totalPrice,
      hourPrice: hourPrice ?? this.hourPrice,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (expectedEndTime.present) {
      map['expected_end_time'] = Variable<DateTime>(expectedEndTime.value);
    }
    if (actualEndTime.present) {
      map['actual_end_time'] = Variable<DateTime>(actualEndTime.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (hourPrice.present) {
      map['hour_price'] = Variable<double>(hourPrice.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SessionTable.$converterstatus.toSql(status.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionCompanion(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('startTime: $startTime, ')
          ..write('expectedEndTime: $expectedEndTime, ')
          ..write('actualEndTime: $actualEndTime, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('hourPrice: $hourPrice, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryTable category = $CategoryTable(this);
  late final $GameTableTable gameTable = $GameTableTable(this);
  late final $SessionTable session = $SessionTable(this);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final TableDao tableDao = TableDao(this as AppDatabase);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    category,
    gameTable,
    session,
  ];
}

typedef $$CategoryTableCreateCompanionBuilder =
    CategoryCompanion Function({
      Value<int> id,
      required String name,
      required double pricePerHour,
    });
typedef $$CategoryTableUpdateCompanionBuilder =
    CategoryCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> pricePerHour,
    });

final class $$CategoryTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryTable, CategoryData> {
  $$CategoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GameTableTable, List<GameTableData>>
  _gameTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gameTable,
    aliasName: $_aliasNameGenerator(db.category.id, db.gameTable.categoryId),
  );

  $$GameTableTableProcessedTableManager get gameTableRefs {
    final manager = $$GameTableTableTableManager(
      $_db,
      $_db.gameTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gameTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoryTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerHour => $composableBuilder(
    column: $table.pricePerHour,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gameTableRefs(
    Expression<bool> Function($$GameTableTableFilterComposer f) f,
  ) {
    final $$GameTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableFilterComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerHour => $composableBuilder(
    column: $table.pricePerHour,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryTable> {
  $$CategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get pricePerHour => $composableBuilder(
    column: $table.pricePerHour,
    builder: (column) => column,
  );

  Expression<T> gameTableRefs<T extends Object>(
    Expression<T> Function($$GameTableTableAnnotationComposer a) f,
  ) {
    final $$GameTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableAnnotationComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryTable,
          CategoryData,
          $$CategoryTableFilterComposer,
          $$CategoryTableOrderingComposer,
          $$CategoryTableAnnotationComposer,
          $$CategoryTableCreateCompanionBuilder,
          $$CategoryTableUpdateCompanionBuilder,
          (CategoryData, $$CategoryTableReferences),
          CategoryData,
          PrefetchHooks Function({bool gameTableRefs})
        > {
  $$CategoryTableTableManager(_$AppDatabase db, $CategoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> pricePerHour = const Value.absent(),
              }) => CategoryCompanion(
                id: id,
                name: name,
                pricePerHour: pricePerHour,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double pricePerHour,
              }) => CategoryCompanion.insert(
                id: id,
                name: name,
                pricePerHour: pricePerHour,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gameTableRefs) db.gameTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gameTableRefs)
                    await $_getPrefetchedData<
                      CategoryData,
                      $CategoryTable,
                      GameTableData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoryTableReferences
                          ._gameTableRefsTable(db),
                      managerFromTypedResult: (p0) => $$CategoryTableReferences(
                        db,
                        table,
                        p0,
                      ).gameTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryTable,
      CategoryData,
      $$CategoryTableFilterComposer,
      $$CategoryTableOrderingComposer,
      $$CategoryTableAnnotationComposer,
      $$CategoryTableCreateCompanionBuilder,
      $$CategoryTableUpdateCompanionBuilder,
      (CategoryData, $$CategoryTableReferences),
      CategoryData,
      PrefetchHooks Function({bool gameTableRefs})
    >;
typedef $$GameTableTableCreateCompanionBuilder =
    GameTableCompanion Function({
      Value<int> id,
      required String name,
      required int categoryId,
      Value<bool> isOccupied,
    });
typedef $$GameTableTableUpdateCompanionBuilder =
    GameTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> categoryId,
      Value<bool> isOccupied,
    });

final class $$GameTableTableReferences
    extends BaseReferences<_$AppDatabase, $GameTableTable, GameTableData> {
  $$GameTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTable _categoryIdTable(_$AppDatabase db) =>
      db.category.createAlias(
        $_aliasNameGenerator(db.gameTable.categoryId, db.category.id),
      );

  $$CategoryTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoryTableTableManager(
      $_db,
      $_db.category,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionTable, List<SessionData>>
  _sessionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.session,
    aliasName: $_aliasNameGenerator(db.gameTable.id, db.session.tableId),
  );

  $$SessionTableProcessedTableManager get sessionRefs {
    final manager = $$SessionTableTableManager(
      $_db,
      $_db.session,
    ).filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GameTableTableFilterComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOccupied => $composableBuilder(
    column: $table.isOccupied,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoryTableFilterComposer get categoryId {
    final $$CategoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTableFilterComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionRefs(
    Expression<bool> Function($$SessionTableFilterComposer f) f,
  ) {
    final $$SessionTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.session,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableFilterComposer(
            $db: $db,
            $table: $db.session,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOccupied => $composableBuilder(
    column: $table.isOccupied,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoryTableOrderingComposer get categoryId {
    final $$CategoryTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTableOrderingComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isOccupied => $composableBuilder(
    column: $table.isOccupied,
    builder: (column) => column,
  );

  $$CategoryTableAnnotationComposer get categoryId {
    final $$CategoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.category,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTableAnnotationComposer(
            $db: $db,
            $table: $db.category,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionRefs<T extends Object>(
    Expression<T> Function($$SessionTableAnnotationComposer a) f,
  ) {
    final $$SessionTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.session,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionTableAnnotationComposer(
            $db: $db,
            $table: $db.session,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GameTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameTableTable,
          GameTableData,
          $$GameTableTableFilterComposer,
          $$GameTableTableOrderingComposer,
          $$GameTableTableAnnotationComposer,
          $$GameTableTableCreateCompanionBuilder,
          $$GameTableTableUpdateCompanionBuilder,
          (GameTableData, $$GameTableTableReferences),
          GameTableData,
          PrefetchHooks Function({bool categoryId, bool sessionRefs})
        > {
  $$GameTableTableTableManager(_$AppDatabase db, $GameTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<bool> isOccupied = const Value.absent(),
              }) => GameTableCompanion(
                id: id,
                name: name,
                categoryId: categoryId,
                isOccupied: isOccupied,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int categoryId,
                Value<bool> isOccupied = const Value.absent(),
              }) => GameTableCompanion.insert(
                id: id,
                name: name,
                categoryId: categoryId,
                isOccupied: isOccupied,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GameTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, sessionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionRefs) db.session],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$GameTableTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$GameTableTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionRefs)
                    await $_getPrefetchedData<
                      GameTableData,
                      $GameTableTable,
                      SessionData
                    >(
                      currentTable: table,
                      referencedTable: $$GameTableTableReferences
                          ._sessionRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GameTableTableReferences(db, table, p0).sessionRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tableId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GameTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameTableTable,
      GameTableData,
      $$GameTableTableFilterComposer,
      $$GameTableTableOrderingComposer,
      $$GameTableTableAnnotationComposer,
      $$GameTableTableCreateCompanionBuilder,
      $$GameTableTableUpdateCompanionBuilder,
      (GameTableData, $$GameTableTableReferences),
      GameTableData,
      PrefetchHooks Function({bool categoryId, bool sessionRefs})
    >;
typedef $$SessionTableCreateCompanionBuilder =
    SessionCompanion Function({
      Value<int> id,
      required int tableId,
      required DateTime startTime,
      Value<DateTime?> expectedEndTime,
      Value<DateTime?> actualEndTime,
      Value<double?> totalPrice,
      required double hourPrice,
      Value<SessionStatus> status,
    });
typedef $$SessionTableUpdateCompanionBuilder =
    SessionCompanion Function({
      Value<int> id,
      Value<int> tableId,
      Value<DateTime> startTime,
      Value<DateTime?> expectedEndTime,
      Value<DateTime?> actualEndTime,
      Value<double?> totalPrice,
      Value<double> hourPrice,
      Value<SessionStatus> status,
    });

final class $$SessionTableReferences
    extends BaseReferences<_$AppDatabase, $SessionTable, SessionData> {
  $$SessionTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GameTableTable _tableIdTable(_$AppDatabase db) => db.gameTable
      .createAlias($_aliasNameGenerator(db.session.tableId, db.gameTable.id));

  $$GameTableTableProcessedTableManager get tableId {
    final $_column = $_itemColumn<int>('table_id')!;

    final manager = $$GameTableTableTableManager(
      $_db,
      $_db.gameTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionTableFilterComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expectedEndTime => $composableBuilder(
    column: $table.expectedEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualEndTime => $composableBuilder(
    column: $table.actualEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourPrice => $composableBuilder(
    column: $table.hourPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$GameTableTableFilterComposer get tableId {
    final $$GameTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableFilterComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expectedEndTime => $composableBuilder(
    column: $table.expectedEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualEndTime => $composableBuilder(
    column: $table.actualEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourPrice => $composableBuilder(
    column: $table.hourPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$GameTableTableOrderingComposer get tableId {
    final $$GameTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableOrderingComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedEndTime => $composableBuilder(
    column: $table.expectedEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualEndTime => $composableBuilder(
    column: $table.actualEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalPrice => $composableBuilder(
    column: $table.totalPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hourPrice =>
      $composableBuilder(column: $table.hourPrice, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$GameTableTableAnnotationComposer get tableId {
    final $$GameTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.gameTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTableTableAnnotationComposer(
            $db: $db,
            $table: $db.gameTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionTable,
          SessionData,
          $$SessionTableFilterComposer,
          $$SessionTableOrderingComposer,
          $$SessionTableAnnotationComposer,
          $$SessionTableCreateCompanionBuilder,
          $$SessionTableUpdateCompanionBuilder,
          (SessionData, $$SessionTableReferences),
          SessionData,
          PrefetchHooks Function({bool tableId})
        > {
  $$SessionTableTableManager(_$AppDatabase db, $SessionTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tableId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> expectedEndTime = const Value.absent(),
                Value<DateTime?> actualEndTime = const Value.absent(),
                Value<double?> totalPrice = const Value.absent(),
                Value<double> hourPrice = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
              }) => SessionCompanion(
                id: id,
                tableId: tableId,
                startTime: startTime,
                expectedEndTime: expectedEndTime,
                actualEndTime: actualEndTime,
                totalPrice: totalPrice,
                hourPrice: hourPrice,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tableId,
                required DateTime startTime,
                Value<DateTime?> expectedEndTime = const Value.absent(),
                Value<DateTime?> actualEndTime = const Value.absent(),
                Value<double?> totalPrice = const Value.absent(),
                required double hourPrice,
                Value<SessionStatus> status = const Value.absent(),
              }) => SessionCompanion.insert(
                id: id,
                tableId: tableId,
                startTime: startTime,
                expectedEndTime: expectedEndTime,
                actualEndTime: actualEndTime,
                totalPrice: totalPrice,
                hourPrice: hourPrice,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tableId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tableId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tableId,
                                referencedTable: $$SessionTableReferences
                                    ._tableIdTable(db),
                                referencedColumn: $$SessionTableReferences
                                    ._tableIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionTable,
      SessionData,
      $$SessionTableFilterComposer,
      $$SessionTableOrderingComposer,
      $$SessionTableAnnotationComposer,
      $$SessionTableCreateCompanionBuilder,
      $$SessionTableUpdateCompanionBuilder,
      (SessionData, $$SessionTableReferences),
      SessionData,
      PrefetchHooks Function({bool tableId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryTableTableManager get category =>
      $$CategoryTableTableManager(_db, _db.category);
  $$GameTableTableTableManager get gameTable =>
      $$GameTableTableTableManager(_db, _db.gameTable);
  $$SessionTableTableManager get session =>
      $$SessionTableTableManager(_db, _db.session);
}
