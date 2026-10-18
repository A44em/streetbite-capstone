import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/remote_meal_source.dart';
import '../datasources/cached_meal_source.dart';

// Factory chooses a remote-first repository backed by offline cache.
class MealRepositoryFactory {
  static MealRepository create(
          RemoteMealSource remote, CachedMealSource cache) =>
      MealRepositoryImpl(remote, cache);
}

class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl(this.remote, this.cache);
  final RemoteMealSource remote;
  final CachedMealSource cache;
  @override
  Future<List<Meal>> getMeals() async {
    try {
      final meals = await remote.fetch();
      if (meals.isNotEmpty) {
        await cache.save(meals);
        return meals;
      }
      final cached = cache.read();
      if (cached.isNotEmpty) return cached;
      return meals;
    } catch (_) {
      final cached = cache.read();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }
}
