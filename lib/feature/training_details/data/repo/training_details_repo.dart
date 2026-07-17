import 'dart:convert';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/cache/cach_Helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../model/exercise_details_model.dart';

class TrainingDetailsRepo {
  final ApiService _apiService;

  TrainingDetailsRepo(this._apiService);

  Future<ApiResult<ExerciseDetailsModel>> exerciseDetails({
    required String exerciseId,
  }) async {
    final key = 'exercise_details_$exerciseId';

    try {
      // ── جرب الكاش أولاً ────────────────────────────────────────
      final cached = CacheHelper.getString(key);
      if (cached.isNotEmpty) {
        try {
          final decoded = jsonDecode(cached);
          final model = ExerciseDetailsModel.fromJson(decoded);
          return ApiResult.success(model);
        } catch (_) {
          // لو الكاش فاسد — امسحه واجيب من الـ API
          CacheHelper.setString(key, '');
        }
      }

      // ── API ─────────────────────────────────────────────────────
      // `exerciseDetails` now returns the raw body — see `ApiService`. Cache the
      // body itself rather than re-serialising a parsed model.
      final body = Json.asObject(await _apiService.exerciseDetails(exerciseId));
      CacheHelper.setString(key, jsonEncode(body));

      return ApiResult.success(ExerciseDetailsModel.fromJson(body));
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

// `addAttempt` was removed here.
//
// It POSTed to `Player/AddAttempt` — a player uploading their *own* attempt —
// which this app never does: player uploads are handled by a separate
// application, and this app cannot even hold a player token (sign-in refuses the
// `Player` role). Its only caller was `TrainingDetailsCubit.emitAddAttemptStates`,
// which had no callers of its own. The whole chain was dead.
//
// It also built a bare `Dio()` and attached a `LogInterceptor(request: true,
// requestBody: true, responseHeader: true)` printing through `print()` with no
// `kDebugMode` guard — which would have written `Authorization: Bearer <token>`
// to logcat in release builds. Dead code, so it never fired; deleted so it never
// can.
}