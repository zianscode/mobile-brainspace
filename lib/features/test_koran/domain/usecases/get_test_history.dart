import '../entities/test_result.dart';
import '../repositories/test_repository.dart';

class GetTestHistory {
  final TestRepository repository;

  GetTestHistory(this.repository);

  Future<List<TestResult>> call() {
    return repository.getTestHistory();
  }
}
