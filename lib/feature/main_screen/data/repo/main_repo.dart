import 'dart:convert';
import 'dart:developer';

import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';

import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../../../training_details/data/model/exercise_details_model.dart';
import '../model/categories_model.dart';

class MainRepo {
  final ApiService _apiService;

  MainRepo(this._apiService);

  //myProfile
  Future<ApiResult<MyProfileModel>> myProfile() async {
    try {
      // 🧠 لو الكاش صالح
      if (CacheHelper.isMyProfileValid()) {
        final cached = CacheHelper.getmyProfile();
        if (cached != null) {
          return ApiResult.success(cached);
        }
      }
      if (CacheHelper.isMyProfileValid()) {
        log('📦 myProfile FROM CACHE');
      } else {
        log('🌐 myProfile FROM API');
      }

      // 🌐 API
      final response = await _apiService.myProfile();

      // 💾 Cache
      await CacheHelper.savemyProfile(response);

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }


  Future<ApiResult<CategoriesModel>> categories() async {
    try {
      final cached = CacheHelper.getCategories();
      if (cached != null) {
        return ApiResult.success(
          CategoriesModel.fromJson(jsonDecode(cached)),
        );
      }

      final response = await _apiService.categories();
      CacheHelper.saveCategories(jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //categories
  // Future<ApiResult<CategoriesModel>> categories() async {
  //   try {
  //     final response = await _apiService.categories();
  //     return ApiResult.success(response);
  //   } catch (errro) {
  //     return ApiResult.failure(ErrorHandler.handle(errro));
  //   }
  // }

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

  Future<ApiResult<List<Skill>>> getSkills({required String userId}) async {
    try {
      log('📡 Calling getSkills API with userId: $userId');

      final response = await _apiService.getSkills(userId);
      log(
        '📦 SkillsResponse: message=${response.message}, data count=${response.data.length}',
      );

      return ApiResult.success(response.data);
    } catch (errro) {
      log('❌ API Error: $errro');
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
