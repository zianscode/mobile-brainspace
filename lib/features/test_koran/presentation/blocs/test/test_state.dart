import 'package:equatable/equatable.dart';
import '../../../domain/entities/test_result.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitialState extends TestState {}

class TestRunningState extends TestState {
  final List<List<int>> columnsNumbers;
  final List<List<int?>> columnsUserAnswers;
  final List<List<bool?>> columnsAnswersCorrectness;
  final int activeColumnIndex;
  final int activeIndex;
  final int columnSecondsRemaining;
  final int totalSecondsElapsed;
  final int totalColumns;
  final bool isMuted;
  final String operationType;
  final String patternType;

  const TestRunningState({
    required this.columnsNumbers,
    required this.columnsUserAnswers,
    required this.columnsAnswersCorrectness,
    required this.activeColumnIndex,
    required this.activeIndex,
    required this.columnSecondsRemaining,
    required this.totalSecondsElapsed,
    required this.totalColumns,
    required this.isMuted,
    this.operationType = 'addition',
    this.patternType = 'sequential',
  });

  TestRunningState copyWith({
    List<List<int>>? columnsNumbers,
    List<List<int?>>? columnsUserAnswers,
    List<List<bool?>>? columnsAnswersCorrectness,
    int? activeColumnIndex,
    int? activeIndex,
    int? columnSecondsRemaining,
    int? totalSecondsElapsed,
    int? totalColumns,
    bool? isMuted,
    String? operationType,
    String? patternType,
  }) {
    return TestRunningState(
      columnsNumbers: columnsNumbers ?? this.columnsNumbers,
      columnsUserAnswers: columnsUserAnswers ?? this.columnsUserAnswers,
      columnsAnswersCorrectness: columnsAnswersCorrectness ?? this.columnsAnswersCorrectness,
      activeColumnIndex: activeColumnIndex ?? this.activeColumnIndex,
      activeIndex: activeIndex ?? this.activeIndex,
      columnSecondsRemaining: columnSecondsRemaining ?? this.columnSecondsRemaining,
      totalSecondsElapsed: totalSecondsElapsed ?? this.totalSecondsElapsed,
      totalColumns: totalColumns ?? this.totalColumns,
      isMuted: isMuted ?? this.isMuted,
      operationType: operationType ?? this.operationType,
      patternType: patternType ?? this.patternType,
    );
  }

  @override
  List<Object?> get props => [
        columnsNumbers,
        columnsUserAnswers,
        columnsAnswersCorrectness,
        activeColumnIndex,
        activeIndex,
        columnSecondsRemaining,
        totalSecondsElapsed,
        totalColumns,
        isMuted,
        operationType,
        patternType,
      ];
}

class TestFinishedState extends TestState {
  final TestResult result;

  const TestFinishedState(this.result);

  @override
  List<Object?> get props => [result];
}
