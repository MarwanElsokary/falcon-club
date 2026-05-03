import 'dart:convert';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../../core/cache/cach_Helper.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_service.dart';
import '../../../../training/data/model/all_exercises_model.dart';

/// Repo مستقل للكشاف — يستخدم نفس الـ API
/// لكن بـ cache key مختلف عشان ما يأثرش على cache النادي
class ScoutTrainingRepo {
  final ApiService _apiService;

  ScoutTrainingRepo(this._apiService);

  Future<ApiResult<AllExercisesModel>> allExercises({
    required String categoryId,
    required String popular,
  }) async {
    try {
      final key = 'scout_exercises_${categoryId}_$popular';
      final cached = CacheHelper.getString(key);

      if (cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        final model = AllExercisesModel.fromJson(decoded);
        return ApiResult.success(model);
      }

      final response = await _apiService.allExercises(categoryId, popular);
      CacheHelper.setString(key, jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}