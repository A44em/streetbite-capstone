import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._preferences)
      : super(Locale(_preferences.getString(_preferenceKey) ?? 'en'));

  static const _preferenceKey = 'selected_locale';
  final SharedPreferences _preferences;

  Future<void> toggle() async {
    final next = state.languageCode == 'en' ? 'ar' : 'en';
    emit(Locale(next));
    await _preferences.setString(_preferenceKey, next);
  }
}
