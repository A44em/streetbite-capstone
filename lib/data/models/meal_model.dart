import '../../domain/entities/meal.dart';
class MealModel extends Meal {
  const MealModel({required super.id,required super.name,required super.image,required super.category,required super.area,required super.instructions,required super.price});
  factory MealModel.fromJson(Map<String,dynamic> j) => MealModel(
    id: (j['idMeal'] ?? '').toString(), name: (j['strMeal'] ?? '').toString(),
    image: (j['strMealThumb'] ?? '').toString(), category: (j['strCategory'] ?? '').toString(),
    area: (j['strArea'] ?? '').toString(), instructions: (j['strInstructions'] ?? '').toString(),
    // Demo price, not provided by TheMealDB. Never represent as vendor price.
    price: (j['demoPrice'] as num?)?.toDouble() ?? 60 + ((int.tryParse((j['idMeal'] ?? '0').toString()) ?? 0) % 12) * 10.0);
  Map<String,dynamic> toJson() => {'idMeal':id,'strMeal':name,'strMealThumb':image,'strCategory':category,'strArea':area,'strInstructions':instructions,'demoPrice':price};
}
