import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/completed_exercise.dart';
import '../repositories/completed_exercises_repository.dart';

/// Loads the exercises a player has completed (`Player/GetPlayerExercises`).
@injectable
class GetPlayerExercises
    implements UseCase<List<CompletedExercise>, String> {
  const GetPlayerExercises(this._repository);

  final CompletedExercisesRepository _repository;

  @override
  ResultFuture<List<CompletedExercise>> call(String playerId) =>
      _repository.getPlayerExercises(playerId);
}
