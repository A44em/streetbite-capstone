import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences)
      : super(_preferences.getBool(_preferenceKey) == true
            ? ThemeMode.dark
            : ThemeMode.light);

  static const _preferenceKey = 'dark_mode_enabled';
  final SharedPreferences _preferences;

  Future<void> toggle() async {
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(next);
    await _preferences.setBool(_preferenceKey, next == ThemeMode.dark);
  }
}
