// To parse this JSON data, do
//
//     final allExercisesModel = allExercisesModelFromJson(jsonString);

import 'dart:convert';

AllExercisesModel allExercisesModelFromJson(String str) =>
    AllExercisesModel.fromJson(json.decode(str));

String allExercisesModelToJson(AllExercisesModel data) =>
    json.encode(data.toJson());

class AllExercisesModel {
  dynamic message;
  List<AllExerciseList> data;

  AllExercisesModel({required this.message, required this.data});

  factory AllExercisesModel.fromJson(Map<String, dynamic> json) =>
      AllExercisesModel(
        message: json["message"],
        data: List<AllExerciseList>.from(
          json["data"].map((x) => AllExerciseList.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllExerciseList {
  dynamic id;
  dynamic photoPath;
  dynamic title;
  dynamic description;
  dynamic categoryId;
  dynamic categoryName;
  dynamic isPaid;
  dynamic categoryIcon;
  dynamic bookings;

  /// The exercise's own colour, a bare hex string ("0C5147").
  ///
  /// The backend has always sent this. The Home slider ignored it and painted
  /// every card the same hard-coded `Color(0xFF0C4F45)`.
  dynamic colorCode;

  List<dynamic> skills;

  AllExerciseList({
    required this.id,
    required this.photoPath,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.isPaid,
    required this.bookings,
    required this.skills,
    this.colorCode,
  });

  factory AllExerciseList.fromJson(Map<String, dynamic> json) =>
      AllExerciseList(
        id: json["id"],
        isPaid: json["isPaid"],
        photoPath: json["photoPath"],
        title: json["title"],
        description: json["description"],
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        categoryIcon: json["categoryIcon"],
        bookings: json["bookings"],
        colorCode: json["colorCode"],
        skills: List<String>.from(json["skills"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photoPath": photoPath,
    "title": title,
    "description": description,
    "isPaid": isPaid,
    "categoryId": categoryId,
    "categoryName": categoryName,
    "categoryIcon": categoryIcon,
    "bookings": bookings,
    "colorCode": colorCode,
    "skills": List<dynamic>.from(skills.map((x) => x)),
  };
}
