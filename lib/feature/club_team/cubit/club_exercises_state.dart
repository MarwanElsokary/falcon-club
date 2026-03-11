import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/model/club_exercises_model.dart';

part 'club_exercises_state.freezed.dart';

@freezed
class ClubExercisesState with _$ClubExercisesState {
  const factory ClubExercisesState.initial()                          = _Initial;
  const factory ClubExercisesState.loading()                          = _Loading;
  const factory ClubExercisesState.success(ClubExercisesModel model)  = _Success;
  const factory ClubExercisesState.error({required String error})     = _Error;
}