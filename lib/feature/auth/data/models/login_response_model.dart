import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/account_status.dart';
import '../../../../shared/domain/entities/user_role.dart';
import '../../domain/entities/sign_in_response.dart';

/// Parses the `LoginClub` 200 body.
///
/// ## ✅ Verified against a live `LoginClub` response
///
/// This was originally modelled on a `LoginPlayer` sample as an educated guess.
/// A live `LoginClub` 200 has since been captured and **matches that shape
/// exactly** — same fields, same types:
///
/// ```json
/// { "message": "تم تسجيل الدخول بنجاح", "status": "Accepted", "token": "<JWT>",
///   "role": "Club", "userId": "<GUID>", "isConfirmed": true,
///   "emailConfirmed": true, "phoneNumberConfirmed": true, "isSubscribed": true,
///   "isCompleted": false, "name": "مروان سكري" }
/// ```
///
/// The **pending-approval** 200 is the same shape with fewer fields —
/// `{status: "Warning", role: "Club", message: ...}` and **no token**. Both are
/// handled here: `AccountStatus` distinguishes them, and `LogIn` refuses
/// anything that is not `Accepted`.
///
/// Parsing stays **tolerant on purpose** even though the shape is now confirmed:
/// every field is optional, so a future backend change yields a clean "sign-in
/// refused" carrying the server's own message rather than a thrown `TypeError`.
/// The pending-approval body already proves fields come and go between states.
///
/// Nothing above the data layer knows this shape — [SignInResponse] is what the
/// rest of the app sees — so a contract change remains a one-file edit.
final class LoginResponseModel {
  const LoginResponseModel({
    this.message,
    this.status,
    this.token,
    this.role,
    this.userId,
    this.isConfirmed,
    this.emailConfirmed,
    this.phoneNumberConfirmed,
    this.isSubscribed,
    this.isCompleted,
    this.name,
  });

  final String? message;
  final String? status;
  final String? token;
  final String? role;
  final String? userId;
  final bool? isConfirmed;
  final bool? emailConfirmed;
  final bool? phoneNumberConfirmed;
  final bool? isSubscribed;
  final bool? isCompleted;
  final String? name;

  static const String _fallbackMessage = 'تعذر تسجيل الدخول';

  /// Tolerant by design — see the class doc. Reads defensively so an unexpected
  /// type (e.g. `isSubscribed` arriving as `"true"` rather than `true`) cannot
  /// throw.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        message: Json.asString(json['message']),
        status: Json.asString(json['status']),
        token: Json.asString(json['token']),
        role: Json.asString(json['role']),
        userId: Json.asString(json['userId']),
        isConfirmed: Json.asBool(json['isConfirmed']),
        emailConfirmed: Json.asBool(json['emailConfirmed']),
        phoneNumberConfirmed: Json.asBool(json['phoneNumberConfirmed']),
        isSubscribed: Json.asBool(json['isSubscribed']),
        isCompleted: Json.asBool(json['isCompleted']),
        name: Json.asString(json['name']),
      );

  SignInResponse toEntity() => SignInResponse(
    status: AccountStatus.fromApiValue(status),
    message: Json.asMessage(message, fallback: _fallbackMessage),
    // Strict: an unhostable role (e.g. "Player") becomes null, and LogIn
    // refuses it. A lenient parse would admit players as clubs.
    role: UserRole.tryFromApiValue(role),
    token: token,
    userId: userId,
    displayName: name,
    isSubscribed: isSubscribed ?? false,
    isProfileCompleted: isCompleted ?? false,
    isPhoneConfirmed: phoneNumberConfirmed ?? false,
  );
}
