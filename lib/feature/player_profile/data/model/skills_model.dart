// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'skills_model.freezed.dart';
// part 'skills_model.g.dart';
//
// @freezed
// class SkillResponse with _$SkillResponse {
//   const factory SkillResponse({
//     @JsonKey(name: 'message') String? message,
//     @JsonKey(name: 'data') List<Skill>? data,
//   }) = _SkillResponse;
//
//   factory SkillResponse.fromJson(Map<String, dynamic> json) =>
//       _$SkillResponseFromJson(json);
// }
//
// @freezed
// class Skill with _$Skill {
//   const factory Skill({
//     @JsonKey(name: 'skillName') required String skillName,
//     @JsonKey(name: 'score') required double score,
//   }) = _Skill;
//
//   factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
// }