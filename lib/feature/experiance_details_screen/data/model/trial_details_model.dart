// To parse this JSON data, do
//
//     final trialDetailsModel = trialDetailsModelFromJson(jsonString);

import 'dart:convert';

TrialDetailsModel trialDetailsModelFromJson(String str) =>
    TrialDetailsModel.fromJson(json.decode(str));

String trialDetailsModelToJson(TrialDetailsModel data) =>
    json.encode(data.toJson());

class TrialDetailsModel {
  dynamic message;
  Data data;

  TrialDetailsModel({required this.message, required this.data});

  factory TrialDetailsModel.fromJson(Map<String, dynamic> json) =>
      TrialDetailsModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  dynamic trialTitle;
  dynamic trialPhoto;
  dynamic minAge;
  dynamic maxAge;
  dynamic gender;
  dynamic country;
  dynamic exerciseCount;
  List<Exercise> exercises;

  Data({
    required this.trialTitle,
    required this.trialPhoto,
    required this.minAge,
    required this.maxAge,
    required this.gender,
    required this.country,
    required this.exerciseCount,
    required this.exercises,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    trialTitle: json["trialTitle"],
    trialPhoto: json["trialPhoto"],
    minAge: json["minAge"],
    maxAge: json["maxAge"],
    gender: json["gender"],
    country: json["country"],
    exerciseCount: json["exerciseCount"],
    exercises: List<Exercise>.from(
      json["exercises"].map((x) => Exercise.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "trialTitle": trialTitle,
    "trialPhoto": trialPhoto,
    "minAge": minAge,
    "maxAge": maxAge,
    "gender": gender,
    "country": country,
    "exerciseCount": exerciseCount,
    "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
  };
}

class Exercise {
  dynamic id;
  dynamic isClosed;
  dynamic photoPath;
  dynamic title;
  dynamic description;

  /// The exercise's own colour, as a bare hex string ("0C5147").
  ///
  /// The backend has always sent this; the card ignored it and cycled a
  /// hard-coded palette by list index instead. Nullable, so an exercise without
  /// one falls back to that palette rather than rendering blank.
  dynamic colorCode;

  List<dynamic> skills;

  Exercise({
    required this.id,
    required this.isClosed,
    required this.photoPath,
    required this.title,
    required this.description,
    required this.skills,
    this.colorCode,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json["id"],
    isClosed: json["isClosed"],
    photoPath: json["photoPath"],
    title: json["title"],
    description: json["description"],
    colorCode: json["colorCode"],
    skills: List<String>.from(json["skills"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isClosed": isClosed,
    "photoPath": photoPath,
    "title": title,
    "description": description,
    "colorCode": colorCode,
    "skills": List<dynamic>.from(skills.map((x) => x)),
  };
}
