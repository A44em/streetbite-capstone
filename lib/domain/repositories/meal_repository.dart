import '../entities/meal.dart';
abstract class MealRepository { Future<List<Meal>> getMeals(); }
