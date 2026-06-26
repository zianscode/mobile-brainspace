import 'package:equatable/equatable.dart';

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object?> get props => [];
}

class StartTestEvent extends TestEvent {
  final int timerSeconds;
  final String operationType;
  final String patternType;

  const StartTestEvent({
    this.timerSeconds = 300,
    this.operationType = 'addition',
    this.patternType = 'sequential',
  });

  @override
  List<Object?> get props => [timerSeconds, operationType, patternType];
}

class SubmitAnswerEvent extends TestEvent {
  final int answer;

  const SubmitAnswerEvent(this.answer);

  @override
  List<Object?> get props => [answer];
}

class TimerTickEvent extends TestEvent {
  const TimerTickEvent();
}

class NextColumnEvent extends TestEvent {
  const NextColumnEvent();
}

class FinishTestEvent extends TestEvent {
  const FinishTestEvent();
}

class ToggleMuteEvent extends TestEvent {
  const ToggleMuteEvent();
}
