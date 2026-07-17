import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../model/all_exercises_model.dart';

class TrainingRepo {
  final ApiService _apiService;

  TrainingRepo(this._apiService);

  Future<ApiResult<AllExercisesModel>> allExercises({
    required String categoryId,
    required String popular,
  }) async {
    try {
      // `allExercises` now returns the raw body — see `ApiService`. Decoding
      // moved to the call site; this repo is replaced in Phase 3.
      final response = await _apiService.allExercises(categoryId, popular);
      return ApiResult.success(
        AllExercisesModel.fromJson(Json.asObject(response)),
      );
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}