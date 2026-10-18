import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/remote_meal_source.dart';
import 'data/datasources/cached_meal_source.dart';
import 'data/repositories/meal_repository_impl.dart';
import 'domain/repositories/meal_repository.dart';
import 'domain/usecases/get_meals.dart';

final sl = GetIt.instance;
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 12))));
  sl.registerLazySingleton<RemoteMealSource>(() => RemoteMealSource(sl()));
  sl.registerLazySingleton<CachedMealSource>(() => CachedMealSource(sl()));
  sl.registerLazySingleton<MealRepository>(
      () => MealRepositoryFactory.create(sl(), sl()));
  sl.registerLazySingleton<GetMeals>(() => GetMeals(sl()));
}
