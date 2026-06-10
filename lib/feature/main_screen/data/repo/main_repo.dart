import 'dart:convert';
import 'dart:developer';

import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/feature/main_screen/data/model/my_profile_model.dart';

import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../../../training_details/data/model/exercise_details_model.dart';
import '../model/categories_model.dart';

class ToggleFavResponse {
  final String message;
  final String playerId;

  ToggleFavResponse({required this.message, required this.playerId});

  factory ToggleFavResponse.fromJson(Map<String, dynamic> json) =>
      ToggleFavResponse(
        message: json['message'] ?? '',
        playerId: json['playerId'] ?? '',
      );
}

class MainRepo {
  final ApiService _apiService;

  MainRepo(this._apiService);

  // myProfile
  Future<ApiResult<MyProfileModel>> myProfile() async {
    try {
      log('🌐 myProfile FROM API');
      final response = await _apiService.myProfile();
      await CacheHelper.savemyProfile(response);
      return ApiResult.success(response);
    } catch (error) {
      log('⚠️ API failed, trying cache as fallback');
      final cached = CacheHelper.getmyProfile();
      if (cached != null) return ApiResult.success(cached);
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<CategoriesModel>> categories() async {
    try {
      final response = await _apiService.categories();
      CacheHelper.saveCategories(jsonEncode(response.toJson()));
      return ApiResult.success(response);
    } catch (error) {
      final cached = CacheHelper.getCategories();
      if (cached != null) {
        return ApiResult.success(CategoriesModel.fromJson(jsonDecode(cached)));
      }
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // profileById
  Future<ApiResult<MyProfileModel>> profileById({
    required String userId,
  }) async {
    try {
      final response = await _apiService.profileById(userId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
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
    } catch (error) {
      log('❌ API Error: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // ✅ Toggle Favorite Player
  Future<ApiResult<ToggleFavResponse>> toggleFavoritePlayer({
    required String playerId,
  }) async {
    try {
      log('⭐ Toggling favorite for player: $playerId');
      final response = await _apiService.toggleFavPlayer(playerId);
      log('✅ Toggle fav response: ${response.message}');
      return ApiResult.success(response);
    } catch (error) {
      log('❌ Toggle fav error: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
