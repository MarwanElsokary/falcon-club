import '../../../../core/networking/json.dart';
import '../../domain/entities/registration_credential.dart';
import '../../domain/entities/registration_outcome.dart';

/// Parses the `RegisterClub` / `RegisterScout` 200 body.
///
/// The **`RegisterClub`** shape is confirmed against the live contract:
///
/// ```json
/// { "message": "تم إنشاء الحساب بنجاح", "token": "<JWT>",
///   "userId": "<GUID>", "emailSent": true }
/// ```
///
/// ⚠️ **`RegisterScout`'s shape has not been captured.** It is assumed to be
/// symmetric, which the code supports: both endpoints live on the same
/// controller and the app treats their responses identically today. Parsing is
/// tolerant either way — every field is optional, so a different shape yields a
/// clean message rather than a crash, and correcting it is a change to this one
/// file.
///
/// ## The token becomes a credential, not a session
///
/// `userId` is dropped. The `token` is mapped into a [RegistrationCredential] —
/// **not** an `AuthSession`.
///
/// It has to be kept: `ConfirmPhoneByOtp` and `ResendPhoneOtp` take no phone
/// number and no user id, so this Bearer token is the only thing that tells the
/// backend whose phone is being confirmed. Discarding it would make phone
/// confirmation impossible.
///
/// It is still not a session: [RegistrationCredential] is a distinct type,
/// stored under a distinct key, and `SessionRepository.readSession()` never
/// reads that key. Registration therefore still cannot sign anyone in.
final class RegistrationResponseModel {
  const RegistrationResponseModel({
    this.message,
    this.token,
    this.userId,
    this.emailSent,
  });

  final String? message;

  /// Authenticates the OTP step. Becomes a [RegistrationCredential], never an
  /// `AuthSession` — see the class doc.
  final String? token;

  /// Returned by the backend and intentionally unused: the OTP endpoints
  /// identify the account by the token, not by an id.
  final String? userId;

  final bool? emailSent;

  static const String _fallbackMessage = 'تم إنشاء الحساب بنجاح';

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) =>
      RegistrationResponseModel(
        message: Json.asString(json['message']),
        token: Json.asString(json['token']),
        userId: Json.asString(json['userId']),
        emailSent: Json.asBool(json['emailSent']),
      );

  RegistrationOutcome toEntity() => RegistrationOutcome(
    message: Json.asMessage(message, fallback: _fallbackMessage),
    // Stamped now: the 15-minute confirmation window is a server-side rule the
    // token does not encode (its JWT `exp` is ~45 years out), so the deadline
    // can only be measured from the moment we received it.
    credential: RegistrationCredential.issuedNow(token ?? ''),
    emailSent: emailSent ?? false,
  );
}
