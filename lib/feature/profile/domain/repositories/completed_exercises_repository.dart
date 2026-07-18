import '../../../../core/usecase/usecase.dart';
import '../entities/completed_exercise.dart';

/// The exercises a player has completed (`Player/GetPlayerExercises`).
abstract interface class CompletedExercisesRepository {
  ResultFuture<List<CompletedExercise>> getPlayerExercises(String playerId);
}
