import 'package:falcon/core/networking/api_result.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/trial_details_model.dart';

class ExperianceDetailsRepo {
  final ApiService _apiService;

  ExperianceDetailsRepo(this._apiService);

  //myProfile
  Future<ApiResult<TrialDetailsModel>> trialDetails({
    required String trialId,
  }) async {
    try {
      final response = await _apiService.trialDetails(trialId);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
