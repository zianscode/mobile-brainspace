import '../../domain/entities/test_result.dart';
import '../../domain/repositories/test_repository.dart';
import '../datasources/test_local_datasource.dart';
import '../models/test_result_model.dart';

class TestRepositoryImpl implements TestRepository {
  final TestLocalDataSource localDataSource;

  TestRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TestResult>> getTestHistory() async {
    final models = await localDataSource.getTestHistory();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveTestResult(TestResult result) async {
    final model = TestResultModel.fromEntity(result);
    await localDataSource.saveTestResult(model);
  }

  @override
  Future<void> deleteTestResults(List<int> ids) async {
    await localDataSource.deleteTestResults(ids);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
  }
}
