import 'dart:developer';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/all_trials_model.dart';

class ExperimentsRepo {
  final ApiService _apiService;

  ExperimentsRepo(this._apiService);

  Future<ApiResult<AllTrialsModel>> allTrials({
    required String categoryId,
    required String popular,
  }) async {
    try {
      log('🌐 AllTrials FROM API');
      final response = await _apiService.allTrials(categoryId, popular);
      return ApiResult.success(response);
    } catch (error) {
      log('❌ AllTrials ERROR: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}