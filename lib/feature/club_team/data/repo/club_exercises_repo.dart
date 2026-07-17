import 'package:falconclubapp/core/networking/api_error_handler.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/core/networking/json.dart';
import '../model/club_exercises_model.dart';

/// The exercise list shown when a coach assigns an exercise to a player.
///
/// It used to build a bare `Dio()`, hand-attach an `Authorization` header, and
/// hard-code the path `'Club/GetAllExercises'` — while holding this very
/// [ApiService] and never calling it. That bare client inherited no timeouts and
/// no 401-refresh interceptor.
///
/// It now goes through [ApiService.allExercises], which is the *same endpoint*
/// (`ApiConstants.allExercises`). The empty filter arguments reproduce the old
/// unfiltered request: the training screens already send `CategoryId=''` whenever
/// the user clears a category chip, so the backend's handling of an empty filter
/// is exercised in production today.
class ClubExercisesRepo {
  final ApiService _apiService;
  ClubExercisesRepo(this._apiService);

  /// No category filter, and not restricted to popular exercises — the coach
  /// picks from everything available.
  static const String _noCategory = '';
  static const String _notPopularOnly = 'false';

  Future<ApiResult<ClubExercisesModel>> getAllExercises() async {
    try {
      final response = await _apiService.allExercises(
        _noCategory,
        _notPopularOnly,
      );
      return ApiResult.success(
        ClubExercisesModel.fromJson(Json.asObject(response)),
      );
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
