import 'package:falcon/core/networking/api_result.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/all_trials_model.dart';

class ExperimentsRepo {
  final ApiService _apiService;

  ExperimentsRepo(this._apiService);

  //myProfile

  Future<ApiResult<AllTrialsModel>> allTrials({
    required String categoryId,
    required String popular,
  }) async {
    try {
      final response = await _apiService.allTrials(categoryId, popular);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
