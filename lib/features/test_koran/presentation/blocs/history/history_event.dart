import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class ClearHistoryEvent extends HistoryEvent {}

class DeleteSelectedHistoryEvent extends HistoryEvent {
  final List<int> ids;

  const DeleteSelectedHistoryEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}
