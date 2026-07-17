import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../model/exercise_with_players_model.dart';

/// Reads the players roster for an exercise (`club/GetExercise`).
///
/// The roster half of the old `ExperianceDetailsRepo`; its trial-details read
/// moved to the exercise domain's `TrialRepository` in Phase 7. Still on the
/// legacy `ApiResult` path until the roster's own domain migration.
class ExerciseRosterRepo {
  final ApiService _apiService;

  ExerciseRosterRepo(this._apiService);

  Future<ApiResult<ExerciseDetailsWithPlayersModel>> exercisePlayers({
    required String exerciseId,
  }) async {
    try {
      final body = Json.asObject(await _apiService.exerciseDetails(exerciseId));
      return ApiResult.success(ExerciseDetailsWithPlayersModel.fromJson(body));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
