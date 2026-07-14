import '../../../../core/usecase/usecase.dart';
import '../entities/password_reset_ticket.dart';
import '../value_objects/otp_code.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';

/// The three-step password reset.
///
/// ## A different mechanism from registration OTP — deliberately not shared
///
/// Registration's OTP endpoints identify the account by a **Bearer token** and
/// take no phone number. These take the **phone number explicitly** and no
/// bearer at all (they must: a user who has forgotten their password cannot
/// authenticate). Step 2 returns a [PasswordResetTicket] which step 3 sends as a
/// **form field**.
///
/// Same *shape*, different *mechanism*. Forcing them behind one abstraction
/// would be the wrong abstraction — so the value objects are shared ([OtpCode],
/// [Password], [PhoneNumber]) and the transport is not.
abstract interface class PasswordResetRepository {
  /// Step 1 — ask the backend to text a code to [phone].
  ResultFuture<String> requestReset(PhoneNumber phone);

  /// Step 2 — prove ownership of the phone; receive the ticket.
  ResultFuture<PasswordResetTicket> verifyOtp({
    required PhoneNumber phone,
    required OtpCode code,
  });

  /// Step 3 — spend the ticket on a new password.
  ResultFuture<String> resetPassword({
    required PasswordResetTicket ticket,
    required Password password,
  });
}
