import '../../../../core/networking/json.dart';
import '../../domain/entities/password_reset_ticket.dart';

/// Parses the three password-reset responses.
///
/// ## Tolerant, unlike the models these replace
///
/// The legacy freezed models declare their fields **non-nullable and required**
/// — `CheckOtpResponse` demands both `message` and `resetToken`. If the backend
/// omits either, `fromJson` throws a `TypeError` and the user sees a crash
/// instead of a message. Here every field is optional, so a shape change
/// degrades into a clean failure carrying the server's own words.
final class ForgetPasswordResponseModel {
  const ForgetPasswordResponseModel({this.message});

  final String? message;

  static const String _fallbackMessage = 'تم إرسال رمز التحقق';

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ForgetPasswordResponseModel(message: json['message']?.toString());

  String toMessage() => Json.asMessage(message, fallback: _fallbackMessage);
}

/// Step 2's response. Carries the ticket that authorises the password change.
final class CheckOtpResponseModel {
  const CheckOtpResponseModel({this.message, this.resetToken});

  final String? message;
  final String? resetToken;

  factory CheckOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckOtpResponseModel(
        message: json['message']?.toString(),
        resetToken: json['resetToken']?.toString(),
      );

  /// A missing token yields an unusable ticket, which `ResetPassword` refuses —
  /// rather than a `TypeError` from a non-nullable field.
  PasswordResetTicket toEntity() => PasswordResetTicket(resetToken ?? '');
}

final class ResetPasswordResponseModel {
  const ResetPasswordResponseModel({this.message});

  final String? message;

  static const String _fallbackMessage = 'تم تغيير كلمة المرور بنجاح';

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponseModel(message: json['message']?.toString());

  String toMessage() => Json.asMessage(message, fallback: _fallbackMessage);
}
