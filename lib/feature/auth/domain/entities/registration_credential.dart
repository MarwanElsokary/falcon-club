import 'package:equatable/equatable.dart';

/// The bearer token issued by `RegisterClub` / `RegisterScout`, kept **only**
/// to authenticate phone confirmation.
///
/// ## This is NOT an [AuthSession], and it must never become one
///
/// `ConfirmPhoneByOtp` and `ResendPhoneOtp` take no phone number and no user id
/// — the backend resolves the account from this token. So the token has to
/// survive from registration until the user submits the code.
///
/// It is therefore a **separate type** from [AuthSession], persisted under a
/// **separate key** ([StorageKeys.pendingRegistrationToken], not
/// [StorageKeys.authToken]). `SessionRepository.readSession()` never looks at
/// that key, so this credential is *structurally incapable* of logging anyone
/// in. There is a regression test asserting exactly that.
///
/// It is cleared the moment confirmation succeeds.
///
/// ## The 15-minute window is measured from [issuedAt] — NOT from the JWT
///
/// The backend enforces a **15-minute** limit on phone confirmation. Once it
/// lapses, `ConfirmPhoneByOtp` and `ResendPhoneOtp` both start failing, and no
/// new token can be obtained: the account becomes permanently unconfirmable (it
/// cannot log in — the phone is unconfirmed — and it cannot be re-registered —
/// the phone is taken).
///
/// An earlier version of this class read the deadline from the token's `exp`
/// claim, on the assumption that the JWT encoded that window. **It does not.**
/// The issued JWT is effectively non-expiring — its `exp` lands in the year
/// **2071** — so the countdown rendered as tens of millions of minutes. The
/// 15 minutes is a *server-side rule*, invisible to the token.
///
/// So the window is measured from [issuedAt], the moment this app received the
/// credential, and [registrationWindow] is a named constant sourced from the
/// backend. That is the honest model: a client-side mirror of a server-side
/// rule, not a value decoded from data that never carried it.
final class RegistrationCredential extends Equatable {
  const RegistrationCredential(this.token, {required this.issuedAt});

  /// Stamps the credential at the moment it is received from the backend.
  factory RegistrationCredential.issuedNow(String token) =>
      RegistrationCredential(token, issuedAt: DateTime.now().toUtc());

  final String token;

  /// When this app received the credential, in UTC.
  final DateTime issuedAt;

  /// How long the backend allows for phone confirmation.
  ///
  /// Confirmed with the backend team. It cannot be read from the token — see the
  /// class doc — so it is stated here, once, rather than inferred from a claim
  /// that does not mean what it appears to.
  static const Duration registrationWindow = Duration(minutes: 15);

  /// The moment confirmation stops being possible.
  DateTime get expiresAt => issuedAt.add(registrationWindow);

  /// How long the user has left. [Duration.zero] once the window has closed —
  /// never negative, so callers can render it without guarding.
  Duration get remainingValidity {
    final Duration left = expiresAt.difference(DateTime.now().toUtc());
    return left.isNegative ? Duration.zero : left;
  }

  /// `false` once the window closes, or if the token is blank.
  ///
  /// Note this deliberately does **not** consult the JWT's `exp`: that claim is
  /// ~45 years out and would never reject anything, so checking it would give a
  /// false sense of a guard while the real deadline went unenforced.
  bool get isUsable => token.isNotEmpty && remainingValidity > Duration.zero;

  /// The exact `Authorization` header value the OTP endpoints expect.
  String get authorizationHeader => 'Bearer $token';

  @override
  List<Object?> get props => [token, issuedAt];

  /// Never leak the token.
  @override
  String toString() =>
      'RegistrationCredential(isUsable: $isUsable, expiresAt: $expiresAt)';
}
