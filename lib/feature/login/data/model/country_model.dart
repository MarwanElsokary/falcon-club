// To parse this JSON data, do
//
//     final countriesClubModel = countriesClubModelFromJson(jsonString);

import 'dart:convert';

CountriesClubModel countriesClubModelFromJson(String str) =>
    CountriesClubModel.fromJson(json.decode(str));

String countriesClubModelToJson(CountriesClubModel data) =>
    json.encode(data.toJson());

class CountriesClubModel {
  String message;
  List<CountiesList> data;

  CountriesClubModel({required this.message, required this.data});

  factory CountriesClubModel.fromJson(Map<String, dynamic> json) =>
      CountriesClubModel(
        message: json["message"],
        data: List<CountiesList>.from(
          json["data"].map((x) => CountiesList.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CountiesList {
  dynamic id;
  dynamic name;

  CountiesList({required this.id, required this.name});

  factory CountiesList.fromJson(Map<String, dynamic> json) =>
      CountiesList(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
