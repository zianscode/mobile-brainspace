import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/test_koran/data/models/test_result_model.dart';

class IsarService {
  static Isar? _instance;

  /// Retrieves the initialized Isar instance.
  /// Throws a [StateError] if the database hasn't been initialized yet.
  static Isar get instance {
    if (_instance == null) {
      throw StateError('Isar database has not been initialized. Call init() first.');
    }
    return _instance!;
  }

  /// Initializes the Isar database.
  static Future<void> init() async {
    if (_instance != null) return;

    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [TestResultModelSchema],
      directory: dir.path,
    );
  }
}
