import 'package:equatable/equatable.dart';

class TestResult extends Equatable {
  final int? id;
  final String playerName;
  final DateTime dateTime;
  final int totalAnswered;
  final int totalCorrect;
  final double accuracy;
  final double consistency;
  final List<ColumnIntervalResult> intervals;

  const TestResult({
    this.id,
    this.playerName = 'Anonymous',
    required this.dateTime,
    required this.totalAnswered,
    required this.totalCorrect,
    required this.accuracy,
    required this.consistency,
    required this.intervals,
  });

  TestResult copyWith({String? playerName}) {
    return TestResult(
      id: id,
      playerName: playerName ?? this.playerName,
      dateTime: dateTime,
      totalAnswered: totalAnswered,
      totalCorrect: totalCorrect,
      accuracy: accuracy,
      consistency: consistency,
      intervals: intervals,
    );
  }

  @override
  List<Object?> get props => [id, playerName, dateTime, totalAnswered, totalCorrect, accuracy, consistency, intervals];
}

class ColumnIntervalResult extends Equatable {
  final int columnIndex;
  final int totalAnswered;
  final int totalCorrect;

  const ColumnIntervalResult({
    required this.columnIndex,
    required this.totalAnswered,
    required this.totalCorrect,
  });

  @override
  List<Object?> get props => [columnIndex, totalAnswered, totalCorrect];
}
