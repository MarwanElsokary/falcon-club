// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

CategoriesModel categoriesModelFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) =>
    json.encode(data.toJson());

class CategoriesModel {
  dynamic message;
  List<CategoriesList> data;

  CategoriesModel({required this.message, required this.data});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        message: json["message"],
        // Tolerant: an absent/null/non-list `data` yields an empty list (the
        // filter bar simply shows no chips) instead of throwing and breaking
        // the whole exercise screen. Non-object rows are skipped.
        data: (json["data"] is List)
            ? (json["data"] as List)
                  .whereType<Map>()
                  .map(
                    (x) => CategoriesList.fromJson(Map<String, dynamic>.from(x)),
                  )
                  .toList()
            : const <CategoriesList>[],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoriesList {
  final String? id;
  final String? name;
  final String? icon;

  CategoriesList({required this.id, required this.name, required this.icon});

  /// Tolerant: `id` may arrive as a number and `icon` as a URL string; both are
  /// coerced to `String?` (mirrors `ClubPlayer`) so the model is typed without a
  /// captured payload to pin exact types. Preserves the consumer's prior
  /// null-tolerance — a missing field becomes `null`, never a thrown cast.
  factory CategoriesList.fromJson(Map<String, dynamic> json) => CategoriesList(
    id: json["id"]?.toString(),
    name: json["name"]?.toString(),
    icon: json["icon"]?.toString(),
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "icon": icon};
}
