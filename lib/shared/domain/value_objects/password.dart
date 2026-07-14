import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';

/// One named password rule, so the UI can render requirements *from the domain*
/// instead of re-declaring them.
///
/// This is the fix for the single most-duplicated logic in the app: the
/// password-requirements list is currently copy-pasted five times
/// (`password_validation_widget`, `reset_password_screen`, `scout_sign_up_screen`,
/// `club_sign_up_screen`, `signup_iput_data_widget`), each with its own copy of
/// the rules and its own `requirements.where((r) => r.isValid).length` counter.
enum PasswordRule {
  minimumLength('٨ أحرف على الأقل'),
  hasUppercase('حرف كبير واحد على الأقل'),
  hasLowercase('حرف صغير واحد على الأقل'),
  hasDigit('رقم واحد على الأقل'),
  hasSpecialCharacter('رمز واحد على الأقل');

  const PasswordRule(this.description);

  /// Human-readable requirement text, owned by the rule itself (OCP: adding a
  /// rule adds an enum case; no widget needs editing to display it).
  final String description;

  bool isSatisfiedBy(String candidate) => switch (this) {
    PasswordRule.minimumLength => candidate.length >= Password.minimumLength,
    PasswordRule.hasUppercase => candidate.contains(RegExp(r'[A-Z]')),
    PasswordRule.hasLowercase => candidate.contains(RegExp(r'[a-z]')),
    PasswordRule.hasDigit => candidate.contains(RegExp(r'\d')),
    PasswordRule.hasSpecialCharacter => candidate.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\[\]\\/~`+=;]'),
    ),
  };
}

/// A password that satisfies every [PasswordRule].
///
/// OOP: encapsulates the rule set. Callers ask the domain "is this acceptable
/// and why not", rather than each screen re-implementing the policy.
final class Password extends Equatable {
  const Password._(this.value);

  final String value;

  static const int minimumLength = 8;

  /// Rules the candidate currently fails — drives the live requirements
  /// checklist in the UI without the UI knowing what the rules *are*.
  static List<PasswordRule> unmetRulesOf(String candidate) => PasswordRule.values
      .where((PasswordRule rule) => !rule.isSatisfiedBy(candidate))
      .toList(growable: false);

  /// For **choosing** a password (signup, reset). Enforces every [PasswordRule].
  static Either<ValidationFailure, Password> create(String input) {
    final List<PasswordRule> unmet = unmetRulesOf(input);
    if (unmet.isNotEmpty) {
      return Left(ValidationFailure(message: unmet.first.description));
    }
    return Right(Password._(input));
  }

  /// For **submitting** an existing password (sign-in).
  ///
  /// Deliberately skips the rule set. At sign-in the password is a secret being
  /// *checked by the server*, not *chosen by the user* — an account created
  /// before these rules existed may hold a password that fails them, and
  /// rejecting it client-side would lock a legitimate user out of their own
  /// account. Only the server can say whether it is correct.
  ///
  /// Named `trusted` so its intent is unmistakable at the call site: it must
  /// never be used on a signup or reset path. Emptiness is still the caller's
  /// check — see `SignInCubit`.
  static Password trusted(String input) => Password._(input);

  /// Confirmation matching is a *policy about two passwords*, so it lives here
  /// rather than in a cubit (`ForgetPasswordCubit` currently does this inline).
  static Either<ValidationFailure, Password> createConfirmed({
    required String password,
    required String confirmation,
  }) {
    if (password != confirmation) {
      return const Left(ValidationFailure(message: _mismatchMessage));
    }
    return create(password);
  }

  static const String _mismatchMessage = 'كلمتا المرور غير متطابقتين';

  @override
  List<Object?> get props => [value];

  /// Never leak the secret into logs or crash reports.
  @override
  String toString() => 'Password(********)';
}
