import 'dart:convert';

ClubPlayersResponse clubPlayersResponseFromJson(String str) =>
    ClubPlayersResponse.fromJson(json.decode(str));

class ClubPlayersResponse {
  dynamic message;
  List<ClubPlayer> data;

  ClubPlayersResponse({required this.message, required this.data});

  factory ClubPlayersResponse.fromJson(Map<String, dynamic> json) =>
      ClubPlayersResponse(
        message: json["message"],
        data: json["data"] != null
            ? List<ClubPlayer>.from(
                json["data"].map((x) => ClubPlayer.fromJson(x)))
            : [],
      );
}

class ClubPlayer {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic photo;
  dynamic positionName;
  dynamic positionId;
  dynamic tps;
  dynamic age;
  dynamic clubName;

  ClubPlayer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.positionName,
    required this.positionId,
    required this.tps,
    required this.age,
    required this.clubName,
  });

  factory ClubPlayer.fromJson(Map<String, dynamic> json) => ClubPlayer(
        id: json["id"] ?? json["userId"],
        firstName: json["firstName"] ?? json["name"] ?? '',
        lastName: json["lastName"] ?? '',
        photo: json["photo"] ?? json["photoPath"] ?? '',
        positionName: json["positionName"] ?? json["position"] ?? '',
        positionId: json["positionId"],
        tps: json["tps"]?.toDouble() ?? 0.0,
        age: json["age"],
        clubName: json["clubName"] ?? '',
      );

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
