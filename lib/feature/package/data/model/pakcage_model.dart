// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

List<PackageModel> packageModelFromJson(String str) => List<PackageModel>.from(
  json.decode(str).map((x) => PackageModel.fromJson(x)),
);

String packageModelToJson(List<PackageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackageModel {
  dynamic id;
  dynamic name;
  dynamic price;
  dynamic durationInDays;
  List<Desciption> desciptions;

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.durationInDays,
    required this.desciptions,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    durationInDays: json["durationInDays"],
    desciptions: List<Desciption>.from(
      json["desciptions"].map((x) => Desciption.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "durationInDays": durationInDays,
    "desciptions": List<dynamic>.from(desciptions.map((x) => x.toJson())),
  };
}

class Desciption {
  dynamic id;
  dynamic content;

  Desciption({required this.id, required this.content});

  factory Desciption.fromJson(Map<String, dynamic> json) =>
      Desciption(id: json["id"], content: json["content"]);

  Map<String, dynamic> toJson() => {"id": id, "content": content};
}
