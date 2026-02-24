import 'package:dio/dio.dart';
import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/core/networking/api_error_handler.dart';
import 'package:falcon/core/networking/api_service.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';

class ClubTeamRepo {
  final ApiService _apiService;

  ClubTeamRepo(this._apiService);

  //clubUpdateProfile
  Future<ApiResult> clubUpdateProfile(FormData body) async {
    try {
      final response = await _apiService.clubUpdateProfile(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //clubGetPlayers
  Future<ApiResult> clubGetPlayers() async {
    try {
      final response = await _apiService.clubGetPlayers();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //myProfile
  Future<ApiResult<MyProfileModel>> myProfile() async {
    try {
      final response = await _apiService.myProfile();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
