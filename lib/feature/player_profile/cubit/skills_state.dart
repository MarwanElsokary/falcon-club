import 'package:freezed_annotation/freezed_annotation.dart';

import '../../training_details/data/model/exercise_details_model.dart';

part 'skills_state.freezed.dart';

@freezed
class SkillsState with _$SkillsState {
  const factory SkillsState.initial() = _Initial;
  const factory SkillsState.loading() = Loading;
  const factory SkillsState.success(List<Skill> skills) = Success;
  const factory SkillsState.error(String message) = Error;
}