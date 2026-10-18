import '../entities/meal.dart';
import '../repositories/meal_repository.dart';
class GetMeals {const GetMeals(this.repository);final MealRepository repository;Future<List<Meal>> call()=>repository.getMeals();}
