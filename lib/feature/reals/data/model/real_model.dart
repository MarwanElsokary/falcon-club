// To parse this JSON data, do
//
//     final realModel = realModelFromJson(jsonString);

import 'dart:convert';

RealModel realModelFromJson(String str) => RealModel.fromJson(json.decode(str));

String realModelToJson(RealModel data) => json.encode(data.toJson());

class RealModel {
  List<RealsVide> data;
  dynamic totalCount;
  dynamic pageNumber;
  dynamic pageSize;
  dynamic totalPages;


  RealModel({
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory RealModel.fromJson(Map<String, dynamic> json) => RealModel(
    data: List<RealsVide>.from(json["data"].map((x) => RealsVide.fromJson(x))),
    totalCount: json["totalCount"],
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totalCount": totalCount,
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "totalPages": totalPages,
  };
}

class RealsVide {
  dynamic id;
  dynamic playerId;
  dynamic video;
  dynamic creationDate;
  dynamic description;
  dynamic playerName;
  dynamic playerPhoto;
  dynamic likesCount;
  dynamic commentsCount;
  dynamic isLiked;
  dynamic isMyReel;
  List<Comment> comments;
  final String? shareVideo;   // رابط مباشر للفيديو القابل للتحميل


  RealsVide({
    required this.id,
    required this.playerId,
    required this.video,
    required this.creationDate,
    required this.description,
    required this.playerName,
    required this.playerPhoto,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isMyReel,
    required this.comments, this.shareVideo,
  });

  factory RealsVide.fromJson(Map<String, dynamic> json) => RealsVide(
    id: json["id"],
    playerId: json["playerId"],
    video: json["video"],
    creationDate: json["creationDate"],
    description: json["description"],
    playerName: json["playerName"],
    playerPhoto: json["playerPhoto"],
    shareVideo: json["shareVideo"],
    likesCount: json["likesCount"],
    commentsCount: json["commentsCount"],
    isLiked: json["isLiked"],
    isMyReel: json["isMyReel"],
    comments: List<Comment>.from(
      json["comments"].map((x) => Comment.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "playerId": playerId,
    "video": video,
    "creationDate": creationDate,
    "description": description,
    "playerName": playerName,
    "playerPhoto": playerPhoto,
    "shareVideo": shareVideo,
    "likesCount": likesCount,
    "commentsCount": commentsCount,
    "isLiked": isLiked,
    "isMyReel": isMyReel,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  dynamic id;
  dynamic playerId;
  dynamic description;
  dynamic creationTime;
  dynamic isMyComment;
  dynamic playerName;
  dynamic playerPhoto;

  Comment({
    required this.id,
    required this.playerId,
    required this.description,
    required this.creationTime,
    required this.isMyComment,
    required this.playerName,
    required this.playerPhoto,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    playerId: json["playerId"],
    description: json["description"],
    creationTime: json["creationTime"],
    isMyComment: json["isMyComment"],
    playerName: json["playerName"],
    playerPhoto: json["playerPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "playerId": playerId,
    "description": description,
    "creationTime": creationTime,
    "isMyComment": isMyComment,
    "playerName": playerName,
    "playerPhoto": playerPhoto,
  };
}
