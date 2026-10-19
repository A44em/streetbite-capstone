import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streetbite/presentation/blocs/locale_cubit.dart';
import 'package:streetbite/presentation/blocs/theme_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('ThemeCubit persists the selected theme', () async {
    final preferences = await SharedPreferences.getInstance();
    final cubit = ThemeCubit(preferences);

    await cubit.toggle();

    expect(cubit.state, ThemeMode.dark);
    expect(preferences.getBool('dark_mode_enabled'), isTrue);
    await cubit.close();
  });

  test('LocaleCubit persists the selected locale', () async {
    final preferences = await SharedPreferences.getInstance();
    final cubit = LocaleCubit(preferences);

    await cubit.toggle();

    expect(cubit.state.languageCode, 'ar');
    expect(preferences.getString('selected_locale'), 'ar');
    await cubit.close();
  });
}
