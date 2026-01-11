import 'package:falcon/feature/training_details/data/model/exercise_details_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/model/profile_feat.dart';

part 'skills_state.freezed.dart';

@freezed
class SkillsState with _$SkillsState {
  const factory SkillsState.initial() = _Initial;

  const factory SkillsState.loading() = SkillsLoading;

  const factory SkillsState.success(
      Skill skillsModel,
      ) = SkillsSuccess;

  const factory SkillsState.error({
    required String error,
  }) = SkillsError;
}
