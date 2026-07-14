import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

/// A one-time phone confirmation code.
///
/// ## It is a String, and that is the whole point
///
/// The legacy path sends the code as an **int**:
///
/// ```dart
/// Future otp(@Query('otp') int otp);        // api_service.dart
/// _loginRepo.otp(int.parse(code));          // login_cubit.dart
/// ```
///
/// `int.parse("012345")` is `12345`. Any code beginning with a zero is silently
/// mangled into a five-digit number and rejected by the server — roughly **one
/// user in ten**, with no way to tell that their correct code was corrupted in
/// transit. The backend's own contract types `otp` as a string.
///
/// Holding it as a [String] from the field to the wire makes that class of bug
/// unrepresentable.
final class OtpCode extends Equatable {
  const OtpCode._(this.value);

  /// The digits exactly as typed — leading zeros intact.
  final String value;

  static const int length = 6;

  static final RegExp _digits = RegExp(r'^[0-9]+$');

  static const String _emptyMessage = 'يجب إدخال كود التحقق';
  static const String _lengthMessage = 'يجب إدخال $length أرقام';
  static const String _digitsMessage = 'كود التحقق يجب أن يكون أرقاماً فقط';

  static Either<ValidationFailure, OtpCode> create(String input) {
    final String candidate = input.trim();
    if (candidate.isEmpty) {
      return const Left(ValidationFailure(message: _emptyMessage));
    }
    if (!_digits.hasMatch(candidate)) {
      return const Left(ValidationFailure(message: _digitsMessage));
    }
    if (candidate.length != length) {
      return const Left(ValidationFailure(message: _lengthMessage));
    }
    return Right(OtpCode._(candidate));
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
