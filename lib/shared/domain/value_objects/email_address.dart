import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';

/// A real email address.
///
/// OOP / make-illegal-states-unrepresentable: this exists to be a *different
/// type* from [PhoneNumber]. That is the whole point.
///
/// The bug it eliminates (B4): today a single shared `LoginControllers.email`
/// `TextEditingController` holds a **phone number** on the login screen (label
/// `رقم الجوال`, hint `05x xxx xxxx`) and a **real email** on both signup
/// screens (`AppRegex.isEmailValid`, `TextInputType.emailAddress`). Nothing
/// enforces which is which, and `club_sign_up_screen.dart:500` gets it wrong —
/// it hands the *email* to the OTP screen as the phone number.
///
/// With [EmailAddress] and [PhoneNumber] as distinct types, that call site
/// becomes a **compile error** rather than a silent runtime bug.
///
/// SRP: owns the definition of "valid email address" — one rule, one place.
final class EmailAddress extends Equatable {
  const EmailAddress._(this.value);

  final String value;

  static const String _emptyMessage = 'البريد الإلكتروني مطلوب';
  static const String _invalidMessage = 'بريد إلكتروني غير صالح';

  /// Mirrors the rule the signup screens already enforce via
  /// `AppRegex.isEmailValid`, so no user who can register today is rejected.
  static final RegExp _pattern = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  /// The only way to construct one — private constructor + factory means no
  /// caller can smuggle an unvalidated string in.
  static Either<ValidationFailure, EmailAddress> create(String input) {
    final String trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const Left(ValidationFailure(message: _emptyMessage));
    }
    if (!_pattern.hasMatch(trimmed)) {
      return const Left(ValidationFailure(message: _invalidMessage));
    }
    return Right(EmailAddress._(trimmed));
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
