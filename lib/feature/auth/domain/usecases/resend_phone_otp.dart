import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/registration_credential.dart';
import '../entities/resend_outcome.dart';
import '../repositories/otp_repository.dart';

/// Asks the backend to send a fresh OTP.
///
/// Entirely new: no resend endpoint existed in the app. The button was wired to
/// a commented-out call, and its countdown reset was written `_restartCountdown;`
/// — a tear-off, not an invocation — so it silently did nothing.
@injectable
class ResendPhoneOtp implements UseCase<ResendOutcome, RegistrationCredential> {
  const ResendPhoneOtp(this._repository);

  final OtpRepository _repository;

  @override
  ResultFuture<ResendOutcome> call(RegistrationCredential credential) =>
      _repository.resendOtp(credential);
}
