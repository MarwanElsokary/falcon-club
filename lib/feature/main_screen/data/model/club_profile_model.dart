// To parse this JSON data, do
//
//     final playerProfileModel = playerProfileModelFromJson(jsonString);

import 'dart:convert';

ClubProfileModel clubProfileModelFromJson(String str) =>
    ClubProfileModel.fromJson(json.decode(str));

String clubProfileModelModelToJson(ClubProfileModel data) =>
    json.encode(data.toJson());

class ClubProfileModel {
  String? message;
  PlayerData data;

  ClubProfileModel({this.message, required this.data});

  factory ClubProfileModel.fromJson(Map<String, dynamic> json) =>
      ClubProfileModel(
        message: json["message"],
        data: PlayerData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class PlayerData {
  String? id;
  String? accountNumber;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  dynamic photo;      // can be String? or null
  String? gender;

  PlayerData({
    this.id,
    this.accountNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.photo,
    this.gender,
  });

  factory PlayerData.fromJson(Map<String, dynamic> json) => PlayerData(
    id: json["id"],
    accountNumber: json["accountNumber"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    photo: json["photo"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accountNumber": accountNumber,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "phoneNumber": phoneNumber,
    "photo": photo,
    "gender": gender,
  };
}