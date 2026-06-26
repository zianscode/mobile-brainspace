import 'package:equatable/equatable.dart';
import '../../../domain/entities/test_result.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitialState extends HistoryState {}

class HistoryLoadingState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<TestResult> history;

  const HistoryLoadedState(this.history);

  @override
  List<Object?> get props => [history];
}

class HistoryErrorState extends HistoryState {
  final String message;

  const HistoryErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
