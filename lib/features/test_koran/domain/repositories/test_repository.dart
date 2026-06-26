import '../entities/test_result.dart';

abstract class TestRepository {
  Future<List<TestResult>> getTestHistory();
  Future<void> saveTestResult(TestResult result);
  Future<void> deleteTestResults(List<int> ids);
  Future<void> clearHistory();
}
