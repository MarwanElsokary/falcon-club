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
        data: List<CategoriesList>.from(
          json["data"].map((x) => CategoriesList.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoriesList {
  dynamic id;
  dynamic name;
  dynamic icon;

  CategoriesList({required this.id, required this.name, required this.icon});

  factory CategoriesList.fromJson(Map<String, dynamic> json) =>
      CategoriesList(id: json["id"], name: json["name"], icon: json["icon"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "icon": icon};
}
