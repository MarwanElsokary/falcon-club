import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../entities/password_reset_ticket.dart';
import '../repositories/password_reset_repository.dart';
import '../value_objects/otp_code.dart';

final class VerifyPasswordResetOtpParams extends Equatable {
  const VerifyPasswordResetOtpParams({
    required this.phone,
    required this.code,
  });

  final PhoneNumber phone;
  final OtpCode code;

  @override
  List<Object?> get props => [phone, code];
}

/// Step 2 — exchanges a verified code for a [PasswordResetTicket].
///
/// Unlike registration's OTP, the phone number goes on the wire here: the caller
/// is not authenticated (they have forgotten their password), so the phone is
/// the only thing identifying the account.
///
/// [OtpCode] is reused from the registration flow, which means a **leading zero
/// survives** here too. That was never broken on this path — `CheckOtp` already
/// took a `String` — but sharing the type means the two flows cannot drift apart
/// on what a valid code is.
@injectable
class VerifyPasswordResetOtp
    implements UseCase<PasswordResetTicket, VerifyPasswordResetOtpParams> {
  const VerifyPasswordResetOtp(this._repository);

  final PasswordResetRepository _repository;

  @override
  ResultFuture<PasswordResetTicket> call(
    VerifyPasswordResetOtpParams params,
  ) => _repository.verifyOtp(phone: params.phone, code: params.code);
}
