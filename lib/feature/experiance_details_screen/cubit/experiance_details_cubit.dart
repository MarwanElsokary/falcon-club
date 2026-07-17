import 'package:bloc/bloc.dart';
import '../data/model/exerciseWithPlayersModel.dart';
import '../data/repo/experiance_details_repo.dart';
import 'experiance_details_state.dart';

class ExperianceDetailsCubit extends Cubit<ExperianceDetailsState> {
  final ExperianceDetailsRepo _repo;

  ExperianceDetailsCubit(this._repo)
    : super(ExperianceDetailsState.initial());

  final Map<String, ExerciseDetailsWithPlayersModel> _exerciseCache = {};

  // ── تفاصيل التجربة ─────────────────────────────────────────────
  void emittrialsDetails({required String trialId}) async {
    emit(const ExperianceDetailsState.trialsDetailsLoading());
    final response = await _repo.trialDetails(trialId: trialId);
    response.when(
      success: (data) =>
          emit(ExperianceDetailsState.trialsDetailssuccess(data)),
      failure: (error) => emit(
        ExperianceDetailsState.trialsDetailserror(
          error: error.apiErrorModel.message ?? '',
        ),
      ),
    );
  }

  // ── اللاعبين في تمرين ──────────────────────────────────────────
  Future<void> fetchExercisePlayers({required String exerciseId}) async {
    if (_exerciseCache.containsKey(exerciseId)) {
      emit(
        ExperianceDetailsState.exercisePlayerssuccess(
          exerciseId: exerciseId,
          data: _exerciseCache[exerciseId]!,
        ),
      );
      return;
    }
    emit(ExperianceDetailsState.exercisePlayersLoading(exerciseId: exerciseId));
    final response = await _repo.exercisePlayers(exerciseId: exerciseId);
    response.when(
      success: (data) {
        _exerciseCache[exerciseId] = data;
        emit(
          ExperianceDetailsState.exercisePlayerssuccess(
            exerciseId: exerciseId,
            data: data,
          ),
        );
      },
      failure: (error) => emit(
        ExperianceDetailsState.exercisePlayerserror(
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
  /// upload itself now runs in `AttemptUploadCubit`, which cannot reach this
  /// cubit's in-memory cache, so [fetchExercisePlayers] alone would return the
  /// stale entry it holds. This drops that entry first, then refetches.
  Future<void> refreshExercisePlayers({required String exerciseId}) {
    _exerciseCache.remove(exerciseId);
    return fetchExercisePlayers(exerciseId: exerciseId);
  }
}
