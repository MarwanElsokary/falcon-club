import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../training_details/data/model/exercise_details_model.dart';

part 'scout_training_details_state.freezed.dart';

@freezed
class ScoutTrainingDetailsState with _$ScoutTrainingDetailsState {
  const factory ScoutTrainingDetailsState.initial() =
  _ScoutTrainingDetailsInitial;

  const factory ScoutTrainingDetailsState.loading() =
  _ScoutTrainingDetailsLoading;

  const factory ScoutTrainingDetailsState.success(
      ExerciseDetailsModel exerciseDetailsModel,
      ) = _ScoutTrainingDetailsSuccess;

  const factory ScoutTrainingDetailsState.error({required String error}) =
  _ScoutTrainingDetailsError;
}