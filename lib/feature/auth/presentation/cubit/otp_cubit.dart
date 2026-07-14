import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/otp_confirmation.dart';
import '../../domain/entities/registration_credential.dart';
import '../../domain/entities/resend_outcome.dart';
import '../../domain/usecases/confirm_phone_otp.dart';
import '../../domain/usecases/resend_phone_otp.dart';
import '../../domain/value_objects/otp_code.dart';
import 'otp_state.dart';

/// Drives the OTP screen.
///
/// Depends on two use cases and holds no Flutter types — the screen owns the
/// Pinput controller and the countdown.
///
/// The [RegistrationCredential] is handed in at construction: it is what
/// authenticates both calls, and it is the only thing that tells the backend
/// whose phone this is.
@injectable
class OtpCubit extends Cubit<OtpState> {
  OtpCubit(
    this._confirmPhoneOtp,
    this._resendPhoneOtp,
    @factoryParam this._credential,
  ) : super(const OtpIdle());

  final ConfirmPhoneOtp _confirmPhoneOtp;
  final ResendPhoneOtp _resendPhoneOtp;
  final RegistrationCredential _credential;

  /// The credential this screen is confirming — exposed so the screen can show
  /// the user how long their registration window has left.
  RegistrationCredential get credential => _credential;

  /// Validates the typed code, then confirms.
  ///
  /// The code stays a **String** the whole way to the wire. The legacy path did
  /// `int.parse(code)`, which turns `"012345"` into `12345` and sends the wrong
  /// code — silently, for roughly one user in ten.
  Future<void> confirm(String typedCode) async {
    if (_hasExpired) return;

    final Either<ValidationFailure, OtpCode> code = OtpCode.create(typedCode);

    await code.fold(
      (ValidationFailure failure) async => emit(OtpFailed(failure.message)),
      _submit,
    );
  }

  /// Called by the screen's countdown when the 15-minute window closes.
  void expire() => emit(const OtpCredentialExpired());

  /// Refuses to call a backend that is guaranteed to answer 401.
  ///
  /// Both OTP endpoints reject an expired registration token, and none can be
  /// re-issued. Firing the request anyway would surface "invalid code", which is
  /// both wrong and actively misleading — the code is fine; the window is shut.
  bool get _hasExpired {
    if (_credential.isUsable) return false;
    emit(const OtpCredentialExpired());
    return true;
  }

  Future<void> _submit(OtpCode code) async {
    emit(const OtpConfirming());
    final result = await _confirmPhoneOtp(
      ConfirmPhoneOtpParams(code: code, credential: _credential),
    );
    emit(
      result.fold(
        (Failure failure) => OtpFailed(failure.message),
        (OtpConfirmation confirmation) => OtpConfirmed(confirmation),
      ),
    );
  }

  /// Asks for a fresh code.
  ///
  /// Entirely new — the legacy resend button called nothing at all.
  ///
  /// Resending does **not** extend the registration window: the new code is
  /// still validated against the same 15-minute credential. So once that has
  /// lapsed, resending is as futile as confirming.
  Future<void> resend() async {
    if (_hasExpired) return;

    emit(const OtpResending());
    final result = await _resendPhoneOtp(_credential);
    emit(
      result.fold(
        (Failure failure) => OtpFailed(failure.message),
        (ResendOutcome outcome) => OtpResent(outcome.message),
      ),
    );
  }
}
