import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/timed_cache.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/attempt.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/value_objects/attempt_video.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../models/attempt_model.dart';
import 'exercise_cache_keys.dart';

/// [AttemptRepository] over the network.
///
/// Attempts themselves are **not cached**: they are the thing that changes. An
/// attempt moves from under-review to completed when the AI pipeline finishes,
/// with no client involvement, so serving a stale list is exactly the failure
/// mode to avoid.
@LazySingleton(as: AttemptRepository)
class AttemptRepositoryImpl implements AttemptRepository {
  const AttemptRepositoryImpl(
    this._remoteDataSource,
    this._cache,
    this._errorMapper,
  );

  final ExerciseRemoteDataSource _remoteDataSource;
  final TimedCache _cache;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<List<Attempt>> getPlayerAttempts({
    required String exerciseId,
    required String playerId,
  }) async {
    try {
      final body = await _remoteDataSource.fetchPlayerAttempts(
        exerciseId: exerciseId,
        playerId: playerId,
      );
      return Right<Failure, List<Attempt>>(AttemptModel.listFromJson(body));
    } catch (error) {
      return Left<Failure, List<Attempt>>(_errorMapper.map(error));
    }
  }

  /// Uploads the attempt and **invalidates the exercise's cached details**.
  ///
  /// That second step is the whole reason this repository holds a cache it does
  /// not otherwise read: the roster inside `club/GetExercise` carries each
  /// player's `attemptCount`, and an upload has just changed it. Without the
  /// eviction, a coach uploads a video, returns to the exercise, and sees the
  /// old count — which is precisely what happens today, except today the entry
  /// never expires at all, so it is wrong until sign-out.
  ///
  /// Eviction happens only on success. A failed upload changed nothing, so
  /// throwing away a valid cache entry would just cost a needless request.
  @override
  ResultVoid uploadAttemptForPlayer({
    required String playerId,
    required String exerciseId,
    required AttemptVideo video,
    UploadProgress? onProgress,
  }) async {
    try {
      await _remoteDataSource.uploadAttempt(
        playerId: playerId,
        exerciseId: exerciseId,
        video: video,
        onProgress: onProgress,
      );
      await _cache.invalidate(ExerciseCacheKeys.details(exerciseId));
      return const Right<Failure, void>(null);
    } catch (error) {
      return Left<Failure, void>(_errorMapper.map(error));
    }
  }
}
