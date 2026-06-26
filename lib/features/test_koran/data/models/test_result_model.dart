import 'package:isar/isar.dart';
import '../../domain/entities/test_result.dart';

part 'test_result_model.g.dart';

@collection
class TestResultModel {
  Id id = Isar.autoIncrement;

  late DateTime dateTime;
  late int totalAnswered;
  late int totalCorrect;
  late double accuracy;
  late double consistency;
  late String playerName;
  late List<ColumnIntervalResultModel> intervals;

  TestResult toEntity() {
    return TestResult(
      id: id,
      playerName: playerName,
      dateTime: dateTime,
      totalAnswered: totalAnswered,
      totalCorrect: totalCorrect,
      accuracy: accuracy,
      consistency: consistency,
      intervals: intervals.map((i) => i.toEntity()).toList(),
    );
  }

  static TestResultModel fromEntity(TestResult entity) {
    final model = TestResultModel()
      ..dateTime = entity.dateTime
      ..playerName = entity.playerName
      ..totalAnswered = entity.totalAnswered
      ..totalCorrect = entity.totalCorrect
      ..accuracy = entity.accuracy
      ..consistency = entity.consistency
      ..intervals = entity.intervals.map((i) => ColumnIntervalResultModel.fromEntity(i)).toList();
    if (entity.id != null) {
      model.id = entity.id!;
    }
    return model;
  }
}

@embedded
class ColumnIntervalResultModel {
  late int columnIndex;
  late int totalAnswered;
  late int totalCorrect;

  ColumnIntervalResult toEntity() {
    return ColumnIntervalResult(
      columnIndex: columnIndex,
      totalAnswered: totalAnswered,
      totalCorrect: totalCorrect,
    );
  }

  static ColumnIntervalResultModel fromEntity(ColumnIntervalResult entity) {
    return ColumnIntervalResultModel()
      ..columnIndex = entity.columnIndex
      ..totalAnswered = entity.totalAnswered
      ..totalCorrect = entity.totalCorrect;
  }
}
