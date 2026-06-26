import '../repositories/test_repository.dart';

class DeleteHistoryItems {
  final TestRepository repository;

  DeleteHistoryItems(this.repository);

  Future<void> call(List<int> ids) {
    return repository.deleteTestResults(ids);
  }
}
