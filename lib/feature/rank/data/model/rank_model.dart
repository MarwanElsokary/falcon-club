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

  /// Parses the ranking response, whatever shape it takes.
  ///
  /// `GetRankingExercise` returns a **bare array** `[ {...}, ... ]` — which is
  /// why the old envelope-only [fromJson] (`json["data"].map(...)`) threw and
  /// the whole screen showed a network error. This accepts the array, and also
  /// the `{ "message": ..., "data": [...] }` envelope other endpoints use, and
  /// treats an absent/empty/`null` list as an empty ranking (so the empty state
  /// shows instead of an error).
  factory RankModel.fromResponse(dynamic body) {
    dynamic message;
    List<dynamic> rows = const <dynamic>[];

    if (body is List) {
      rows = body;
    } else if (body is Map) {
      message = body["message"];
      final dynamic data = body["data"];
      if (data is List) rows = data;
    }

    return RankModel(
      message: message,
      data: rows
          .whereType<Map>()
          .map((x) => RankList.fromJson(Map<String, dynamic>.from(x)))
          .toList(),
    );
  }

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
    // Tolerant: `tps` may arrive as a number or a string. The old
    // `json["tps"]?.toDouble()` threw a NoSuchMethodError on a string, which
    // would re-break parsing for the whole list.
    tps: _toDouble(json["tps"]),
    photoPath: json["photoPath"],
    name: json["name"],
    age: json["age"],
    position: json["position"],
  );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tps": tps,
    "photoPath": photoPath,
    "name": name,
    "age": age,

    "position": position,
  };
}
