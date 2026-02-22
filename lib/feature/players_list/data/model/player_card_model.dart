import 'dart:convert';

PlayersListModel playersListModelFromJson(String str) =>
    PlayersListModel.fromJson(json.decode(str));

String playersListModelToJson(PlayersListModel data) =>
    json.encode(data.toJson());

class PlayersListModel {
  dynamic message;
  List<PlayerCardData> data;
  dynamic totalCount;
  dynamic pageNumber;
  dynamic pageSize;
  dynamic totalPages;

  PlayersListModel({
    required this.message,
    required this.data,
    this.totalCount,
    this.pageNumber,
    this.pageSize,
    this.totalPages,
  });

  factory PlayersListModel.fromJson(Map<String, dynamic> json) =>
      PlayersListModel(
        message: json["message"],
        data: List<PlayerCardData>.from(
          (json["data"] as List?)?.map((x) => PlayerCardData.fromJson(x)) ?? [],
        ),
        totalCount: json["totalCount"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "totalCount": totalCount,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalPages": totalPages,
      };
}

class PlayerCardData {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic photo;
  dynamic teamName;
  dynamic jerseyNumber;
  dynamic xpPoints;
  dynamic tps;
  dynamic age;
  dynamic positionName;
  dynamic positionId;
  dynamic isInvited;
  dynamic isInTeam;

  PlayerCardData({
    required this.id,
    this.firstName,
    this.lastName,
    this.photo,
    this.teamName,
    this.jerseyNumber,
    this.xpPoints,
    this.tps,
    this.age,
    this.positionName,
    this.positionId,
    this.isInvited,
    this.isInTeam,
  });

  factory PlayerCardData.fromJson(Map<String, dynamic> json) => PlayerCardData(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        photo: json["photo"],
        teamName: json["teamName"],
        jerseyNumber: json["jerseyNumber"],
        xpPoints: json["xpPoints"],
        tps: json["tps"],
        age: json["age"],
        positionName: json["positionName"],
        positionId: json["positionId"],
        isInvited: json["isInvited"],
        isInTeam: json["isInTeam"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "photo": photo,
        "teamName": teamName,
        "jerseyNumber": jerseyNumber,
        "xpPoints": xpPoints,
        "tps": tps,
        "age": age,
        "positionName": positionName,
        "positionId": positionId,
        "isInvited": isInvited,
        "isInTeam": isInTeam,
      };

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
