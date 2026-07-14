import 'package:equatable/equatable.dart';

import 'registration_credential.dart';

/// The result of creating an account.
///
/// ## It carries a credential, but NOT a session
///
/// `RegisterClub` returns a `token` and a `userId`. The `userId` is dropped. The
/// token is kept — but as a [RegistrationCredential], **not** an `AuthSession`.
///
/// That distinction is the whole design:
///
/// * The token is **required**: `ConfirmPhoneByOtp` and `ResendPhoneOtp` take no
///   phone number and no user id, so the Bearer token is the *only* thing that
///   tells the backend whose phone is being confirmed. Discarding it would make
///   phone confirmation impossible.
/// * It is **not a session**: it is stored under a different key, and
///   `SessionRepository.readSession()` never reads that key. Registration still
///   creates no session and cannot auto-login anyone — enforced by the types,
///   and by a regression test that asserts a saved credential leaves
///   `readSession()` returning `null`.
///
/// This also side-steps the old bug where `_saveAuthData()` ran on the register
/// response, found no `role` in it (the contract has none), and persisted a
/// session with no role at all.
final class RegistrationOutcome extends Equatable {
  const RegistrationOutcome({
    required this.message,
    required this.credential,
    this.emailSent = false,
  });

  /// The server's own words, e.g. "تم إنشاء الحساب بنجاح".
  final String message;

  /// Authenticates the OTP step that follows. Never persisted as a session.
  final RegistrationCredential credential;

  /// Whether a verification email went out. Returned by the contract and
  /// ignored by the app today; surfaced here so the UI can use it.
  final bool emailSent;

  @override
  List<Object?> get props => [message, credential, emailSent];
}
