import 'package:bloc/bloc.dart';
import '../data/model/exercise_with_players_model.dart';
import '../data/repo/exercise_roster_repo.dart';
import 'exercise_roster_state.dart';

/// Holds the players roster for an exercise (the "who has this exercise" list on
/// the exercise-details screen).
///
/// The roster half of the old two-headed `ExperianceDetailsCubit`; its trial
/// details moved to `TrialDetailsCubit` in Phase 7. Full migration onto the
/// exercise domain (`GetExerciseDetails`) is still deferred — this remains the
/// legacy `ApiResult` path for now.
class ExerciseRosterCubit extends Cubit<ExerciseRosterState> {
  final ExerciseRosterRepo _repo;

  ExerciseRosterCubit(this._repo) : super(ExerciseRosterState.initial());

  final Map<String, ExerciseDetailsWithPlayersModel> _exerciseCache = {};

  Future<void> fetchExercisePlayers({required String exerciseId}) async {
    if (_exerciseCache.containsKey(exerciseId)) {
      emit(
        ExerciseRosterState.exercisePlayerssuccess(
          exerciseId: exerciseId,
          data: _exerciseCache[exerciseId]!,
        ),
      );
      return;
    }
    emit(ExerciseRosterState.exercisePlayersLoading(exerciseId: exerciseId));
    final response = await _repo.exercisePlayers(exerciseId: exerciseId);
    response.when(
      success: (data) {
        _exerciseCache[exerciseId] = data;
        emit(
          ExerciseRosterState.exercisePlayerssuccess(
            exerciseId: exerciseId,
            data: data,
          ),
        );
      },
      failure: (error) => emit(
        ExerciseRosterState.exercisePlayerserror(
          exerciseId: exerciseId,
          error: error.apiErrorModel.message ?? '',
        ),
      ),
    );
  }

  ExerciseDetailsWithPlayersModel? getCachedExercisePlayers(String exerciseId) {
    return _exerciseCache[exerciseId];
  }

  /// Evicts the cached roster for [exerciseId] and reloads it from the network.
  ///
  /// Called after an attempt upload changes a player's `attemptCount`. The
  /// upload runs in `AttemptUploadCubit`, which cannot reach this cubit's
  /// in-memory cache, so [fetchExercisePlayers] alone would return the stale
  /// entry it holds. This drops that entry first, then refetches.
  Future<void> refreshExercisePlayers({required String exerciseId}) {
    _exerciseCache.remove(exerciseId);
    return fetchExercisePlayers(exerciseId: exerciseId);
  }
}
