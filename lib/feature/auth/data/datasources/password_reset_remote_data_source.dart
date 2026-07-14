import 'package:injectable/injectable.dart';

import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../../domain/entities/password_reset_ticket.dart';
import '../../domain/value_objects/otp_code.dart';
import '../models/password_reset_models.dart';

/// Talks to the three password-reset endpoints.
///
/// ## 🔒 It logs nothing. Ever.
///
/// The repository this replaces logs, in plaintext:
///
/// * the **OTP** (`forget_password_repo.dart:31`)
/// * the **reset token** (`:37`)
/// * the **new password, the confirmation, AND the token** (`:54`)
///
/// Every one of those lands in `logcat`, readable by any other app with log
/// access on the device, and in any crash-reporting pipeline that scrapes logs.
/// There is no `log()` / `print()` / `debugPrint()` anywhere in this class or in
/// the repository above it, and a regression test asserts the reset flow emits
/// no output containing a secret.
///
/// None of these endpoints take a bearer token — a user who has forgotten their
/// password cannot authenticate. The phone number identifies the account in
/// steps 1 and 2; the ticket does in step 3, as a **form field**, not a header.
abstract interface class PasswordResetRemoteDataSource {
  Future<ForgetPasswordResponseModel> requestReset(PhoneNumber phone);

  Future<CheckOtpResponseModel> verifyOtp({
    required PhoneNumber phone,
    required OtpCode code,
  });

  Future<ResetPasswordResponseModel> resetPassword({
    required PasswordResetTicket ticket,
    required Password password,
  });
}

@LazySingleton(as: PasswordResetRemoteDataSource)
class RetrofitPasswordResetRemoteDataSource
    implements PasswordResetRemoteDataSource {
  const RetrofitPasswordResetRemoteDataSource(this._apiService);

  final ApiService _apiService;

  @override
  Future<ForgetPasswordResponseModel> requestReset(PhoneNumber phone) async {
    final Object? body = await _apiService.forgetPasswordByPhone(phone.value);
    return ForgetPasswordResponseModel.fromJson(Json.asObject(body));
  }

  @override
  Future<CheckOtpResponseModel> verifyOtp({
    required PhoneNumber phone,
    required OtpCode code,
  }) async {
    // The code goes out as a String — a leading zero survives.
    final Object? body = await _apiService.checkOtp(code.value, phone.value);
    return CheckOtpResponseModel.fromJson(Json.asObject(body));
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword({
    required PasswordResetTicket ticket,
    required Password password,
  }) async {
    final Object? body = await _apiService.resetPassword(
      ticket.token,
      password.value,
      // The backend requires the confirmation as a separate field. It is
      // necessarily identical: `Password.createConfirmed` already proved the two
      // matched, so there is nothing left to disagree about.
      password.value,
    );
    return ResetPasswordResponseModel.fromJson(Json.asObject(body));
  }
}
