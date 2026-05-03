import 'dart:convert';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../../core/cache/cach_Helper.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_service.dart';
import '../../../../training_details/data/model/exercise_details_model.dart';

/// Repo تفاصيل التمرين للكشاف — view only، مفيش addAttempt
class ScoutTrainingDetailsRepo {
  final ApiService _apiService;

  ScoutTrainingDetailsRepo(this._apiService);

  Future<ApiResult<ExerciseDetailsModel>> exerciseDetails({
    required String exerciseId,
  }) async {
    final key = 'scout_exercise_details_$exerciseId';

    try {
      final cached = CacheHelper.getString(key);
      if (cached.isNotEmpty) {
        try {
          final decoded = jsonDecode(cached);
          final model = ExerciseDetailsModel.fromJson(decoded);
          return ApiResult.success(model);
        } catch (_) {
          CacheHelper.setString(key, '');
        }
      }

      final response = await _apiService.exerciseDetails(exerciseId);
      CacheHelper.setString(key, jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
