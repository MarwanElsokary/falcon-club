import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/core/networking/api_constants.dart';
import 'package:falconclubapp/core/networking/api_error_handler.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/core/helpers/shared_pref_helper.dart';
import 'package:falconclubapp/core/helpers/constants.dart';
import '../model/player_attempts_model.dart';

class PlayerAttemptsRepo {
  final ApiService _apiService;

  PlayerAttemptsRepo(this._apiService);

  Future<ApiResult<PlayerAttemptsModel>> getPlayerAttempts({
    required int exerciseId,
    required String playerId,
  }) async {
    try {
      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      };

      final response = await dio.get(
        '${ApiConstants.apiBaseUrl}Club/GetPlayerAttempts',
        queryParameters: {
          'ExerciseId': exerciseId,
          'PlayerId': playerId,
        },
      );

      final model = PlayerAttemptsModel.fromJson(
        response.data is Map<String, dynamic>
            ? response.data
            : Map<String, dynamic>.from(response.data),
      );
      return ApiResult.success(model);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}