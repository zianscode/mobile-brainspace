import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/audio/audio_service.dart';
import '../../../../../core/utils/calculation_utils.dart';
import '../../../domain/entities/test_result.dart';
import '../../../domain/usecases/save_test_result.dart';
import 'test_event.dart';
import 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  final SaveTestResult saveTestResult;
  Timer? _timer;
  final AudioService _audioService = AudioService();

  TestBloc({required this.saveTestResult}) : super(TestInitialState()) {
    on<StartTestEvent>(_onStartTest);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<TimerTickEvent>(_onTimerTick);
    on<NextColumnEvent>(_onNextColumn);
    on<FinishTestEvent>(_onFinishTest);
    on<ToggleMuteEvent>(_onToggleMute);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStartTest(StartTestEvent event, Emitter<TestState> emit) {
    _timer?.cancel();

    const digitsPerColumn = 60;
    final random = Random();

    // Derive total columns from timer duration (30s per column)
    final totalColumns = (event.timerSeconds / 30).ceil();

    // 1. Generate digits and empty answer lists for each column
    final List<List<int>> columnsNumbers = [];
    final List<List<int?>> columnsUserAnswers = [];
    final List<List<bool?>> columnsAnswersCorrectness = [];

    for (int c = 0; c < totalColumns; c++) {
      final List<int> numbers = List.generate(digitsPerColumn, (_) => random.nextInt(9) + 1);
      columnsNumbers.add(numbers);

      columnsUserAnswers.add(List.filled(digitsPerColumn - 1, null, growable: false));
      columnsAnswersCorrectness.add(List.filled(digitsPerColumn - 1, null, growable: false));
    }

    // 2. Emit initial running state
    emit(TestRunningState(
      columnsNumbers: columnsNumbers,
      columnsUserAnswers: columnsUserAnswers,
      columnsAnswersCorrectness: columnsAnswersCorrectness,
      activeColumnIndex: 0,
      activeIndex: 0,
      columnSecondsRemaining: 30,
      totalSecondsElapsed: 0,
      totalColumns: totalColumns,
      isMuted: _audioService.isMuted,
      operationType: event.operationType,
      patternType: event.patternType,
    ));

    // 3. Start ticking timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTickEvent());
    });
  }

  void _onSubmitAnswer(SubmitAnswerEvent event, Emitter<TestState> emit) {
    final currentState = state;
    if (currentState is! TestRunningState) return;

    final activeColIdx = currentState.activeColumnIndex;
    final activeIdx = currentState.activeIndex;

    final numbers = currentState.columnsNumbers[activeColIdx];
    
    // Prevent index out of bounds if the user exceeds 59 answers in 30 seconds
    if (activeIdx >= numbers.length - 1) return;

    final num1 = numbers[activeIdx];
    final num2 = numbers[activeIdx + 1];

    final int correctAnswer;
    switch (currentState.operationType) {
      case 'subtraction':
        correctAnswer = ((num1 - num2) % 10 + 10) % 10;
        break;
      case 'mixed':
        final useAddition = Random().nextBool();
        correctAnswer = useAddition
            ? (num1 + num2) % 10
            : ((num1 - num2) % 10 + 10) % 10;
        break;
      default: // 'addition'
        correctAnswer = (num1 + num2) % 10;
    }
    final isCorrect = event.answer == correctAnswer;

    // Trigger immediate low-latency audio feedback
    if (isCorrect) {
      _audioService.playCorrect();
    } else {
      _audioService.playIncorrect();
    }

    // Update user answers for the current column
    final newAnswers = currentState.columnsUserAnswers.map((list) => List<int?>.from(list)).toList();
    final newCorrectness = currentState.columnsAnswersCorrectness.map((list) => List<bool?>.from(list)).toList();

    newAnswers[activeColIdx][activeIdx] = event.answer;
    newCorrectness[activeColIdx][activeIdx] = isCorrect;

    emit(currentState.copyWith(
      columnsUserAnswers: newAnswers,
      columnsAnswersCorrectness: newCorrectness,
      activeIndex: activeIdx + 1, // Focus automatically moves up
    ));
  }

  void _onTimerTick(TimerTickEvent event, Emitter<TestState> emit) {
    final currentState = state;
    if (currentState is! TestRunningState) return;

    final newRemaining = currentState.columnSecondsRemaining - 1;
    final newTotalElapsed = currentState.totalSecondsElapsed + 1;

    if (newRemaining <= 0) {
      // 30 seconds elapsed for the active column
      if (currentState.activeColumnIndex >= currentState.totalColumns - 1) {
        // Last column finished -> end the test
        add(const FinishTestEvent());
      } else {
        // Shift focus to the next column on the right
        add(const NextColumnEvent());
      }
    } else {
      // Just update timers
      emit(currentState.copyWith(
        columnSecondsRemaining: newRemaining,
        totalSecondsElapsed: newTotalElapsed,
      ));
    }
  }

  void _onNextColumn(NextColumnEvent event, Emitter<TestState> emit) {
    final currentState = state;
    if (currentState is! TestRunningState) return;

    emit(currentState.copyWith(
      activeColumnIndex: currentState.activeColumnIndex + 1,
      activeIndex: 0, // Reset focus to the bottom of the next column
      columnSecondsRemaining: 30, // Restart 30-second interval
    ));
  }

  Future<void> _onFinishTest(FinishTestEvent event, Emitter<TestState> emit) async {
    final currentState = state;
    if (currentState is! TestRunningState) return;

    _timer?.cancel();

    // 1. Calculate final metrics
    int totalAnswered = 0;
    int totalCorrect = 0;
    final List<int> answeredPerColumn = [];
    final List<ColumnIntervalResult> intervals = [];

    for (int c = 0; c < currentState.totalColumns; c++) {
      final answers = currentState.columnsUserAnswers[c];
      final correctness = currentState.columnsAnswersCorrectness[c];

      int columnAnswered = 0;
      int columnCorrect = 0;

      for (int i = 0; i < answers.length; i++) {
        if (answers[i] != null) {
          columnAnswered++;
          if (correctness[i] == true) {
            columnCorrect++;
          }
        }
      }

      totalAnswered += columnAnswered;
      totalCorrect += columnCorrect;
      answeredPerColumn.add(columnAnswered);

      intervals.add(ColumnIntervalResult(
        columnIndex: c,
        totalAnswered: columnAnswered,
        totalCorrect: columnCorrect,
      ));
    }

    final accuracy = CalculationUtils.calculateAccuracy(
      totalCorrect: totalCorrect,
      totalAnswered: totalAnswered,
    );

    final consistency = CalculationUtils.calculateConsistency(answeredPerColumn);

    // 2. Create result (saved later in ResultScreen with player name)
    final testResult = TestResult(
      dateTime: DateTime.now(),
      totalAnswered: totalAnswered,
      totalCorrect: totalCorrect,
      accuracy: accuracy,
      consistency: consistency,
      intervals: intervals,
    );

    // 3. Transition to finished state
    emit(TestFinishedState(testResult));
  }

  void _onToggleMute(ToggleMuteEvent event, Emitter<TestState> emit) {
    final currentState = state;
    final isMuted = _audioService.toggleMute();

    if (currentState is TestRunningState) {
      emit(currentState.copyWith(isMuted: isMuted));
    }
  }
}
