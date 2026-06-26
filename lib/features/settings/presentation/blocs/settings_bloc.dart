import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import '../../../../core/audio/audio_service.dart';

class SettingsBloc extends Bloc<SettingsEvent, AppSettings> {
  SettingsBloc({AppSettings? initialSettings})
      : super(initialSettings ?? const AppSettings()) {
    on<UpdateSoundEvent>(_onUpdateSound);
    on<UpdateVibrationEvent>(_onUpdateVibration);
    on<UpdateAnimationsEvent>(_onUpdateAnimations);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateTimerEvent>(_onUpdateTimer);
    on<UpdateOperationTypeEvent>(_onUpdateOperationType);
    on<UpdatePatternTypeEvent>(_onUpdatePatternType);
    on<UpdateDisplayFormatEvent>(_onUpdateDisplayFormat);
    on<UpdateKeyboardLayoutEvent>(_onUpdateKeyboardLayout);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<ResetSettingsEvent>(_onReset);
  }

  Future<void> _saveBool(String key, bool value) async {
    (await SharedPreferences.getInstance()).setBool(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    (await SharedPreferences.getInstance()).setString(key, value);
  }

  Future<void> _saveInt(String key, int value) async {
    (await SharedPreferences.getInstance()).setInt(key, value);
  }

  void _onUpdateSound(UpdateSoundEvent event, Emitter<AppSettings> emit) {
    _saveBool('sound_enabled', event.value);
    AudioService().setMute(!event.value);
    emit(state.copyWith(soundEnabled: event.value));
  }

  void _onUpdateVibration(UpdateVibrationEvent event, Emitter<AppSettings> emit) {
    _saveBool('vibration_enabled', event.value);
    emit(state.copyWith(vibrationEnabled: event.value));
  }

  void _onUpdateAnimations(UpdateAnimationsEvent event, Emitter<AppSettings> emit) {
    _saveBool('animations_enabled', event.value);
    emit(state.copyWith(animationsEnabled: event.value));
  }

  void _onUpdateLanguage(UpdateLanguageEvent event, Emitter<AppSettings> emit) {
    _saveString('language_code', event.value);
    emit(state.copyWith(languageCode: event.value));
  }

  void _onUpdateTimer(UpdateTimerEvent event, Emitter<AppSettings> emit) {
    _saveInt('timer_seconds', event.value);
    emit(state.copyWith(timerSeconds: event.value));
  }

  void _onUpdateOperationType(UpdateOperationTypeEvent event, Emitter<AppSettings> emit) {
    _saveString('operation_type', event.value);
    emit(state.copyWith(operationType: event.value));
  }

  void _onUpdatePatternType(UpdatePatternTypeEvent event, Emitter<AppSettings> emit) {
    _saveString('pattern_type', event.value);
    emit(state.copyWith(patternType: event.value));
  }

  void _onUpdateDisplayFormat(UpdateDisplayFormatEvent event, Emitter<AppSettings> emit) {
    _saveString('display_format', event.value);
    emit(state.copyWith(displayFormat: event.value));
  }

  void _onUpdateKeyboardLayout(UpdateKeyboardLayoutEvent event, Emitter<AppSettings> emit) {
    _saveString('keyboard_layout', event.value);
    emit(state.copyWith(keyboardLayout: event.value));
  }

  void _onUpdateThemeMode(UpdateThemeModeEvent event, Emitter<AppSettings> emit) {
    _saveString('theme_mode', event.value);
    emit(state.copyWith(themeMode: event.value));
  }

  void _onReset(ResetSettingsEvent event, Emitter<AppSettings> emit) async {
    (await SharedPreferences.getInstance()).clear();
    AudioService().setMute(false); // Default sound enabled
    emit(const AppSettings());
  }
}

abstract class SettingsEvent {}

class UpdateSoundEvent extends SettingsEvent { final bool value; UpdateSoundEvent(this.value); }
class UpdateVibrationEvent extends SettingsEvent { final bool value; UpdateVibrationEvent(this.value); }
class UpdateAnimationsEvent extends SettingsEvent { final bool value; UpdateAnimationsEvent(this.value); }
class UpdateLanguageEvent extends SettingsEvent { final String value; UpdateLanguageEvent(this.value); }
class UpdateTimerEvent extends SettingsEvent { final int value; UpdateTimerEvent(this.value); }
class UpdateOperationTypeEvent extends SettingsEvent { final String value; UpdateOperationTypeEvent(this.value); }
class UpdatePatternTypeEvent extends SettingsEvent { final String value; UpdatePatternTypeEvent(this.value); }
class UpdateDisplayFormatEvent extends SettingsEvent { final String value; UpdateDisplayFormatEvent(this.value); }
class UpdateKeyboardLayoutEvent extends SettingsEvent { final String value; UpdateKeyboardLayoutEvent(this.value); }
class UpdateThemeModeEvent extends SettingsEvent { final String value; UpdateThemeModeEvent(this.value); }
class ResetSettingsEvent extends SettingsEvent {}
