// To parse this JSON data, do
//
//     final myProfileModel = myProfileModelFromJson(jsonString);

import 'dart:convert';

MyProfileModel myProfileModelFromJson(String str) =>
    MyProfileModel.fromJson(json.decode(str));

String myProfileModelToJson(MyProfileModel data) => json.encode(data.toJson());

class MyProfileModel {
  dynamic message;
  Data data;

  MyProfileModel({required this.message, required this.data});

  factory MyProfileModel.fromJson(Map<String, dynamic> json) => MyProfileModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  dynamic userId;
  dynamic accountNumber;
  dynamic firstName;
  dynamic lastName;
  dynamic remainingSubscriptionDays;
  dynamic email;
  dynamic phoneNumber;
  dynamic birthDate;
  dynamic direction;
  dynamic height;
  dynamic weight;
  dynamic clubImage;
  dynamic bioHeight;
  dynamic bioShoulderWidth;
  dynamic bioArmLength;
  dynamic bioAvgLegAngle;
  dynamic isSubscribed;
  dynamic photo;
  dynamic gender;
  dynamic branchName;
  dynamic branchId;
  dynamic clubId;
  dynamic clubName;
  dynamic positionId;
  dynamic positionName;
  dynamic clubJoinDate;
  dynamic joinDate;
  dynamic isCompleted;
  dynamic position;
  dynamic bioDate;
  dynamic bioImage;
  dynamic tps;

  Data({
    required this.userId,
    required this.accountNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isCompleted,
    required this.isSubscribed,
    required this.clubImage,
    required this.bioHeight,
    required this.bioShoulderWidth,
    required this.bioArmLength,
    required this.bioAvgLegAngle,
    required this.phoneNumber,
    required this.birthDate,
    required this.direction,
    required this.bioImage,
    required this.height,
    required this.weight,
    required this.photo,
    required this.gender,
    required this.branchName,
    required this.branchId,
    required this.clubId,
    required this.clubName,
    required this.positionId,
    required this.remainingSubscriptionDays,
    required this.positionName,
    required this.clubJoinDate,
    required this.joinDate,
    required this.bioDate,
    required this.position,
    required this.tps,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    // 🔥 Club بيرجع "id" مش "userId"
    userId: json["userId"] ?? json["id"],
    isCompleted: json["isCompleted"] ?? false,
    bioImage: json["bioImage"],
    accountNumber: json["accountNumber"],
    firstName: json["firstName"],
    // 🔥 تأكد إنها بتتقرأ صح
    isSubscribed: json["isSubscribed"] ?? false,
    lastName: json["lastName"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    birthDate: json["birthDate"],
    direction: json["direction"],
    height: json["height"],
    weight: json["weight"],
    photo: json["photo"],
    gender: json["gender"],
    clubImage: json["clubImage"],
    branchName: json["branchName"],
    branchId: json["branchId"],
    clubId: json["clubId"],
    clubName: json["clubName"],
    positionId: json["positionId"],
    positionName: json["positionName"],
    clubJoinDate: json["clubJoinDate"],
    // An absent field means "no horizon reported" — keep it null, never fake a
    // large number. A fabricated 999 would let an expired/absent subscription
    // read as active for any account that omits the field (stale cache, backend
    // edge case). Entitlement fails closed on null (see Subscription.isActive).
    remainingSubscriptionDays: json["remainingSubscriptionDays"],
    joinDate: json["joinDate"],
    position: json["position"],
    tps: json["tps"],
    bioDate: json["bioDate"],
    bioHeight: json["bioHeight"],
    bioShoulderWidth: json["bioShoulderWidth"],
    bioArmLength: json["bioArmLength"],
    bioAvgLegAngle: json["bioAvgLegAngle"],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    "accountNumber": accountNumber,
    "firstName": firstName,
    "lastName": lastName,
    "remainingSubscriptionDays": remainingSubscriptionDays,
    "email": email,
    "isCompleted": isCompleted,
    "isSubscribed": isSubscribed,
    "phoneNumber": phoneNumber,
    "birthDate": birthDate,
    "direction": direction,
    "height": height,
    "weight": weight,
    "photo": photo,
    "gender": gender,
    "branchName": branchName,
    "branchId": branchId,
    "clubId": clubId,
    "bioImage": bioImage,
    "bioDate": bioDate,
    "clubName": clubName,
    "positionId": positionId,
    "clubImage": clubImage,
    "bioAvgLegAngle": bioAvgLegAngle,
    "bioHeight": bioHeight,
    "bioShoulderWidth": bioShoulderWidth,
    "bioArmLength": bioArmLength,
    "positionName": positionName,
    "clubJoinDate": clubJoinDate,
    "joinDate": joinDate,
    "position": position,
    "tps": tps,
  };
}
