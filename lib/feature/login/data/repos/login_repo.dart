import 'package:dio/dio.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../model/country_model.dart';

class LoginRepo {
  // ignore: unused_field
  final ApiService _apiService;

  LoginRepo(this._apiService);

  //login

  Future<ApiResult> login(loginRequestBody) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  Future<ApiResult> register(loginRequestBody) async {
    try {
      final response = await _apiService.register(loginRequestBody);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  Future<ApiResult> completeRegistration(FormData body) async {
    try {
      final response = await _apiService.completeRegistration(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult> updateProfile(loginRequestBody) async {
    try {
      final response = await _apiService.updateProfile(loginRequestBody);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  Future<ApiResult> otp(int otp) async {
    try {
      final response = await _apiService.otp(otp);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  //countries
  Future<ApiResult<CountriesClubModel>> countries() async {
    try {
      final response = await _apiService.countries();
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  //clubsByCountry
  Future<ApiResult<CountriesClubModel>> clubsByCountry({
    required String countryId,
  }) async {
    try {
      final response = await _apiService.clubsByCountry(countryId);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
