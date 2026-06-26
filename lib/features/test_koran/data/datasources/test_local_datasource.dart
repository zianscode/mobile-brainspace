import 'package:isar/isar.dart';
import '../models/test_result_model.dart';

abstract class TestLocalDataSource {
  Future<List<TestResultModel>> getTestHistory();
  Future<void> saveTestResult(TestResultModel model);
  Future<void> deleteTestResults(List<int> ids);
  Future<void> clearHistory();
}

class TestLocalDataSourceImpl implements TestLocalDataSource {
  final Isar isar;

  TestLocalDataSourceImpl(this.isar);

  @override
  Future<List<TestResultModel>> getTestHistory() async {
    // Return all test results sorted by date time descending (most recent first)
    return await isar.testResultModels.where().sortByDateTimeDesc().findAll();
  }

  @override
  Future<void> saveTestResult(TestResultModel model) async {
    await isar.writeTxn(() async {
      await isar.testResultModels.put(model);
    });
  }

  @override
  Future<void> deleteTestResults(List<int> ids) async {
    await isar.writeTxn(() async {
      await isar.testResultModels.deleteAll(ids);
    });
  }

  @override
  Future<void> clearHistory() async {
    await isar.writeTxn(() async {
      await isar.testResultModels.clear();
    });
  }
}
