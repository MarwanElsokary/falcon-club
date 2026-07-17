import 'package:falconclubapp/feature/experiance_details_screen/data/model/exerciseWithPlayersModel.dart';
import 'package:falconclubapp/feature/experiance_details_screen/data/model/trial_details_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'experiance_details_state.freezed.dart';

@freezed
class ExperianceDetailsState with _$ExperianceDetailsState {
  const factory ExperianceDetailsState.initial() = _Initial;

  // ── trial details ───────────────────────────────────────────────
  const factory ExperianceDetailsState.trialsDetailsLoading() =
  trialsDetailsLoading;
  const factory ExperianceDetailsState.trialsDetailssuccess(
      TrialDetailsModel trialDetailsModel,
      ) = trialsDetailsSuccess;
  const factory ExperianceDetailsState.trialsDetailserror({
    required String error,
  }) = trialsDetailsError;

  // ── exercise players ────────────────────────────────────────────
  const factory ExperianceDetailsState.exercisePlayersLoading({
    required String exerciseId,
  }) = exercisePlayersLoading;
  const factory ExperianceDetailsState.exercisePlayerssuccess({
    required String exerciseId,
    required ExerciseDetailsWithPlayersModel data,
  }) = exercisePlayersSuccess;
  const factory ExperianceDetailsState.exercisePlayerserror({
    required String exerciseId,
    required String error,
  }) = exercisePlayersError;

  // The attempt-upload states moved to `AttemptUploadCubit` in the exercise
  // feature (Phase 5). Uploading is no longer this cubit's concern — it owns
  // trial details and the player roster only.
}