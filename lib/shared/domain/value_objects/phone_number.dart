import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/error/failures.dart';

/// A phone number.
///
/// ## Two rules, on purpose. Do not "fix" this into consistency.
///
/// The same structural type is validated **differently depending on why it is
/// being entered**, and the two factories are named so the call site says which
/// rule applies:
///
/// * [forSaudiRegistration] — **strict.** Used when *creating* an account. The
///   product is Saudi-only, so a signup phone must be a real Saudi mobile
///   number; a typo here produces an account whose OTP can never arrive.
///
/// * [permissive] — **lenient.** Used at *sign-in*. It rejects only a blank
///   value.
///
/// The asymmetry is deliberate, and reversing it breaks real users:
///
/// * Making **login strict** would lock out any existing account whose stored
///   phone does not match today's Saudi pattern — accounts created before the
///   rule existed, or through another channel. At sign-in the phone is a
///   *lookup key being checked by the server*, not a value being chosen. Only
///   the server can say whether it matches an account.
/// * Making **registration permissive** would let a malformed number create an
///   unreachable account.
///
/// This is not an oversight and not duplication. It is the same distinction as
/// `Password.create` (choosing) versus `Password.trusted` (submitting).
///
/// **Neither factory reformats the value.** [value] is the input verbatim. The
/// backend is fed a bare Saudi number today and that is correct for this
/// product; prepending `+966` or stripping separators would silently change what
/// goes on the wire.
final class PhoneNumber extends Equatable {
  const PhoneNumber._(this.value);

  /// Exactly what the user typed. No trimming, no reformatting.
  final String value;

  /// Saudi mobile numbers: `05XXXXXXXX` (10 digits) or `5XXXXXXXX` (9 digits).
  /// Mirrors `AppRegex.isPhoneNumberValid`, the rule the signup screens already
  /// enforce — so no user who can register today is newly rejected.
  static final RegExp _saudiMobile = RegExp(r'^(05|5)[0-9]{8}$');

  /// How many characters the **signup** phone field accepts.
  ///
  /// The signup screens show a `+966` prefix beside the field, so the user types
  /// the bare subscriber number: `5XXXXXXXX`. Capping the field at 9 stops bad
  /// input at the keystroke rather than at submit.
  ///
  /// Exposed here, next to [_saudiMobile], so the field's limit and the domain's
  /// rule cannot drift apart. This is a *UX* limit; it does not replace
  /// [forSaudiRegistration], which is still the authority on validity.
  static const int saudiInputLength = 9;

  static const String _emptyMessage = 'رقم الجوال مطلوب';
  static const String _notSaudiMessage =
      'رقم الجوال غير صالح — يجب أن يكون رقم جوال سعودي (05XXXXXXXX)';

  /// **Registration only.** Enforces the Saudi mobile format.
  static Either<ValidationFailure, PhoneNumber> forSaudiRegistration(
    String input,
  ) {
    final String candidate = input.trim();
    if (candidate.isEmpty) {
      return const Left(ValidationFailure(message: _emptyMessage));
    }
    if (!_saudiMobile.hasMatch(candidate)) {
      return const Left(ValidationFailure(message: _notSaudiMessage));
    }
    return Right(PhoneNumber._(candidate));
  }

  /// **Sign-in only.** Rejects a blank number and nothing else.
  ///
  /// Matches the weakest validator in the app today (the login field checks
  /// non-empty), so no existing user's input becomes invalid. See the class doc
  /// for why this must stay lenient.
  static Either<ValidationFailure, PhoneNumber> permissive(String input) {
    if (input.trim().isEmpty) {
      return const Left(ValidationFailure(message: _emptyMessage));
    }
    return Right(PhoneNumber._(input));
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
