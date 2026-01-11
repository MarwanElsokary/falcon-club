import 'package:falcon/core/networking/api_result.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/real_model.dart';

class RealsRepo {
  final ApiService _apiService;

  RealsRepo(this._apiService);

  //myProfile
  Future<ApiResult<RealModel>> reals({
    required String pageNumber,
    required String pageSize,
    required String playerId,
  }) async {
    try {
      final response = await _apiService.reals(pageNumber, pageSize, playerId);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  Future<ApiResult> toggleLikeReel({required int reelId}) async {
    try {
      final response = await _apiService.toggleLikeReel(reelId);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  Future<ApiResult> addComment({
    required int reelId,
    required String comment,
  }) async {
    try {
      final response = await _apiService.addComment(reelId, comment);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
