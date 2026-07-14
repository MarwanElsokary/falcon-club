import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/otp_confirmation.dart';
import '../entities/registration_credential.dart';
import '../repositories/otp_repository.dart';
import '../repositories/pending_registration_repository.dart';
import '../value_objects/otp_code.dart';

/// What [ConfirmPhoneOtp] needs: the code, and the credential that says whose
/// phone it is.
final class ConfirmPhoneOtpParams extends Equatable {
  const ConfirmPhoneOtpParams({required this.code, required this.credential});

  final OtpCode code;
  final RegistrationCredential credential;

  @override
  List<Object?> get props => [code, credential];
}

/// Confirms the phone number, then discards the credential that authorised it.
///
/// SRP: one verb. It creates **no session** — `ConfirmPhoneByOtp` returns no
/// token (verified live), so there is nothing to create one with even by
/// accident. The account moves to *pending approval*, and the user signs in
/// normally.
///
/// The credential is cleared **only on success**. On failure it is kept, so a
/// user who fat-fingers the code can retry or resend rather than being stranded
/// with an unconfirmable account.
@injectable
class ConfirmPhoneOtp
    implements UseCase<OtpConfirmation, ConfirmPhoneOtpParams> {
  const ConfirmPhoneOtp(this._otpRepository, this._pendingRegistration);

  final OtpRepository _otpRepository;
  final PendingRegistrationRepository _pendingRegistration;

  @override
  ResultFuture<OtpConfirmation> call(ConfirmPhoneOtpParams params) async {
    final confirmation = await _otpRepository.confirmPhone(
      code: params.code,
      credential: params.credential,
    );
    return confirmation.fold(
      (Failure failure) => Left<Failure, OtpConfirmation>(failure),
      _discardCredential,
    );
  }

  /// The phone is confirmed; the credential has served its only purpose.
  ///
  /// A failure to clear it is not a failure to confirm — the user's phone *is*
  /// confirmed either way, and stranding them on an error screen would be worse
  /// than leaving a stale token that `RegistrationCredential.isUsable` will
  /// reject once it expires.
  Future<Either<Failure, OtpConfirmation>> _discardCredential(
    OtpConfirmation confirmation,
  ) async {
    await _pendingRegistration.clear();
    return Right<Failure, OtpConfirmation>(confirmation);
  }
}
