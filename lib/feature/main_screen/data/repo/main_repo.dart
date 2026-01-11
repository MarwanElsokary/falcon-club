import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/categories_model.dart';

class MainRepo {
  final ApiService _apiService;

  MainRepo(this._apiService);

  //myProfile
  Future<ApiResult<MyProfileModel>> myProfile() async {
    try {
      final response = await _apiService.myProfile();
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  //categories
  Future<ApiResult<CategoriesModel>> categories() async {
    try {
      final response = await _apiService.categories();
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  //profileById
  Future<ApiResult<MyProfileModel>> profileById({
    required String userId,
  }) async {
    try {
      final response = await _apiService.profileById(userId);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
