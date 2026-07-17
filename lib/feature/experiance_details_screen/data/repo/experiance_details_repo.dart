import 'dart:convert';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../model/exerciseWithPlayersModel.dart';
import '../model/trial_details_model.dart';

/// Legacy repository, kept alive until Phases 6–7 replace its screens.
///
/// It used to build bare `Dio()` instances, each hand-attaching an
/// `Authorization` header read out of secure storage, while holding an injected
/// [ApiService] it never called. A bare `Dio` inherits no timeouts and no
/// 401-refresh interceptor, so an expired token failed the request instead of
/// being refreshed.
///
/// Its two remaining reads now go through the shared stack via [ApiService]. The
/// attempt upload that used to live here moved to the exercise feature's
/// `AttemptUploadCubit` → `AttemptRepository` in Phase 5, which is why this no
/// longer holds a `Dio`.
class ExperianceDetailsRepo {
  final ApiService _apiService;

  ExperianceDetailsRepo(this._apiService);

  // ── تفاصيل التجربة ─────────────────────────────────────────────
  Future<ApiResult<TrialDetailsModel>> trialDetails({
    required String trialId,
  }) async {
    try {
      final key = 'trial_details_$trialId';
      final cached = CacheHelper.getString(key);
      if (cached.isNotEmpty) {
        try {
          return ApiResult.success(
            TrialDetailsModel.fromJson(jsonDecode(cached)),
          );
        } catch (_) {
          // A corrupt entry used to be fatal: `jsonDecode` threw into the outer
          // catch, which returned a failure, and nothing ever cleared the entry
          // — so the trial screen stayed broken until sign-out. Evict and refetch.
          await CacheHelper.removeData(key);
        }
      }

      final body = Json.asObject(await _apiService.trialDetails(trialId));
      CacheHelper.setString(key, jsonEncode(body));
      return ApiResult.success(TrialDetailsModel.fromJson(body));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // ── اللاعبين في تمرين ──────────────────────────────────────────
  Future<ApiResult<ExerciseDetailsWithPlayersModel>> exercisePlayers({
    required String exerciseId,
  }) async {
    try {
      final body = Json.asObject(
        await _apiService.exerciseDetails(exerciseId),
      );
      return ApiResult.success(ExerciseDetailsWithPlayersModel.fromJson(body));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
