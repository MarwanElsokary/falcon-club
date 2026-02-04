import 'dart:convert';
import 'dart:developer';

import 'package:falcon/core/networking/api_result.dart';

import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/all_trials_model.dart';

class ExperimentsRepo {
  final ApiService _apiService;

  ExperimentsRepo(this._apiService);

  /// Get all trials with optional cache support
  Future<ApiResult<AllTrialsModel>> allTrials({
    required String categoryId,
    required String popular,
    bool useCache = true, // لو عايزين نجيب Offline
  }) async {
    try {
      final cacheKey = 'all_trials_${categoryId}_$popular';

      // 1️⃣ جرب تجيب من الكاش أولًا
      if (useCache) {
        final cachedJson = CacheHelper.getString(cacheKey);
        if (cachedJson != null && cachedJson.isNotEmpty) {
          log('📦 AllTrials FROM CACHE for key: $cacheKey');
          final cachedData = AllTrialsModel.fromJson(jsonDecode(cachedJson));
          return ApiResult.success(cachedData);
        }
      }

      // 2️⃣ لو مفيش كاش أو useCache=false → API
      log('🌐 AllTrials FROM API for key: $cacheKey');
      final response = await _apiService.allTrials(categoryId, popular);

      // 3️⃣ احفظها في الكاش بعد نجاح API
      await CacheHelper.setString(cacheKey, jsonEncode(response.toJson()));

      return ApiResult.success(response);
    } catch (error) {
      log('❌ AllTrials ERROR: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
