import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool animationsEnabled;
  final String languageCode;
  final int timerSeconds;
  final String operationType;
  final String patternType;
  final String displayFormat;
  final String keyboardLayout;
  final String themeMode;

  const AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.animationsEnabled = true,
    this.languageCode = 'en',
    this.timerSeconds = 300,
    this.operationType = 'addition',
    this.patternType = 'sequential',
    this.displayFormat = 'vertical',
    this.keyboardLayout = 'ascending',
    this.themeMode = 'system',
  });

  factory AppSettings.fromPrefs(SharedPreferences prefs) {
    return AppSettings(
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
      vibrationEnabled: prefs.getBool('vibration_enabled') ?? true,
      animationsEnabled: prefs.getBool('animations_enabled') ?? true,
      languageCode: prefs.getString('language_code') ?? 'en',
      timerSeconds: prefs.getInt('timer_seconds') ?? 300,
      operationType: prefs.getString('operation_type') ?? 'addition',
      patternType: prefs.getString('pattern_type') ?? 'sequential',
      displayFormat: prefs.getString('display_format') ?? 'vertical',
      keyboardLayout: prefs.getString('keyboard_layout') ?? 'ascending',
      themeMode: prefs.getString('theme_mode') ?? 'system',
    );
  }

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? animationsEnabled,
    String? languageCode,
    int? timerSeconds,
    String? operationType,
    String? patternType,
    String? displayFormat,
    String? keyboardLayout,
    String? themeMode,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      languageCode: languageCode ?? this.languageCode,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      operationType: operationType ?? this.operationType,
      patternType: patternType ?? this.patternType,
      displayFormat: displayFormat ?? this.displayFormat,
      keyboardLayout: keyboardLayout ?? this.keyboardLayout,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  static List<int> get timerPresets => [60, 120, 300, 690, 1350, 1800];
}
