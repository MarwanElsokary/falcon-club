import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/user_role.dart';
import '../../domain/entities/otp_confirmation.dart';
import '../../domain/entities/resend_outcome.dart';

/// Parses the `ConfirmPhoneByOtp` 200 body.
///
/// Captured live:
/// ```json
/// { "message": "تم إرسال طلب انضمامك للتطبيق بنجاح", "role": "Club", "data": {} }
/// ```
///
/// **No token.** Verified — do not expect one, and do not write a code path that
/// hopes for one. The account is now pending admin approval; the user signs in
/// normally and `LoginClub` answers `status: "Warning"` until approved.
final class OtpConfirmationModel {
  const OtpConfirmationModel({this.message, this.role});

  final String? message;
  final String? role;

  static const String _fallbackMessage = 'تم تأكيد رقم الجوال بنجاح';

  factory OtpConfirmationModel.fromJson(Map<String, dynamic> json) =>
      OtpConfirmationModel(
        message: Json.asString(json['message']),
        role: Json.asString(json['role']),
      );

  OtpConfirmation toEntity() => OtpConfirmation(
    message: Json.asMessage(message, fallback: _fallbackMessage),
    role: UserRole.tryFromApiValue(role),
  );
}

/// Parses the `ResendPhoneOtp` 200 body.
///
/// Captured live:
/// ```json
/// { "message": "تم إعادة إرسال رمز OTP بنجاح", "emailSent": true, "data": {} }
/// ```
final class ResendOtpResponseModel {
  const ResendOtpResponseModel({this.message, this.emailSent});

  final String? message;
  final bool? emailSent;

  static const String _fallbackMessage = 'تم إعادة إرسال الرمز';

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      ResendOtpResponseModel(
        message: Json.asString(json['message']),
        emailSent: Json.asBool(json['emailSent']),
      );

  ResendOutcome toEntity() => ResendOutcome(
    message: Json.asMessage(message, fallback: _fallbackMessage),
    emailSent: emailSent ?? false,
  );
}
