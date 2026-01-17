import 'dart:convert';

MeasurementModel measurementModelFromJson(String str) =>
    MeasurementModel.fromJson(json.decode(str));

String measurementModelToJson(MeasurementModel data) =>
    json.encode(data.toJson());

class MeasurementModel {
  dynamic id;
  dynamic image;
  dynamic heightCm;
  dynamic shoulderWidthCm;
  dynamic armLengthCm;
  dynamic avgLegAngle;
  dynamic createdAt;

  MeasurementModel({
    required this.id,
    required this.image,
    required this.heightCm,
    required this.shoulderWidthCm,
    this.armLengthCm,
    required this.avgLegAngle,
    required this.createdAt,
  });

  factory MeasurementModel.fromJson(Map<String, dynamic> json) =>
      MeasurementModel(
        id: json["id"],
        image: json["image"],
        heightCm: json["height_cm"],
        shoulderWidthCm: json["shoulder_width_cm"],
        armLengthCm: json["arm_length_cm"],
        avgLegAngle: json["avg_leg_angle"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "height_cm": heightCm,
    "shoulder_width_cm": shoulderWidthCm,
    "arm_length_cm": armLengthCm,
    "avg_leg_angle": avgLegAngle,
    "created_at": createdAt,
  };
}