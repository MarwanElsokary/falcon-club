import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/account_status.dart';
import '../../../../shared/domain/entities/user_role.dart';

/// Everything the backend tells us at sign-in.
///
/// SRP: a *report* of what happened, not a decision about it. Deciding whether
/// this permits entry (status accepted? role supported? token present?) is the
/// `LogIn` use case's job — see there. Keeping the two apart means the policy
/// is unit-testable without a network, and the parsing is testable without the
/// policy.
///
/// [role] is nullable on purpose: the backend can return `Player`, a role this
/// app does not host. `UserRole.tryFromApiValue` yields `null` for it, and
/// `LogIn` refuses. Mapping it to a default would let players into the Club
/// shell.
final class SignInResponse extends Equatable {
  const SignInResponse({
    required this.status,
    required this.message,
    this.role,
    this.token,
    this.userId,
    this.displayName,
    this.isSubscribed = false,
    this.isProfileCompleted = false,
    this.isPhoneConfirmed = false,
  });

  final AccountStatus status;

  /// The server's own words — shown verbatim when sign-in is refused, e.g.
  /// "لم يتم تأكيد رقم الجوال بعد."
  final String message;

  /// `null` when the backend returned a role this app cannot host.
  final UserRole? role;

  final String? token;
  final String? userId;
  final String? displayName;

  /// Captured but not yet consumed. Parsed now because the app already has
  /// subscription/paywall logic that re-derives this from a cached profile in
  /// two places that disagree; wiring it to the source of truth is a follow-up.
  final bool isSubscribed;

  final bool isProfileCompleted;
  final bool isPhoneConfirmed;

  /// A session is only constructible when the server actually issued one.
  bool get hasCredentials =>
      (token?.isNotEmpty ?? false) && (userId?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [
    status,
    message,
    role,
    token,
    userId,
    displayName,
    isSubscribed,
    isProfileCompleted,
    isPhoneConfirmed,
  ];

  /// Never leak the bearer token.
  @override
  String toString() =>
      'SignInResponse(status: $status, role: $role, hasCredentials: $hasCredentials)';
}
