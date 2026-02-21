// To parse this JSON data, do
//
//     final termsAndPoliciesModel = termsAndPoliciesModelFromJson(jsonString);

import 'dart:convert';

TermsAndPoliciesModel termsAndPoliciesModelFromJson(String str) =>
    TermsAndPoliciesModel.fromJson(json.decode(str));

String termsAndPoliciesModelToJson(TermsAndPoliciesModel data) =>
    json.encode(data.toJson());

class TermsAndPoliciesModel {
  String? termsAndConditions;
  String? privacyPolicy;

  TermsAndPoliciesModel({
    this.termsAndConditions,
    this.privacyPolicy,
  });

  factory TermsAndPoliciesModel.fromJson(Map<String, dynamic> json) =>
      TermsAndPoliciesModel(
        termsAndConditions: json["termsAndConditions"],
        privacyPolicy: json["privacyPolicy"],
      );

  Map<String, dynamic> toJson() => {
    "termsAndConditions": termsAndConditions,
    "privacyPolicy": privacyPolicy,
  };
}