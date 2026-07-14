import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../../domain/entities/password_reset_ticket.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/verify_password_reset_otp.dart';
import '../../domain/value_objects/otp_code.dart';
import 'password_reset_state.dart';

/// Drives all three password-reset screens.
///
/// One cubit, three verbs — they are one transaction, and splitting them would
/// mean threading the phone and the ticket through three separate cubits.
///
/// It holds **no** `TextEditingController`, no `GlobalKey<FormState>`, and no
/// `Timer`. `ForgetPasswordCubit` holds four controllers and a `Timer`, and its
/// `updatePasswordValidation()` is an empty stub that validates nothing at all.
/// Here validation lives in the value objects, and the countdown lives in the
/// widget that draws it.
@injectable
class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(
    this._requestPasswordReset,
    this._verifyPasswordResetOtp,
    this._resetPassword,
  ) : super(const PasswordResetIdle());

  final RequestPasswordReset _requestPasswordReset;
  final VerifyPasswordResetOtp _verifyPasswordResetOtp;
  final ResetPassword _resetPassword;

  /// Step 1 — text a code to [phone].
  Future<void> requestReset(String phone) =>
      _sendCode(phone, isResend: false);

  /// Resend. There is no separate endpoint — asking again simply sends a fresh
  /// code. It emits [ResetCodeResent] so the screen restarts its countdown
  /// instead of navigating forward a second time.
  Future<void> resendCode(String phone) => _sendCode(phone, isResend: true);

  Future<void> _sendCode(String phone, {required bool isResend}) async {
    final Either<ValidationFailure, PhoneNumber> number = _phoneFrom(phone);

    await number.fold(
      (ValidationFailure failure) async =>
          emit(PasswordResetFailed(failure.message)),
      (PhoneNumber validated) async {
        emit(const PasswordResetInProgress());
        final result = await _requestPasswordReset(validated);
        emit(
          result.fold(
            (Failure failure) => PasswordResetFailed(failure.message),
            (String message) =>
                isResend ? ResetCodeResent(message) : ResetCodeSent(message),
          ),
        );
      },
    );
  }

  /// Step 2 — exchange the code for a ticket.
  Future<void> verifyCode({
    required String phone,
    required String typedCode,
  }) async {
    final Either<ValidationFailure, OtpCode> code = OtpCode.create(typedCode);
    final Either<ValidationFailure, PhoneNumber> number = _phoneFrom(phone);

    final Either<ValidationFailure, VerifyPasswordResetOtpParams> params = code
        .flatMap(
          (OtpCode validCode) => number.map(
            (PhoneNumber validPhone) => VerifyPasswordResetOtpParams(
              phone: validPhone,
              code: validCode,
            ),
          ),
        );

    await params.fold(
      (ValidationFailure failure) async =>
          emit(PasswordResetFailed(failure.message)),
      _submitCode,
    );
  }

  Future<void> _submitCode(VerifyPasswordResetOtpParams params) async {
    emit(const PasswordResetInProgress());
    final result = await _verifyPasswordResetOtp(params);
    emit(
      result.fold(
        (Failure failure) => PasswordResetFailed(failure.message),
        (PasswordResetTicket ticket) => ResetOtpVerified(ticket),
      ),
    );
  }

  /// Step 3 — spend the ticket on a new password.
  ///
  /// The confirmation is checked **in the domain**, before any I/O, by
  /// `Password.createConfirmed`. `ResetPasswordScreen` does this inline today,
  /// in a 579-line widget, against a form key.
  Future<void> submitNewPassword({
    required PasswordResetTicket ticket,
    required String password,
    required String confirmation,
  }) async {
    final Either<ValidationFailure, Password> secret =
        Password.createConfirmed(
          password: password,
          confirmation: confirmation,
        );

    await secret.fold(
      (ValidationFailure failure) async =>
          emit(PasswordResetFailed(failure.message)),
      (Password validated) => _submitPassword(ticket, validated),
    );
  }

  Future<void> _submitPassword(
    PasswordResetTicket ticket,
    Password password,
  ) async {
    emit(const PasswordResetInProgress());
    final result = await _resetPassword(
      ResetPasswordParams(ticket: ticket, password: password),
    );
    emit(
      result.fold(
        (Failure failure) => PasswordResetFailed(failure.message),
        (String message) => PasswordResetCompleted(message),
      ),
    );
  }

  /// Permissive, not `forSaudiRegistration` — a reset is a *lookup on an
  /// existing account*. Strict validation here would lock out any account whose
  /// stored number predates that rule. Same reasoning as sign-in.
  Either<ValidationFailure, PhoneNumber> _phoneFrom(String phone) =>
      PhoneNumber.permissive(phone);
}
