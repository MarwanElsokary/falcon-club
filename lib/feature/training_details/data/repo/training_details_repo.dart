import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:falcon/core/networking/api_result.dart';
import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/exercise_details_model.dart';

class TrainingDetailsRepo {
  final ApiService _apiService;

  TrainingDetailsRepo(this._apiService);

  Future<ApiResult<ExerciseDetailsModel>> exerciseDetails({
    required String exerciseId,
  }) async {
    try {
      final key = 'exercise_details_$exerciseId';
      final cached = CacheHelper.getString(key);

      if (cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        final model = ExerciseDetailsModel.fromJson(decoded);
        return ApiResult.success(model);
      }

      final response = await _apiService.exerciseDetails(exerciseId);

      // خزنه في الكاش
      CacheHelper.setString(key, jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  // addAttempt لا نعمل له caching، لأنه بيغير الحالة ويحتاج request مباشر
  Future<ApiResult> addAttempt({
    required FormData addAttemptBody,
    required String exerciseId,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final dio = Dio();

      dio.options.headers = {
        'Accept-Language': 'ar',
        'Authorization':
        'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
        "Accept": "application/json",
      };

      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          logPrint: (obj) => print(obj),
        ),
      );

      final response = await dio.post(
        '${ApiConstants.apiBaseUrl}${ApiConstants.addAttempt}',
        data: addAttemptBody,
        queryParameters: {'ExerciseId': exerciseId},
        onSendProgress: onSendProgress,
      );

      return ApiResult.success(response.data);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
