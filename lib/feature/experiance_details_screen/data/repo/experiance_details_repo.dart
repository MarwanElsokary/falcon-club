import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/exerciseWithPlayersModel.dart';
import '../model/trial_details_model.dart';

class ExperianceDetailsRepo {
  final ApiService _apiService;

  ExperianceDetailsRepo(this._apiService);

  // ── تفاصيل التجربة ─────────────────────────────────────────────
  Future<ApiResult<TrialDetailsModel>> trialDetails({
    required String trialId,
  }) async {
    try {
      final key = 'trial_details_$trialId';
      final cached = CacheHelper.getString(key);
      if (cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        final model = TrialDetailsModel.fromJson(decoded);
        return ApiResult.success(model);
      }
      final response = await _apiService.trialDetails(trialId);
      CacheHelper.setString(key, jsonEncode(response.toJson()));
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // ── اللاعبين في تمرين — بنستخدم dio مباشرة ─────────────────────
  Future<ApiResult<ExerciseDetailsWithPlayersModel>> exercisePlayers({
    required String exerciseId,
  }) async {
    try {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      };

      final response = await dio.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.exerciseDetails}',
        queryParameters: {'ExerciseId': exerciseId},
      );

      final model = ExerciseDetailsWithPlayersModel.fromJson(
        response.data is Map<String, dynamic>
            ? response.data
            : Map<String, dynamic>.from(response.data),
      );
      return ApiResult.success(model);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // ── إضافة محاولة للاعب — POST /api/Club/AddAttempt ─────────────
  Future<ApiResult> addAttemptForPlayer({
    required String playerId,
    required String exerciseId,
    required String videoPath,
  }) async {
    try {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Accept-Language': 'ar',
      };

      final formData = FormData.fromMap({
        'Video': await MultipartFile.fromFile(
          videoPath,
          filename: videoPath.split('/').last,
        ),
      });

      final response = await dio.post(
        '${ApiConstants.apiBaseUrl}${ApiConstants.clubAddAttempt}',
        data: formData,
        queryParameters: {
          'PlayerId': playerId,
          'ExerciseId': int.parse(exerciseId),
        },
      );

      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}