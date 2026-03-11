import 'package:dio/dio.dart';
import 'package:falcon/core/networking/api_constants.dart';
import 'package:falcon/core/networking/api_error_handler.dart';
import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/core/networking/api_service.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
import 'package:falcon/core/helpers/constants.dart';
import '../model/club_exercises_model.dart';

class ClubExercisesRepo {
  final ApiService _apiService;
  ClubExercisesRepo(this._apiService);

  Future<ApiResult<ClubExercisesModel>> getAllExercises() async {
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
        '${ApiConstants.apiBaseUrl}Club/GetAllExercises',
      );

      final model = ClubExercisesModel.fromJson(
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