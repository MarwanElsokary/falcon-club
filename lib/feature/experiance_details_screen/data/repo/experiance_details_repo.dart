import 'dart:convert';
import 'package:falcon/core/networking/api_result.dart';
import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/trial_details_model.dart';

class ExperianceDetailsRepo {
  final ApiService _apiService;

  ExperianceDetailsRepo(this._apiService);

  Future<ApiResult<TrialDetailsModel>> trialDetails({
    required String trialId,
  }) async {
    try {
      final key = 'trial_details_$trialId';
      final cached = CacheHelper.getString(key);

      if (cached.isNotEmpty) {
        final decoded = jsonDecode(cached);
        final model = TrialDetailsModel.fromJson(decoded);
        return ApiResult.success(model);
      }

      final response = await _apiService.trialDetails(trialId);

      // خزنه في الكاش
      CacheHelper.setString(key, jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
