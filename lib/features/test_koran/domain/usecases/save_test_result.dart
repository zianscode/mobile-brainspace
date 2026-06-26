import '../entities/test_result.dart';
import '../repositories/test_repository.dart';

class SaveTestResult {
  final TestRepository repository;

  SaveTestResult(this.repository);

  Future<void> call(TestResult result) {
    return repository.saveTestResult(result);
  }
}
