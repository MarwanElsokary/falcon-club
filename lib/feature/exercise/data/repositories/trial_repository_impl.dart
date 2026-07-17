import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/timed_cache.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/trial.dart';
import '../../domain/repositories/trial_repository.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../models/trial_model.dart';
import 'exercise_cache_keys.dart';

/// [TrialRepository] over the network, with a cache in front.
///
/// The repository this replaces caches trials too — but decodes the cached JSON
/// with **no guard** (`experiance_details_repo:23-29`). One corrupt blob and
/// `jsonDecode` throws into the outer `catch`, which returns a failure. Forever:
/// nothing clears the entry, so the trial screen stays broken until the user
/// signs out. [TimedCache] evicts a corrupt entry and misses, so the next read
/// simply goes to the network.
@LazySingleton(as: TrialRepository)
class TrialRepositoryImpl implements TrialRepository {
  const TrialRepositoryImpl(
    this._remoteDataSource,
    this._cache,
    this._errorMapper,
  );

  final ExerciseRemoteDataSource _remoteDataSource;
  final TimedCache _cache;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<Trial> getTrialDetails(String trialId) async {
    try {
      final String key = ExerciseCacheKeys.trial(trialId);

      final Map<String, dynamic>? cached = _cache.read(
        key,
        maxAge: ExerciseCacheKeys.trialMaxAge,
      );
      if (cached != null) {
        return Right<Failure, Trial>(TrialModel.fromJson(cached));
      }

      final Map<String, dynamic> body = await _remoteDataSource.fetchTrial(
        trialId,
      );
      await _store(key, body);

      return Right<Failure, Trial>(TrialModel.fromJson(body));
    } catch (error) {
      return Left<Failure, Trial>(_errorMapper.map(error));
    }
  }

  /// Best-effort: a failed cache write must not fail a successful request.
  Future<void> _store(String key, Map<String, dynamic> body) async {
    try {
      await _cache.write(key, body);
    } catch (_) {
      // Not fatal.
    }
  }
}
