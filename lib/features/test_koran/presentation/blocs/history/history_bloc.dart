import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_test_history.dart';
import '../../../domain/usecases/clear_history.dart';
import '../../../domain/usecases/delete_history_items.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetTestHistory getTestHistory;
  final ClearHistory clearHistoryUsecase;
  final DeleteHistoryItems deleteHistoryItems;

  HistoryBloc({
    required this.getTestHistory,
    required this.clearHistoryUsecase,
    required this.deleteHistoryItems,
  }) : super(HistoryInitialState()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<ClearHistoryEvent>(_onClearHistory);
    on<DeleteSelectedHistoryEvent>(_onDeleteSelected);
  }

  Future<void> _onLoadHistory(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoadingState());
    try {
      final history = await getTestHistory();
      emit(HistoryLoadedState(history));
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> _onClearHistory(ClearHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoadingState());
    try {
      await clearHistoryUsecase();
      emit(const HistoryLoadedState([]));
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteSelected(DeleteSelectedHistoryEvent event, Emitter<HistoryState> emit) async {
    final currentState = state;
    if (currentState is! HistoryLoadedState) return;
    try {
      await deleteHistoryItems(event.ids);
      final remaining = currentState.history.where((h) => !event.ids.contains(h.id)).toList();
      emit(HistoryLoadedState(remaining));
    } catch (e) {
      emit(HistoryErrorState(e.toString()));
    }
  }
}
