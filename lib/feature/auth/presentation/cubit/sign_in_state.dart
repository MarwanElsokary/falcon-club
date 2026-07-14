import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/registration_credential.dart';

/// The outcome of a sign-in attempt.
///
/// Hand-written as a `sealed` hierarchy rather than generated with Freezed. The
/// legacy `LoginState` has ~24 union cases covering login, three registration
/// flows, OTP, profile updates and country lookups — and generates a
/// **10,958-line** `.freezed.dart`, the largest file in the repo.
///
/// `sealed` gives exhaustive matching: a new case is a compile error in every
/// `switch` that must handle it.
sealed class SignInAttempt extends Equatable {
  const SignInAttempt();

  @override
  List<Object?> get props => const [];
}

final class SignInIdle extends SignInAttempt {
  const SignInIdle();
}

final class SignInInProgress extends SignInAttempt {
  const SignInInProgress();
}

/// Carries the session so the screen can route by role without re-reading
/// storage — which is what `login_screen.dart` and `login_button_widget.dart`
/// both do today, separately, after a 1100 ms `Future.delayed`.
final class SignInSucceeded extends SignInAttempt {
  const SignInSucceeded(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

/// Covers a refused sign-in (unconfirmed phone, pending approval, unsupported
/// role) and a transport failure alike. The screen shows [message] either way —
/// it is always the server's own wording.
final class SignInFailed extends SignInAttempt {
  const SignInFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The sign-in screen's complete state.
///
/// Composition rather than one fat sealed hierarchy: [attempt] is the *operation*
/// (idle / running / done / failed), while [pendingRegistration] is an
/// orthogonal fact about the device — is there an account here whose phone was
/// never confirmed? Threading that through every `SignInAttempt` case would
/// duplicate it four times and couple two unrelated things.
///
/// [pendingRegistration] moved into the cubit because the screen was reading it
/// with `getIt<ReadPendingRegistration>()` **inside the widget** — a service
/// locator in the UI, which is precisely the violation this refactor set out to
/// remove from the codebase (the audit counted 40 such call sites in the legacy
/// code, and this had quietly become the 41st).
final class SignInState extends Equatable {
  const SignInState({
    this.attempt = const SignInIdle(),
    this.pendingRegistration,
  });

  final SignInAttempt attempt;

  /// Non-null only when an unconfirmed registration exists **and its 15-minute
  /// window is still open** — the cubit filters out an expired one, because the
  /// backend cannot re-issue the token and a retry link would be guaranteed to
  /// 401.
  final RegistrationCredential? pendingRegistration;

  bool get canConfirmPhone => pendingRegistration != null;

  SignInState copyWith({
    SignInAttempt? attempt,
    RegistrationCredential? pendingRegistration,
    bool clearPendingRegistration = false,
  }) => SignInState(
    attempt: attempt ?? this.attempt,
    pendingRegistration: clearPendingRegistration
        ? null
        : (pendingRegistration ?? this.pendingRegistration),
  );

  @override
  List<Object?> get props => [attempt, pendingRegistration];
}
