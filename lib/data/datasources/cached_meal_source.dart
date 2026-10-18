import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_model.dart';
class CachedMealSource {
  CachedMealSource(this.prefs);
  final SharedPreferences prefs;
  static const key='cached_meals_v1';
  List<MealModel> read() {
    final raw=prefs.getString(key);
    if(raw==null) return [];
    try { return (jsonDecode(raw) as List).map((e)=>MealModel.fromJson(Map<String,dynamic>.from(e as Map))).toList(); }
    catch (_) { return []; }
  }
  Future<void> save(List<MealModel> meals) => prefs.setString(key,jsonEncode(meals.map((e)=>e.toJson()).toList()));
}
