import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/model/all_exercises_model.dart';
part 'training_state.freezed.dart';

@freezed
class TrainingState with _$TrainingState {
  const factory TrainingState.initial() = _Initial;
  //allExercises
  const factory TrainingState.allExercisesLoading() = allExercisesLoading;
  const factory TrainingState.allExercisessuccess(
    AllExercisesModel allExercisesModel,
  ) = allExercisesSuccess;
  const factory TrainingState.allExerciseserror({required String error}) =
      allExercisesError;
}
