// // forget_password_models.dart
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'forget_password_models.freezed.dart';
// part 'forget_password_models.g.dart';
//
// @freezed
// class ForgetPasswordResponse with _$ForgetPasswordResponse {
//   const factory ForgetPasswordResponse({
//     required bool success,
//     String? message,
//     @JsonKey(name: 'data') ForgetPasswordData? data,
//   }) = _ForgetPasswordResponse;
//
//   factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
//       _$ForgetPasswordResponseFromJson(json);
// }
//
// @freezed
// class ForgetPasswordData with _$ForgetPasswordData {
//   const factory ForgetPasswordData({
//     @JsonKey(name: 'otp') String? otp,
//     @JsonKey(name: 'expires_in') int? expiresIn,
//   }) = _ForgetPasswordData;
//
//   factory ForgetPasswordData.fromJson(Map<String, dynamic> json) =>
//       _$ForgetPasswordDataFromJson(json);
// }
//
// @freezed
// class CheckOtpResponse with _$CheckOtpResponse {
//   const factory CheckOtpResponse({
//     required bool success,
//     String? message,
//     @JsonKey(name: 'data') CheckOtpData? data,
//   }) = _CheckOtpResponse;
//
//   factory CheckOtpResponse.fromJson(Map<String, dynamic> json) =>
//       _$CheckOtpResponseFromJson(json);
// }
//
// @freezed
// class CheckOtpData with _$CheckOtpData {
//   const factory CheckOtpData({
//     @JsonKey(name: 'token') String? token,
//     @JsonKey(name: 'phone') String? phone,
//   }) = _CheckOtpData;
//
//   factory CheckOtpData.fromJson(Map<String, dynamic> json) =>
//       _$CheckOtpDataFromJson(json);
// }
//
// @freezed
// class ResetPasswordResponse with _$ResetPasswordResponse {
//   const factory ResetPasswordResponse({
//     required bool success,
//     String? message,
//   }) = _ResetPasswordResponse;
//
//   factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
//       _$ResetPasswordResponseFromJson(json);
// }