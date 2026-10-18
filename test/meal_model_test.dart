import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite/data/models/meal_model.dart';

void main() {
  test(
      'MealModel API parsing and cache round trip retain fields and demo price',
      () {
    final meal = MealModel.fromJson({
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken',
      'strMealThumb': 'https://example.org/meal.jpg',
      'strCategory': 'Chicken',
      'strArea': 'Japanese',
      'strInstructions': 'Cook thoroughly.'
    });
    final restored = MealModel.fromJson(meal.toJson());
    expect(restored.id, meal.id);
    expect(restored.name, meal.name);
    expect(restored.area, 'Japanese');
    expect(restored.price, meal.price);
  });
}
