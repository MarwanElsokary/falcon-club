import '../../../../core/usecase/usecase.dart';
import '../entities/otp_confirmation.dart';
import '../entities/registration_credential.dart';
import '../entities/resend_outcome.dart';
import '../value_objects/otp_code.dart';

/// Phone confirmation.
///
/// Both calls take the [RegistrationCredential] **explicitly**. That is not
/// ceremony: the OTP endpoints identify the account *solely* by the Bearer token
/// issued at registration, and that token is deliberately not the session token
/// — so it cannot be picked up implicitly by `DioFactory`'s interceptor. Passing
/// it as an argument makes the dependency visible instead of magical, and keeps
/// the credential from ever needing to be stored where a session lives.
abstract interface class OtpRepository {
  ResultFuture<OtpConfirmation> confirmPhone({
    required OtpCode code,
    required RegistrationCredential credential,
  });

  ResultFuture<ResendOutcome> resendOtp(RegistrationCredential credential);
}
