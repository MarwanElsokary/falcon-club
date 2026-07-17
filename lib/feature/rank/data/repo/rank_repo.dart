import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/rank_model.dart';

class RankRepo {
  final ApiService _apiService;

  RankRepo(this._apiService);

  /// [exerciseId] empty means the overall ranking — the app's only use today.
  Future<ApiResult<RankModel>> rank({String exerciseId = ''}) async {
    try {
      final response = await _apiService.rank(exerciseId);
      // The endpoint returns a bare array; the factory parses it (and the
      // envelope shape, and an empty/absent list).
      return ApiResult.success(RankModel.fromResponse(response));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}