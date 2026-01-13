import '../../../training_details/data/model/exercise_details_model.dart';

class SkillsModel {
  dynamic message;
  List<Skill> data;

  SkillsModel({required this.message, required this.data});

  factory SkillsModel.fromJson(Map<String, dynamic> json) => SkillsModel(
    message: json["message"],
    data: List<Skill>.from(
        json["data"].map((x) => Skill.fromJson(x))),
  );
}

