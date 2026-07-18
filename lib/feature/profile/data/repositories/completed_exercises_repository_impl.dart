import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/completed_exercise.dart';
import '../../domain/repositories/completed_exercises_repository.dart';
import '../datasources/completed_exercises_remote_data_source.dart';
import '../models/completed_exercise_model.dart';

@LazySingleton(as: CompletedExercisesRepository)
class CompletedExercisesRepositoryImpl
    implements CompletedExercisesRepository {
  const CompletedExercisesRepositoryImpl(
    this._remoteDataSource,
    this._errorMapper,
  );

  final CompletedExercisesRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<List<CompletedExercise>> getPlayerExercises(
    String playerId,
  ) async {
    try {
      final List<Map<String, dynamic>> raw = await _remoteDataSource
          .fetchPlayerExercises(playerId);
      return Right<Failure, List<CompletedExercise>>(
        raw.map(CompletedExerciseModel.fromJson).toList(growable: false),
      );
    } catch (error) {
      return Left<Failure, List<CompletedExercise>>(_errorMapper.map(error));
    }
  }
}
