import 'package:dio/dio.dart';
import 'package:falcon/core/networking/api_constants.dart';
import 'package:falcon/core/networking/api_error_handler.dart';
import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/core/networking/api_service.dart';
import 'package:falcon/feature/reals/data/model/real_model.dart';

/// Repo مخصوص لجلب ريلز اللاعب في الكارت
/// — يستخدم Dio مباشرة عشان نبعت playerId صح
class PlayerReelsRepo {
  final ApiService _apiService;
  final Dio _dio;

  PlayerReelsRepo(this._apiService, this._dio);

  /// جلب أول صفحة من ريلز اللاعب (5 ريلز كافية للعرض في الكارت)
  Future<ApiResult<List<RealsVide>>> getPlayerReels({
    required String playerId,
    int pageSize = 5,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.apiBaseUrl}${ApiConstants.reals}',
        queryParameters: {
          'pageNumber': 1,
          'pageSize': pageSize,
          'playerId': playerId,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        final reels = (data['data'] as List)
            .map((e) => RealsVide.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResult.success(reels);
      }
      return const ApiResult.success([]);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}