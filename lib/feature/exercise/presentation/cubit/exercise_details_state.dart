import 'package:equatable/equatable.dart';

import '../../domain/entities/exercise_details.dart';

/// State of the exercise-details screen.
///
/// Replaces the two-cubit arrangement it succeeds: `TrainingDetailsCubit` (which
/// carried a data-layer `ExerciseDetailsModel`) plus `ExerciseRosterCubit` (which
/// carried `ExerciseDetailsWithPlayersModel`). Both fetched the *same*
/// `club/GetExercise` endpoint. One [ExerciseDetails] entity now carries the
/// details **and** the players roster, so one load serves the whole screen.
sealed class ExerciseDetailsState extends Equatable {
  const ExerciseDetailsState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class ExerciseDetailsInitial extends ExerciseDetailsState {
  const ExerciseDetailsInitial();
}

final class ExerciseDetailsLoading extends ExerciseDetailsState {
  const ExerciseDetailsLoading();
}

final class ExerciseDetailsLoaded extends ExerciseDetailsState {
  const ExerciseDetailsLoaded(this.details);

  final ExerciseDetails details;

  @override
  List<Object?> get props => <Object?>[details];
}

final class ExerciseDetailsFailure extends ExerciseDetailsState {
  const ExerciseDetailsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
