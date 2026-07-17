import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/value_objects/attempt_video.dart';

/// The one place this feature talks to the network.
///
/// ## Every request goes through the configured stack
///
/// The code this replaces builds **five separate bare `Dio()` instances** —
/// `training_details_repo:53`, `experiance_details_repo:44` and `:77`,
/// `club_exercises_repo:19`, `player_attempts_repo:22` — each hand-attaching its
/// own `Authorization` header read straight out of secure storage. A bare `Dio`
/// inherits nothing: no connect/receive timeout, no 401-refresh interceptor, no
/// base URL. Three of those five hold an injected `ApiService` and never call it.
///
/// One additionally installs a `LogInterceptor(request: true, requestBody: true,
/// responseHeader: true)` with `logPrint: print` and **no `kDebugMode` guard**
/// (`training_details_repo:62-71`), so it prints the `Authorization: Bearer
/// $token` header to logcat **in release builds**, readable by any app on the
/// device with log access. `DioFactory`'s own logger is `kDebugMode`-gated; that
/// one was not.
///
/// Reads go through [ApiService] (Retrofit over the shared `Dio`). The upload
/// goes through the **injected** [Dio] — the same instance `DioFactory`
/// configures — because Retrofit exposes no `onSendProgress`. *Injected* is the
/// operative word: it carries the auth interceptor, the timeouts and the
/// debug-only logger. It is not a bare `Dio()`.
///
/// ## Why it returns raw envelopes
///
/// Each read returns the decoded response body, not an entity. That is what lets
/// the repository cache the *body* it just received, rather than re-serialising
/// an entity or issuing a second request to obtain something cacheable. Mapping
/// lives one layer up, in the repository, next to the cache that stores the same
/// shape. The data source's single responsibility is the transport.
///
/// Error policy: transport errors (`DioException`) propagate and are translated
/// once, centrally, by `ErrorMapper` in the repository. This class throws
/// [AppException] only for semantic problems the transport cannot see.
abstract interface class ExerciseRemoteDataSource {
  Future<Map<String, dynamic>> fetchExercises({
    required String categoryId,
    required bool popular,
  });

  Future<Map<String, dynamic>> fetchExerciseDetails(String exerciseId);

  Future<Map<String, dynamic>> fetchTrial(String trialId);

  Future<Map<String, dynamic>> fetchPlayerAttempts({
    required String exerciseId,
    required String playerId,
  });

  Future<void> uploadAttempt({
    required String playerId,
    required String exerciseId,
    required AttemptVideo video,
    UploadProgress? onProgress,
  });
}

@LazySingleton(as: ExerciseRemoteDataSource)
class RetrofitExerciseRemoteDataSource implements ExerciseRemoteDataSource {
  const RetrofitExerciseRemoteDataSource(this._apiService, this._dio);

  final ApiService _apiService;

  /// `DioFactory.getDio()`, provided by `RegisterModule` — **not** `Dio()`.
  final Dio _dio;

  /// The endpoint takes this filter as the *string* `'true'`/`'false'`, which is
  /// why both cubits this replaces wrote `popular: '$popular'` by hand. The
  /// stringification happens once, here, at the wire boundary.
  static String _flag(bool value) => '$value';

  @override
  Future<Map<String, dynamic>> fetchExercises({
    required String categoryId,
    required bool popular,
  }) async =>
      Json.asObject(await _apiService.allExercises(categoryId, _flag(popular)));

  @override
  Future<Map<String, dynamic>> fetchExerciseDetails(String exerciseId) async {
    _requireId(exerciseId);
    return Json.asObject(await _apiService.exerciseDetails(exerciseId));
  }

  @override
  Future<Map<String, dynamic>> fetchTrial(String trialId) async {
    _requireId(trialId);
    return Json.asObject(await _apiService.trialDetails(trialId));
  }

  @override
  Future<Map<String, dynamic>> fetchPlayerAttempts({
    required String exerciseId,
    required String playerId,
  }) async {
    _requireId(exerciseId);
    _requireId(playerId);
    return Json.asObject(
      await _apiService.getPlayerAttempts(exerciseId, playerId),
    );
  }

  /// Posts the video as multipart, reporting progress as it goes.
  @override
  Future<void> uploadAttempt({
    required String playerId,
    required String exerciseId,
    required AttemptVideo video,
    UploadProgress? onProgress,
  }) async {
    _requireId(playerId);
    _requireId(exerciseId);

    final FormData body = FormData.fromMap(<String, dynamic>{
      'Video': await MultipartFile.fromFile(
        video.path,
        // Derived by the value object, which handles both path separators. The
        // three inline `split('/').last` copies this replaces do not.
        filename: video.fileName,
      ),
    });

    await _dio.post<dynamic>(
      '${ApiConstants.apiBaseUrl}${ApiConstants.clubAddAttempt}',
      data: body,
      queryParameters: <String, dynamic>{
        'PlayerId': playerId,
        // Sent as the raw string. The old repo did `int.parse(exerciseId)`,
        // which throws on any non-numeric id, turning a bad argument into an
        // opaque failure.
        'ExerciseId': exerciseId,
      },
      onSendProgress: (int sent, int total) {
        if (total <= 0 || onProgress == null) return;
        onProgress(((sent / total) * 100).round());
      },
    );
  }

  /// A blank id would resolve to a request for *everything*, or for entity zero.
  /// Refuse before it reaches the wire.
  void _requireId(String id) {
    if (id.isEmpty) {
      throw const ServerException(message: FailureMessages.resourceNotFound);
    }
  }
}
