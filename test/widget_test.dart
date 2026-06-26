import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brainpace/features/test_koran/data/datasources/test_local_datasource.dart';
import 'package:brainpace/features/test_koran/data/models/test_result_model.dart';
import 'package:brainpace/main.dart';
import 'package:brainpace/features/settings/domain/entities/app_settings.dart';

class FakeTestLocalDataSource extends Fake implements TestLocalDataSource {
  @override
  Future<List<TestResultModel>> getTestHistory() async {
    return <TestResultModel>[];
  }
}

void main() {
  testWidgets('App renders dashboard screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = AppSettings.fromPrefs(prefs);

    await tester.pumpWidget(MyApp(
      initialSettings: settings,
      initialLanguage: 'en',
      localDataSource: FakeTestLocalDataSource(),
    ));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('BRAINPACE'), findsOneWidget);
  });
}
