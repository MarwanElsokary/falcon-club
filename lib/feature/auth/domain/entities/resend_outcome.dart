import 'package:equatable/equatable.dart';

/// The result of asking the backend to send a new OTP.
///
/// Captured live:
/// ```json
/// { "message": "تم إعادة إرسال رمز OTP بنجاح", "emailSent": true, "data": {} }
/// ```
///
/// This endpoint does not exist in the app today — resend was never
/// implemented. The button was there, but its network call was commented out
/// and its countdown reset was a tear-off missing its parentheses
/// (`_restartCountdown;`), so tapping it did nothing at all.
final class ResendOutcome extends Equatable {
  const ResendOutcome({required this.message, this.emailSent = false});

  final String message;
  final bool emailSent;

  @override
  List<Object?> get props => [message, emailSent];
}
