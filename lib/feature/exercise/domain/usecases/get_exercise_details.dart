import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise_details.dart';
import '../repositories/exercise_repository.dart';

/// Loads one exercise and the roster of the caller's own players on it.
///
/// Replaces three cubits that each fetched this separately —
/// `TrainingDetailsCubit.emitexerciseDetails`,
/// `ScoutTrainingDetailsCubit.fetchExerciseDetails` and
/// `ExperianceDetailsCubit.fetchExercisePlayers` — against the *same* endpoint,
/// into two different models, under two different cache keys, one of which was
/// an in-memory map on the cubit.
@injectable
class GetExerciseDetails implements UseCase<ExerciseDetails, String> {
  const GetExerciseDetails(this._repository);

  final ExerciseRepository _repository;

  @override
  ResultFuture<ExerciseDetails> call(String exerciseId) =>
      _repository.getExerciseDetails(exerciseId);
}
