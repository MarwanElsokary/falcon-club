import 'package:falcon/feature/training_details/data/model/exercise_details_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'training_details_state.freezed.dart';

@freezed
class TrainingDetailsState with _$TrainingDetailsState {
  const factory TrainingDetailsState.initial() = _Initial;

  const factory TrainingDetailsState.exerciseDetailsLoading() =
      exerciseDetailsLoading;
  const factory TrainingDetailsState.exerciseDetailssuccess(
    ExerciseDetailsModel exerciseDetailsModel,
  ) = exerciseDetailsSuccess;
  const factory TrainingDetailsState.exerciseDetailserror({
    required String error,
  }) = exerciseDetailsError;

  const factory TrainingDetailsState.addAttemptLoading() = addAttemptLoading;
  const factory TrainingDetailsState.addAttemptProgress(progress) =
      addAttemptProgress;

  const factory TrainingDetailsState.addAttemptsuccess() = addAttemptSuccess;
  const factory TrainingDetailsState.addAttempterror({required String error}) =
      addAttemptError;
}
