import 'package:equatable/equatable.dart';

/// The short-lived token `CheckOtp` hands back once a reset OTP is verified.
///
/// It authorises exactly one thing: setting a new password. It is a **third**
/// kind of credential in this app, and deliberately its own type so it cannot be
/// confused with either of the others:
///
/// | type | proves | sent as | grants |
/// |---|---|---|---|
/// | [AuthSession] | you are signed in | `Authorization` header | app entry |
/// | [RegistrationCredential] | you just registered | `Authorization` header | phone confirmation |
/// | **[PasswordResetTicket]** | you proved you own the phone | a **form field** (`Token`) | one password change |
///
/// Note it travels as a *body field*, not a header — so it never passes through
/// `DioFactory`'s interceptor and can never be mistaken for a session token.
///
/// The legacy flow passed this around as a bare `String` through route
/// arguments, and logged it in plaintext on the way (`forget_password_repo.dart`
/// lines 37 and 54).
final class PasswordResetTicket extends Equatable {
  const PasswordResetTicket(this.token);

  final String token;

  /// A blank ticket is not a ticket. `CheckOtpResponse` declares `resetToken`
  /// non-nullable, so the legacy model *throws* if the backend omits it; here a
  /// missing token simply yields an unusable ticket and a clean failure.
  bool get isUsable => token.isNotEmpty;

  @override
  List<Object?> get props => [token];

  /// Never leak the ticket — it authorises a password change.
  @override
  String toString() => 'PasswordResetTicket(isUsable: $isUsable)';
}
