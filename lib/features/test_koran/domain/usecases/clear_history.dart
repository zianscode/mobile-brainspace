import '../repositories/test_repository.dart';

class ClearHistory {
  final TestRepository repository;

  ClearHistory(this.repository);

  Future<void> call() {
    return repository.clearHistory();
  }
}
