// To parse this JSON data, do
//
//     final rankModel = rankModelFromJson(jsonString);

import 'dart:convert';

RankModel rankModelFromJson(String str) => RankModel.fromJson(json.decode(str));

String rankModelToJson(RankModel data) => json.encode(data.toJson());

class RankModel {
  dynamic message;
  List<RankList> data;

  RankModel({required this.message, required this.data});

  factory RankModel.fromJson(Map<String, dynamic> json) => RankModel(
    message: json["message"],
    data: List<RankList>.from(json["data"].map((x) => RankList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RankList {
  dynamic id;
  dynamic tps;
  dynamic photoPath;
  dynamic name;
  dynamic age;

  dynamic position;

  RankList({
    required this.id,
    required this.tps,
    required this.photoPath,
    required this.name,
    required this.age,

    required this.position,
  });

  factory RankList.fromJson(Map<String, dynamic> json) => RankList(
    id: json["id"],
    tps: json["tps"]?.toDouble(),
    photoPath: json["photoPath"],
    name: json["name"],
    age: json["age"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tps": tps,
    "photoPath": photoPath,
    "name": name,
    "age": age,

    "position": position,
  };
}
