import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/rank_model.dart';

class RankRepo {
  final ApiService _apiService;

  RankRepo(this._apiService);

  Future<ApiResult<RankModel>> rank() async {
    try {
      final response = await _apiService.rank();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}