import 'package:dio/dio.dart';
import '../models/meal_model.dart';

class RemoteMealSource {
  RemoteMealSource(this.dio);
  final Dio dio;
  Future<List<MealModel>> fetch() async {
    final result = await dio.get<Map<String, dynamic>>(
        'https://www.themealdb.com/api/json/v1/1/search.php',
        queryParameters: {'s': ''});
    final rows = (result.data?['meals'] as List?) ?? [];
    return rows
        .map((e) => MealModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
