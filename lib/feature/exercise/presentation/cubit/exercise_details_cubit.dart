import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/exercise_details.dart';
import '../../domain/usecases/get_exercise_details.dart';
import 'exercise_details_state.dart';

/// Drives the exercise-details screen — the merged Club/Scout/MainClub screen.
///
/// ## One cubit, one fetch
///
/// This replaces two cubits that each hit `club/GetExercise` on every open —
/// `TrainingDetailsCubit` for the details, `ExerciseRosterCubit` for the players
/// — into two separate caches. The response carries both, so one
/// [GetExerciseDetails] call now serves the whole screen (DIP: it depends on the
/// use case, never a repository or Dio).
///
/// [reload] exists for the post-upload refresh. `AttemptRepositoryImpl`
/// invalidates the cached details the moment an upload succeeds, so a reload
/// misses the cache and refetches — which is how the attempt count updates
/// without the in-memory map + manual eviction the old roster cubit needed.
@injectable
class ExerciseDetailsCubit extends Cubit<ExerciseDetailsState> {
  ExerciseDetailsCubit(this._getExerciseDetails)
    : super(const ExerciseDetailsInitial());

  final GetExerciseDetails _getExerciseDetails;

  Future<void> load(String exerciseId) async {
    if (isClosed) return;
    emit(const ExerciseDetailsLoading());

    final result = await _getExerciseDetails(exerciseId);
    if (isClosed) return;

    emit(
      result.match(
        (failure) => ExerciseDetailsFailure(failure.message),
        (ExerciseDetails details) => ExerciseDetailsLoaded(details),
      ),
    );
  }

  /// Refetch after an attempt upload changed a player's count. Same as [load] —
  /// named for intent at the call site.
  Future<void> reload(String exerciseId) => load(exerciseId);
}
