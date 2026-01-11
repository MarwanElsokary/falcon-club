import 'package:falcon/core/networking/api_result.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/all_exercises_model.dart';

class TrainingRepo {
  final ApiService _apiService;

  TrainingRepo(this._apiService);

  //myProfile

  Future<ApiResult<AllExercisesModel>> allExercises({
    required String categoryId,
    required String popular,
  }) async {
    try {
      final response = await _apiService.allExercises(categoryId, popular);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
