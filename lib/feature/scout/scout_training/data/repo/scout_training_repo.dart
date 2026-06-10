import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../../core/networking/api_error_handler.dart';
import '../../../../../core/networking/api_service.dart';
import '../../../../training/data/model/all_exercises_model.dart';

class ScoutTrainingRepo {
  final ApiService _apiService;

  ScoutTrainingRepo(this._apiService);

  Future<ApiResult<AllExercisesModel>> allExercises({
    required String categoryId,
    required String popular,
  }) async {
    try {
      final response = await _apiService.allExercises(categoryId, popular);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}