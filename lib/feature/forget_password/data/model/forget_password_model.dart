import 'package:freezed_annotation/freezed_annotation.dart';

part 'forget_password_model.freezed.dart';

part 'forget_password_model.g.dart';

// Request Models
@Freezed()
class ForgetPasswordRequest with _$ForgetPasswordRequest {
  const factory ForgetPasswordRequest({required String phoneNumber}) =
      _ForgetPasswordRequest;

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordRequestFromJson(json);
}

@Freezed()
class CheckOtpRequest with _$CheckOtpRequest {
  const factory CheckOtpRequest({
    required String otp,
    required String phoneNumber,
  }) = _CheckOtpRequest;

  factory CheckOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckOtpRequestFromJson(json);
}

@Freezed()
class ResetPasswordRequest with _$ResetPasswordRequest {
  @JsonSerializable(fieldRename: FieldRename.snake) // مهم!
  const factory ResetPasswordRequest({
    required String token,
    required String password,
    @JsonKey(name: 'ConfirmPassword') required String confirmPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

// Response Models
@Freezed()
class ForgetPasswordResponse with _$ForgetPasswordResponse {
  const factory ForgetPasswordResponse({
    required String message,
    String? token,
  }) = _ForgetPasswordResponse;

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPasswordResponseFromJson(json);
}

@Freezed()
class CheckOtpResponse with _$CheckOtpResponse {
  const factory CheckOtpResponse({
    required String message,
    required String resetToken,
  }) = _CheckOtpResponse;

  factory CheckOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckOtpResponseFromJson(json);
}

// أضف هذا النموذج المفقود
@Freezed()
class ResetPasswordResponse with _$ResetPasswordResponse {
  const factory ResetPasswordResponse({required String message}) =
      _ResetPasswordResponse;

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);
}
