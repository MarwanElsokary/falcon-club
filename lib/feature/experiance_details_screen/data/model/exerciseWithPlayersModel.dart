// model for GET /api/Club/GetExercise response
// includes players who have attempts on this exercise

import 'dart:convert';

ExerciseDetailsWithPlayersModel exerciseDetailsWithPlayersModelFromJson(
    String str) =>
    ExerciseDetailsWithPlayersModel.fromJson(json.decode(str));

class ExerciseDetailsWithPlayersModel {
  dynamic message;
  ExerciseWithPlayersData data;

  ExerciseDetailsWithPlayersModel({
    required this.message,
    required this.data,
  });

  factory ExerciseDetailsWithPlayersModel.fromJson(
      Map<String, dynamic> json) =>
      ExerciseDetailsWithPlayersModel(
        message: json["message"],
        data: ExerciseWithPlayersData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class ExerciseWithPlayersData {
  dynamic id;
  dynamic photoPath;
  dynamic title;
  dynamic description;
  List<dynamic> skills;
  List<dynamic> equipments;
  List<dynamic> playerInstructions;
  List<dynamic> videos;
  List<ExercisePlayer> players;

  ExerciseWithPlayersData({
    required this.id,
    required this.photoPath,
    required this.title,
    required this.description,
    required this.skills,
    required this.equipments,
    required this.playerInstructions,
    required this.videos,
    required this.players,
  });

  factory ExerciseWithPlayersData.fromJson(Map<String, dynamic> json) =>
      ExerciseWithPlayersData(
        id: json["id"],
        photoPath: json["photoPath"],
        title: json["title"],
        description: json["description"],
        skills: List<dynamic>.from(json["skills"] ?? []),
        equipments: List<dynamic>.from(json["equipments"] ?? []),
        playerInstructions:
        List<dynamic>.from(json["playerInstructions"] ?? []),
        videos: List<dynamic>.from(json["videos"] ?? []),
        players: List<ExercisePlayer>.from(
          (json["players"] ?? []).map((x) => ExercisePlayer.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photoPath": photoPath,
    "title": title,
    "description": description,
    "skills": skills,
    "equipments": equipments,
    "playerInstructions": playerInstructions,
    "videos": videos,
    "players": List<dynamic>.from(players.map((x) => x.toJson())),
  };
}

class ExercisePlayer {
  dynamic id;
  dynamic photo;
  dynamic age;
  dynamic name;
  dynamic position;
  dynamic attemptCount;

  ExercisePlayer({
    required this.id,
    required this.photo,
    required this.age,
    required this.name,
    required this.position,
    required this.attemptCount,
  });

  factory ExercisePlayer.fromJson(Map<String, dynamic> json) => ExercisePlayer(
    id: json["id"],
    photo: json["photo"],
    age: json["age"],
    name: json["name"],
    position: json["position"],
    attemptCount: json["attemptCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photo": photo,
    "age": age,
    "name": name,
    "position": position,
    "attemptCount": attemptCount,
  };
}