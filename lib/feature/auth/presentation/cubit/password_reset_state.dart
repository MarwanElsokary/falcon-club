import 'package:equatable/equatable.dart';

import '../../domain/entities/password_reset_ticket.dart';

/// States for the three-step password reset.
///
/// Each step has its own success state, because each one leads somewhere
/// different: [ResetCodeSent] advances to the code screen, [ResetOtpVerified]
/// carries the ticket to the new-password screen, and [PasswordResetCompleted]
/// ends at login. Collapsing them into one "success" would force the screens to
/// guess which step they were on.
///
/// [ResetCodeResent] is separate from [ResetCodeSent] for the same reason: a
/// resend must *not* re-navigate — the user stays on the code screen.
sealed class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => const [];
}

final class PasswordResetIdle extends PasswordResetState {
  const PasswordResetIdle();
}

final class PasswordResetInProgress extends PasswordResetState {
  const PasswordResetInProgress();
}

/// Step 1 done — a code is on its way.
final class ResetCodeSent extends PasswordResetState {
  const ResetCodeSent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Step 1 repeated. Stay put; restart the countdown.
final class ResetCodeResent extends PasswordResetState {
  const ResetCodeResent(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Step 2 done — the ticket authorises exactly one password change.
final class ResetOtpVerified extends PasswordResetState {
  const ResetOtpVerified(this.ticket);

  final PasswordResetTicket ticket;

  @override
  List<Object?> get props => [ticket];
}

/// Step 3 done. Back to login — no session is created here.
final class PasswordResetCompleted extends PasswordResetState {
  const PasswordResetCompleted(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class PasswordResetFailed extends PasswordResetState {
  const PasswordResetFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
