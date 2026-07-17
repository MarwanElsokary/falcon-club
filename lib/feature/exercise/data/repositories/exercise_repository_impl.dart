import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/timed_cache.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/exercise.dart';
import '../../domain/entities/exercise_details.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../models/exercise_details_model.dart';
import '../models/exercise_model.dart';
import 'exercise_cache_keys.dart';

/// [ExerciseRepository] over the network, with a short-lived cache in front of
/// exercise details.
///
/// SRP: it maps wire shapes to entities, decides what is worth caching, and
/// turns thrown exceptions into [Failure] values. It does not know how to make a
/// request (the data source does) or what an HTTP client is.
///
/// Every method funnels errors through [ErrorMapper], so no `try/catch` leaks
/// upward — no use case or cubit in this feature contains one.
@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  const ExerciseRepositoryImpl(
    this._remoteDataSource,
    this._cache,
    this._errorMapper,
  );

  final ExerciseRemoteDataSource _remoteDataSource;
  final TimedCache _cache;
  final ErrorMapper _errorMapper;

  /// The exercise **list** is deliberately not cached.
  ///
  /// It is re-filtered by category on every chip tap, so a cache keyed by filter
  /// would multiply entries while saving nothing, and one ignoring the filter
  /// would serve the wrong list. The old code did not cache it either — this is
  /// a considered non-change, not an omission.
  @override
  ResultFuture<List<Exercise>> getExercises({
    required String categoryId,
    required bool popular,
  }) async {
    try {
      final Map<String, dynamic> body = await _remoteDataSource.fetchExercises(
        categoryId: categoryId,
        popular: popular,
      );
      return Right<Failure, List<Exercise>>(_exercisesFrom(body));
    } catch (error) {
      return Left<Failure, List<Exercise>>(_errorMapper.map(error));
    }
  }

  /// Details **are** cached, for [ExerciseCacheKeys.detailsMaxAge].
  ///
  /// The old repositories cached this forever, under two different keys, so an
  /// attempt count could stay wrong until the user signed out. One key, one TTL,
  /// and `AttemptRepositoryImpl` invalidates it the moment an upload succeeds.
  @override
  ResultFuture<ExerciseDetails> getExerciseDetails(String exerciseId) async {
    try {
      final String key = ExerciseCacheKeys.details(exerciseId);

      final Map<String, dynamic>? cached = _cache.read(
        key,
        maxAge: ExerciseCacheKeys.detailsMaxAge,
      );
      if (cached != null) {
        return Right<Failure, ExerciseDetails>(
          ExerciseDetailsModel.fromJson(cached),
        );
      }

      final Map<String, dynamic> body = await _remoteDataSource
          .fetchExerciseDetails(exerciseId);
      await _store(key, body);

      return Right<Failure, ExerciseDetails>(
        ExerciseDetailsModel.fromJson(body),
      );
    } catch (error) {
      return Left<Failure, ExerciseDetails>(_errorMapper.map(error));
    }
  }

  List<Exercise> _exercisesFrom(Map<String, dynamic> body) {
    final Object? rows = body['data'];
    if (rows is! List) return const <Exercise>[];
    return rows
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .map(ExerciseModel.fromJson)
        .toList(growable: false);
  }

  /// Caching is best-effort. A failed write must not fail a request that already
  /// succeeded — the caller has its data either way.
  Future<void> _store(String key, Map<String, dynamic> body) async {
    try {
      await _cache.write(key, body);
    } catch (_) {
      // Not fatal.
    }
  }
}
