// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_result_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTestResultModelCollection on Isar {
  IsarCollection<TestResultModel> get testResultModels => this.collection();
}

const TestResultModelSchema = CollectionSchema(
  name: r'TestResultModel',
  id: -1764848366642252096,
  properties: {
    r'accuracy': PropertySchema(
      id: 0,
      name: r'accuracy',
      type: IsarType.double,
    ),
    r'consistency': PropertySchema(
      id: 1,
      name: r'consistency',
      type: IsarType.double,
    ),
    r'dateTime': PropertySchema(
      id: 2,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'intervals': PropertySchema(
      id: 3,
      name: r'intervals',
      type: IsarType.objectList,
      target: r'ColumnIntervalResultModel',
    ),
    r'playerName': PropertySchema(
      id: 4,
      name: r'playerName',
      type: IsarType.string,
    ),
    r'totalAnswered': PropertySchema(
      id: 5,
      name: r'totalAnswered',
      type: IsarType.long,
    ),
    r'totalCorrect': PropertySchema(
      id: 6,
      name: r'totalCorrect',
      type: IsarType.long,
    )
  },
  estimateSize: _testResultModelEstimateSize,
  serialize: _testResultModelSerialize,
  deserialize: _testResultModelDeserialize,
  deserializeProp: _testResultModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'ColumnIntervalResultModel': ColumnIntervalResultModelSchema
  },
  getId: _testResultModelGetId,
  getLinks: _testResultModelGetLinks,
  attach: _testResultModelAttach,
  version: '3.1.0+1',
);

int _testResultModelEstimateSize(
  TestResultModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.intervals.length * 3;
  {
    final offsets = allOffsets[ColumnIntervalResultModel]!;
    for (var i = 0; i < object.intervals.length; i++) {
      final value = object.intervals[i];
      bytesCount += ColumnIntervalResultModelSchema.estimateSize(
          value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.playerName.length * 3;
  return bytesCount;
}

void _testResultModelSerialize(
  TestResultModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accuracy);
  writer.writeDouble(offsets[1], object.consistency);
  writer.writeDateTime(offsets[2], object.dateTime);
  writer.writeObjectList<ColumnIntervalResultModel>(
    offsets[3],
    allOffsets,
    ColumnIntervalResultModelSchema.serialize,
    object.intervals,
  );
  writer.writeString(offsets[4], object.playerName);
  writer.writeLong(offsets[5], object.totalAnswered);
  writer.writeLong(offsets[6], object.totalCorrect);
}

TestResultModel _testResultModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TestResultModel();
  object.accuracy = reader.readDouble(offsets[0]);
  object.consistency = reader.readDouble(offsets[1]);
  object.dateTime = reader.readDateTime(offsets[2]);
  object.id = id;
  object.intervals = reader.readObjectList<ColumnIntervalResultModel>(
        offsets[3],
        ColumnIntervalResultModelSchema.deserialize,
        allOffsets,
        ColumnIntervalResultModel(),
      ) ??
      [];
  object.playerName = reader.readString(offsets[4]);
  object.totalAnswered = reader.readLong(offsets[5]);
  object.totalCorrect = reader.readLong(offsets[6]);
  return object;
}

P _testResultModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readObjectList<ColumnIntervalResultModel>(
            offset,
            ColumnIntervalResultModelSchema.deserialize,
            allOffsets,
            ColumnIntervalResultModel(),
          ) ??
          []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _testResultModelGetId(TestResultModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _testResultModelGetLinks(TestResultModel object) {
  return [];
}

void _testResultModelAttach(
    IsarCollection<dynamic> col, Id id, TestResultModel object) {
  object.id = id;
}

extension TestResultModelQueryWhereSort
    on QueryBuilder<TestResultModel, TestResultModel, QWhere> {
  QueryBuilder<TestResultModel, TestResultModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TestResultModelQueryWhere
    on QueryBuilder<TestResultModel, TestResultModel, QWhereClause> {
  QueryBuilder<TestResultModel, TestResultModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TestResultModelQueryFilter
    on QueryBuilder<TestResultModel, TestResultModel, QFilterCondition> {
  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      accuracyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      accuracyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      accuracyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      accuracyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      consistencyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      consistencyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      consistencyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consistency',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      consistencyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consistency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      dateTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      dateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      dateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      dateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intervals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intervals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intervals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intervals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intervals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'intervals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      playerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalAnsweredEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAnswered',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalAnsweredGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAnswered',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalAnsweredLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAnswered',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalAnsweredBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAnswered',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalCorrectEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalCorrectGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalCorrectLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      totalCorrectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCorrect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TestResultModelQueryObject
    on QueryBuilder<TestResultModel, TestResultModel, QFilterCondition> {
  QueryBuilder<TestResultModel, TestResultModel, QAfterFilterCondition>
      intervalsElement(FilterQuery<ColumnIntervalResultModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'intervals');
    });
  }
}

extension TestResultModelQueryLinks
    on QueryBuilder<TestResultModel, TestResultModel, QFilterCondition> {}

extension TestResultModelQuerySortBy
    on QueryBuilder<TestResultModel, TestResultModel, QSortBy> {
  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistency', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistency', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByTotalAnswered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswered', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByTotalAnsweredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswered', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByTotalCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrect', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      sortByTotalCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrect', Sort.desc);
    });
  }
}

