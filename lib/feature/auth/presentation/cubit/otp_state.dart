import 'package:equatable/equatable.dart';

import '../../domain/entities/otp_confirmation.dart';

/// The OTP screen's states.
///
/// Confirming and resending are separate concerns, so they get separate states —
/// a failed resend must not look like a failed confirmation, and a resend in
/// flight must not blank out the code the user has already typed.
sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => const [];
}

final class OtpIdle extends OtpState {
  const OtpIdle();
}

final class OtpConfirming extends OtpState {
  const OtpConfirming();
}

/// The phone is confirmed. The account is now awaiting admin approval, and the
/// screen's only move is to send the user to **login** — there is no session to
/// create, and `ConfirmPhoneByOtp` returns no token to create one with.
final class OtpConfirmed extends OtpState {
  const OtpConfirmed(this.confirmation);

  final OtpConfirmation confirmation;

  @override
  List<Object?> get props => [confirmation];
}

final class OtpFailed extends OtpState {
  const OtpFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class OtpResending extends OtpState {
  const OtpResending();
}

/// A new code is on its way. The countdown restarts; the user stays put.
final class OtpResent extends OtpState {
  const OtpResent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The 15-minute registration window has closed.
///
/// A terminal, unrecoverable state — and it deserves its own case rather than
/// being folded into [OtpFailed], because the user's next action is completely
/// different. Once the credential expires, both confirming and resending return
/// 401 and the backend will not issue another token: there is nothing left to
/// retry. Showing "invalid code" here would send the user into a loop of
/// failures with no explanation.
///
/// The screen stops the countdown, disables the inputs, and points the user back
/// to registration.
final class OtpCredentialExpired extends OtpState {
  const OtpCredentialExpired();
}
