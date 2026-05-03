import 'dart:convert';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/rank_model.dart';

class RankRepo {
  final ApiService _apiService;

  RankRepo(this._apiService);

  Future<ApiResult<RankModel>> rank() async {
    try {
      final key = 'rank';
      final cached = CacheHelper.getString(key);

      if (cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        final model = RankModel.fromJson(decoded);
        return ApiResult.success(model);
      }

      final response = await _apiService.rank();

      // خزنه في الكاش
      CacheHelper.setString(key, jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
