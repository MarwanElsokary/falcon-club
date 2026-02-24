import 'package:dio/dio.dart';
import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/core/networking/api_error_handler.dart';
import 'package:falcon/core/networking/api_service.dart';

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

  //clubGetProfile
  Future<ApiResult> clubGetProfile() async {
    try {
      final response = await _apiService.clubGetProfile();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
