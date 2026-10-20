import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/usecases/get_meals.dart';
import 'injection.dart';
import 'l10n/app_localizations.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/cart_bloc.dart';
import 'presentation/blocs/locale_cubit.dart';
import 'presentation/blocs/meal_cubit.dart';
import 'presentation/blocs/theme_cubit.dart';
import 'presentation/screens/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const StreetBiteApp());
}

class StreetBiteApp extends StatelessWidget {
  const StreetBiteApp({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit(sl<SharedPreferences>())),
          BlocProvider(create: (_) => LocaleCubit(sl<SharedPreferences>())),
          BlocProvider(create: (_) => AuthCubit(FirebaseAuth.instance)),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (_) => MealCubit(sl<GetMeals>())..load()),
        ],
        child: Builder(
            builder: (context) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'StreetBite',
                  locale: context.watch<LocaleCubit>().state,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate
                  ],
                  theme: ThemeData(
                      colorSchemeSeed: const Color(0xFFE86B36),
                      useMaterial3: true,
                      scaffoldBackgroundColor: const Color(0xFFFFFAF5)),
                  darkTheme: ThemeData(
                      colorSchemeSeed: const Color(0xFFE86B36),
                      brightness: Brightness.dark,
                      useMaterial3: true),
                  themeMode: context.watch<ThemeCubit>().state,
                  home: const AuthGate(),
                )),
      );
}
