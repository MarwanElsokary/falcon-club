import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/core/networking/api_error_handler.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/core/networking/json.dart';
import '../model/player_attempts_model.dart';

class PlayerAttemptsRepo {
  final ApiService _apiService;

  PlayerAttemptsRepo(this._apiService);

  /// Goes through the shared [ApiService].
  ///
  /// It previously built a bare `Dio()`, hand-attached an `Authorization` header
  /// read from secure storage, and hard-coded the endpoint path — all while
  /// holding this very `_apiService` and never calling it. A bare `Dio` inherits
  /// no timeouts and no 401-refresh interceptor, so an expired token failed here
  /// instead of being refreshed.
  ///
  /// This feature is rewritten in Phase 6; the change is confined to *how* the
  /// request is made, so the returned model and every caller are untouched.
  Future<ApiResult<PlayerAttemptsModel>> getPlayerAttempts({
    required int exerciseId,
    required String playerId,
  }) async {
    try {
      final response = await _apiService.getPlayerAttempts(
        '$exerciseId',
        playerId,
      );
      return ApiResult.success(
        PlayerAttemptsModel.fromJson(Json.asObject(response)),
      );
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}