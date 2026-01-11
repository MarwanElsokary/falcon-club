// To parse this JSON data, do
//
//     final allTrialsModel = allTrialsModelFromJson(jsonString);

import 'dart:convert';

AllTrialsModel allTrialsModelFromJson(String str) =>
    AllTrialsModel.fromJson(json.decode(str));

String allTrialsModelToJson(AllTrialsModel data) => json.encode(data.toJson());

class AllTrialsModel {
  dynamic message;
  List<AllTrialsList> data;

  AllTrialsModel({required this.message, required this.data});

  factory AllTrialsModel.fromJson(Map<String, dynamic> json) => AllTrialsModel(
    message: json["message"],
    data: List<AllTrialsList>.from(
      json["data"].map((x) => AllTrialsList.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AllTrialsList {
  dynamic id;
  dynamic photoPath;
  dynamic title;
  dynamic minAge;
  dynamic maxAge;
  dynamic gender;
  dynamic country;
  dynamic postAt;
  dynamic categoryId;
  dynamic categoryName;
  dynamic categoryIcon;
  dynamic bookings;
  dynamic isClosed;

  AllTrialsList({
    required this.id,
    required this.photoPath,
    required this.title,
    required this.minAge,
    required this.maxAge,
    required this.gender,
    required this.country,
    required this.postAt,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.bookings,
    required this.isClosed,
  });

  factory AllTrialsList.fromJson(Map<String, dynamic> json) => AllTrialsList(
    id: json["id"],
    photoPath: json["photoPath"],
    title: json["title"],
    minAge: json["minAge"],
    maxAge: json["maxAge"],
    gender: json["gender"],
    country: json["country"],
    postAt: json["postAt"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    categoryIcon: json["categoryIcon"],
    bookings: json["bookings"],
    isClosed: json["isClosed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photoPath": photoPath,
    "title": title,
    "minAge": minAge,
    "maxAge": maxAge,
    "gender": gender,
    "country": country,
    "postAt": postAt,
    "categoryId": categoryId,
    "categoryName": categoryName,
    "categoryIcon": categoryIcon,
    "bookings": bookings,
    "isClosed": isClosed,
  };
}
