import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/splash_screen.dart';
import 'core/database/isar_service.dart';
import 'core/audio/audio_service.dart';
import 'core/localization/localization_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/blocs/settings_bloc.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/test_koran/data/datasources/test_local_datasource.dart';
import 'features/test_koran/data/repositories/test_repository_impl.dart';
import 'features/test_koran/domain/usecases/get_test_history.dart';
import 'features/test_koran/domain/usecases/save_test_result.dart';
import 'features/test_koran/domain/usecases/clear_history.dart';
import 'features/test_koran/domain/usecases/delete_history_items.dart';
import 'features/test_koran/presentation/blocs/history/history_bloc.dart';
import 'features/test_koran/presentation/blocs/test/test_bloc.dart';
import 'features/test_koran/presentation/screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.init();
  await AudioService().init();

  final prefs = await SharedPreferences.getInstance();
  final savedSettings = AppSettings.fromPrefs(prefs);
  AudioService().setMute(!savedSettings.soundEnabled);
  final savedLanguage = prefs.getString('language_code') ?? 'en';

  runApp(MyApp(
    initialSettings: savedSettings,
    initialLanguage: savedLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppSettings initialSettings;
  final String initialLanguage;
  final TestLocalDataSource? localDataSource;

  const MyApp({
    super.key,
    required this.initialSettings,
    required this.initialLanguage,
    this.localDataSource,
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = localDataSource ?? TestLocalDataSourceImpl(IsarService.instance);
    final repository = TestRepositoryImpl(localDataSource: dataSource);
    final getTestHistory = GetTestHistory(repository);
    final saveTestResult = SaveTestResult(repository);
    final clearHistory = ClearHistory(repository);
    final deleteHistoryItems = DeleteHistoryItems(repository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(initialSettings: initialSettings),
        ),
        BlocProvider<LocalizationBloc>(
          create: (_) => LocalizationBloc(initialLanguageCode: initialLanguage),
        ),
        BlocProvider<HistoryBloc>(
          create: (_) => HistoryBloc(
            getTestHistory: getTestHistory,
            clearHistoryUsecase: clearHistory,
            deleteHistoryItems: deleteHistoryItems,
          ),
        ),
        BlocProvider<TestBloc>(
          create: (_) => TestBloc(saveTestResult: saveTestResult),
        ),
      ],
      child: BlocBuilder<SettingsBloc, AppSettings>(
        builder: (context, settings) {
          ThemeMode themeMode;
          switch (settings.themeMode) {
            case 'light':
              themeMode = ThemeMode.light;
              break;
            case 'dark':
              themeMode = ThemeMode.dark;
              break;
            default:
              themeMode = ThemeMode.system;
          }

          return MaterialApp(
            title: 'BrainPace - Tes Koran',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            builder: (context, child) {
              return AnimatedTheme(
                data: Theme.of(context),
                duration: const Duration(milliseconds: 300),
                child: child!,
              );
            },
            home: SplashScreen(child: const MainShell()),
          );
        },
      ),
    );
  }
}