extension TestResultModelQuerySortThenBy
    on QueryBuilder<TestResultModel, TestResultModel, QSortThenBy> {
  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistency', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByConsistencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consistency', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByTotalAnswered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswered', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByTotalAnsweredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnswered', Sort.desc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByTotalCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrect', Sort.asc);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QAfterSortBy>
      thenByTotalCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCorrect', Sort.desc);
    });
  }
}

extension TestResultModelQueryWhereDistinct
    on QueryBuilder<TestResultModel, TestResultModel, QDistinct> {
  QueryBuilder<TestResultModel, TestResultModel, QDistinct>
      distinctByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accuracy');
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QDistinct>
      distinctByConsistency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consistency');
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QDistinct>
      distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QDistinct>
      distinctByPlayerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QDistinct>
      distinctByTotalAnswered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAnswered');
    });
  }

  QueryBuilder<TestResultModel, TestResultModel, QDistinct>
      distinctByTotalCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCorrect');
    });
  }
}

extension TestResultModelQueryProperty
    on QueryBuilder<TestResultModel, TestResultModel, QQueryProperty> {
  QueryBuilder<TestResultModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TestResultModel, double, QQueryOperations> accuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accuracy');
    });
  }

  QueryBuilder<TestResultModel, double, QQueryOperations>
      consistencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consistency');
    });
  }

  QueryBuilder<TestResultModel, DateTime, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<TestResultModel, List<ColumnIntervalResultModel>,
      QQueryOperations> intervalsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervals');
    });
  }

  QueryBuilder<TestResultModel, String, QQueryOperations> playerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerName');
    });
  }

  QueryBuilder<TestResultModel, int, QQueryOperations> totalAnsweredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAnswered');
    });
  }

  QueryBuilder<TestResultModel, int, QQueryOperations> totalCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCorrect');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ColumnIntervalResultModelSchema = Schema(
  name: r'ColumnIntervalResultModel',
  id: -6410154841449845326,
  properties: {
    r'columnIndex': PropertySchema(
      id: 0,
      name: r'columnIndex',
      type: IsarType.long,
    ),
    r'totalAnswered': PropertySchema(
      id: 1,
      name: r'totalAnswered',
      type: IsarType.long,
    ),
    r'totalCorrect': PropertySchema(
      id: 2,
      name: r'totalCorrect',
      type: IsarType.long,
    )
  },
  estimateSize: _columnIntervalResultModelEstimateSize,
  serialize: _columnIntervalResultModelSerialize,
  deserialize: _columnIntervalResultModelDeserialize,
  deserializeProp: _columnIntervalResultModelDeserializeProp,
);

int _columnIntervalResultModelEstimateSize(
  ColumnIntervalResultModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _columnIntervalResultModelSerialize(
  ColumnIntervalResultModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.columnIndex);
  writer.writeLong(offsets[1], object.totalAnswered);
  writer.writeLong(offsets[2], object.totalCorrect);
}

ColumnIntervalResultModel _columnIntervalResultModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ColumnIntervalResultModel();
  object.columnIndex = reader.readLong(offsets[0]);
  object.totalAnswered = reader.readLong(offsets[1]);
  object.totalCorrect = reader.readLong(offsets[2]);
  return object;
}

P _columnIntervalResultModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ColumnIntervalResultModelQueryFilter on QueryBuilder<
    ColumnIntervalResultModel, ColumnIntervalResultModel, QFilterCondition> {
  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> columnIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> columnIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'columnIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> columnIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'columnIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> columnIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'columnIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalAnsweredEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAnswered',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalAnsweredGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAnswered',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalAnsweredLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAnswered',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalAnsweredBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAnswered',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalCorrectEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalCorrectGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalCorrectLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<ColumnIntervalResultModel, ColumnIntervalResultModel,
      QAfterFilterCondition> totalCorrectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCorrect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ColumnIntervalResultModelQueryObject on QueryBuilder<
    ColumnIntervalResultModel, ColumnIntervalResultModel, QFilterCondition> {}
