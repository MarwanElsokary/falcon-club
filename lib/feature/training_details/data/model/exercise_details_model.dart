// To parse this JSON data, do
//
//     final exerciseDetailsModel = exerciseDetailsModelFromJson(jsonString);

import 'dart:convert';

ExerciseDetailsModel exerciseDetailsModelFromJson(String str) =>
    ExerciseDetailsModel.fromJson(json.decode(str));

String exerciseDetailsModelToJson(ExerciseDetailsModel data) =>
    json.encode(data.toJson());

class ExerciseDetailsModel {
  dynamic message;
  Data data;

  ExerciseDetailsModel({required this.message, required this.data});

  factory ExerciseDetailsModel.fromJson(Map<String, dynamic> json) =>
      ExerciseDetailsModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  dynamic id;
  dynamic photoPath;
  dynamic title;
  dynamic description;
  dynamic attemptsCount;
  dynamic score;
  List<Video> videos;
  List<String> skills;
  List<Equipment> equipments;
  List<dynamic> strengths;
  List<dynamic> improvementAreas;
  List<String> playerInstructions;
  List<dynamic> recommendedExercises;
  List<Attempt> attempts;

  Data({
    required this.id,
    required this.photoPath,
    required this.title,
    required this.description,
    required this.attemptsCount,
    required this.score,
    required this.videos,
    required this.skills,
    required this.equipments,
    required this.strengths,
    required this.improvementAreas,
    required this.playerInstructions,
    required this.recommendedExercises,
    required this.attempts,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    photoPath: json["photoPath"],
    title: json["title"],
    description: json["description"],
    attemptsCount: json["attemptsCount"],
    score: json["score"],
    videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
    skills: List<String>.from(json["skills"].map((x) => x)),
    equipments: List<Equipment>.from(
      json["equipments"].map((x) => Equipment.fromJson(x)),
    ),
    strengths: List<dynamic>.from(json["strengths"].map((x) => x)),
    improvementAreas: List<dynamic>.from(
      json["improvementAreas"].map((x) => x),
    ),
    playerInstructions: List<String>.from(
      json["playerInstructions"].map((x) => x),
    ),
    recommendedExercises: List<dynamic>.from(
      json["recommendedExercises"].map((x) => x),
    ),
    attempts: List<Attempt>.from(
      json["attempts"].map((x) => Attempt.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photoPath": photoPath,
    "title": title,
    "description": description,
    "attemptsCount": attemptsCount,
    "score": score,
    "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
    "skills": List<dynamic>.from(skills.map((x) => x)),
    "equipments": List<dynamic>.from(equipments.map((x) => x.toJson())),
    "strengths": List<dynamic>.from(strengths.map((x) => x)),
    "improvementAreas": List<dynamic>.from(improvementAreas.map((x) => x)),
    "playerInstructions": List<dynamic>.from(playerInstructions.map((x) => x)),
    "recommendedExercises": List<dynamic>.from(
      recommendedExercises.map((x) => x),
    ),
    "attempts": List<dynamic>.from(attempts.map((x) => x.toJson())),
  };
}

class Attempt {
  dynamic id;
  dynamic video;
  dynamic date;
  dynamic isProcessed;
  dynamic rejectedReason;
  dynamic aiVideo;
  dynamic visualizeVideo;
  List<Skill> skills;

  Attempt({
    required this.id,
    required this.video,
    required this.date,
    required this.isProcessed,
    required this.rejectedReason,
    required this.aiVideo,
    required this.visualizeVideo,
    required this.skills,
  });

  factory Attempt.fromJson(Map<String, dynamic> json) => Attempt(
    id: json["id"],
    video: json["video"],
    date: json["date"],
    isProcessed: json["isProcessed"],
    rejectedReason: json["rejectedReason"],
    aiVideo: json["aiVideo"],
    visualizeVideo: json["visualizeVideo"],
    skills: List<Skill>.from(json["skills"].map((x) => Skill.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video,
    "date": date,
    "isProcessed": isProcessed,
    "rejectedReason": rejectedReason,
    "aiVideo": aiVideo,
    "visualizeVideo": visualizeVideo,
    "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
  };
}

class SkillsResponse {
  final String message;
  final List<Skill> data;

  SkillsResponse({required this.message, required this.data});

  factory SkillsResponse.fromJson(Map<String, dynamic> json) => SkillsResponse(
    message: json["message"] ?? '',
    data: List<Skill>.from(
      (json["data"] as List?)?.map((x) => Skill.fromJson(x)) ?? [],
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Skill {
  final String skillName;
  final double score;

  Skill({required this.skillName, required this.score});

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    skillName: json["skillName"] ?? '',
    score: json["score"]?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toJson() => {"skillName": skillName, "score": score};

  @override
  String toString() => 'Skill(skillName: "$skillName", score: $score)';
}

class Equipment {
  dynamic name;
  dynamic image;

  Equipment({required this.name, required this.image});

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      Equipment(name: json["name"], image: json["image"]);

  Map<String, dynamic> toJson() => {"name": name, "image": image};
}

class Video {
  dynamic video;
  dynamic description;
  dynamic number;

  Video({required this.video, required this.description, required this.number});

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    video: json["video"],
    description: json["description"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "video": video,
    "description": description,
    "number": number,
  };
}
