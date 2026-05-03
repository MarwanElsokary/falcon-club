import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../training/data/model/all_exercises_model.dart';

part 'scout_training_state.freezed.dart';

@freezed
class ScoutTrainingState with _$ScoutTrainingState {
  const factory ScoutTrainingState.initial() = _ScoutTrainingInitial;

  const factory ScoutTrainingState.loading() = _ScoutTrainingLoading;

  const factory ScoutTrainingState.success(
      AllExercisesModel allExercisesModel,
      ) = _ScoutTrainingSuccess;

  const factory ScoutTrainingState.error({required String error}) =
  _ScoutTrainingError;
}