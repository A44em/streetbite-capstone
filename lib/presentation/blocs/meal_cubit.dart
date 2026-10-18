import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/meal.dart';
import '../../domain/usecases/get_meals.dart';
sealed class MealState {}
class MealLoading extends MealState {}
class MealLoaded extends MealState {MealLoaded(this.meals);final List<Meal> meals;}
class MealFailure extends MealState {}
class MealCubit extends Cubit<MealState> {
 MealCubit(this.getMeals):super(MealLoading());final GetMeals getMeals;
 Future<void> load() async {emit(MealLoading());try{emit(MealLoaded(await getMeals()));}catch(_){emit(MealFailure());}}
}
