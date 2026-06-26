import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';
export 'app_localizations.dart';

class LocalizationBloc extends Bloc<LanguageEvent, LanguageState> {
  LocalizationBloc({String? initialLanguageCode})
      : super(LanguageState(initialLanguageCode ?? 'en')) {
    on<SetLanguageEvent>(_onSetLanguage);
  }

  Future<void> _onSetLanguage(SetLanguageEvent event, Emitter<LanguageState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', event.languageCode);
    emit(LanguageState(event.languageCode));
  }
}

class LanguageState {
  final String languageCode;
  LanguageState(this.languageCode);

  AppLocalizations get loc => AppLocalizations(languageCode);
}

abstract class LanguageEvent {}

class SetLanguageEvent extends LanguageEvent {
  final String languageCode;
  SetLanguageEvent(this.languageCode);
}
