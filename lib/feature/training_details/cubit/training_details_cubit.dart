import 'package:bloc/bloc.dart';

import '../data/repo/training_details_repo.dart';
import 'training_details_state.dart';

class TrainingDetailsCubit extends Cubit<TrainingDetailsState> {
  final TrainingDetailsRepo _repo;
  TrainingDetailsCubit(this._repo) : super(TrainingDetailsState.initial());

  // ── الـ exerciseId الحالي — بيستخدمه ExerciseDetailsScreen ─
  String? currentExerciseId;

  // MARK: - exerciseDetails
  void emitexerciseDetails({required String exerciseId}) async {
    currentExerciseId = exerciseId;
    emit(const TrainingDetailsState.exerciseDetailsLoading());
    final response = await _repo.exerciseDetails(exerciseId: exerciseId);
    response.when(
      success: (data) {
        emit(TrainingDetailsState.exerciseDetailssuccess(data));
      },
      failure: (error) {
        emit(
          TrainingDetailsState.exerciseDetailserror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

// `emitAddAttemptStates` and the mutable `videoPath` field were removed here.
//
// They drove `Player/AddAttempt` (a player uploading their own attempt), which
// this app does not do — and nothing called them. The Club's upload goes through
// `Club/AddAttempt` via `ExperianceDetailsCubit.addAttemptForPlayer`, and moves
// to `UploadAttemptForPlayer` in Phase 5.
//
// The four `TrainingDetailsState.addAttempt*` cases they emitted are now unused
// too; they are left in place only because the freezed state class is shared with
// the still-live `exerciseDetails*` cases, and are deleted with the rest of this
// feature in Phase 8.
}
