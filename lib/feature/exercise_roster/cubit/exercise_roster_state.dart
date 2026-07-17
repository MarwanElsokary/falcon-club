import 'package:falconclubapp/feature/exercise_roster/data/model/exercise_with_players_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'exercise_roster_state.freezed.dart';

/// The players roster for an exercise, keyed by `exerciseId`.
///
/// This is the roster half of the old two-headed `ExperianceDetailsState`; its
/// trial-details cases moved to `TrialDetailsCubit` in Phase 7. The union case
/// names are unchanged so the exercise-details screen that consumes them did not
/// have to touch its `when`/`maybeWhen` branches — only the state type.
@freezed
class ExerciseRosterState with _$ExerciseRosterState {
  const factory ExerciseRosterState.initial() = _Initial;

  const factory ExerciseRosterState.exercisePlayersLoading({
    required String exerciseId,
  }) = exercisePlayersLoading;
  const factory ExerciseRosterState.exercisePlayerssuccess({
    required String exerciseId,
    required ExerciseDetailsWithPlayersModel data,
  }) = exercisePlayersSuccess;
  const factory ExerciseRosterState.exercisePlayerserror({
    required String exerciseId,
    required String error,
  }) = exercisePlayersError;
}
