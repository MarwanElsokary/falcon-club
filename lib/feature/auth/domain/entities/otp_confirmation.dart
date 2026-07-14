import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/user_role.dart';

/// The result of confirming a phone number.
///
/// Captured live:
/// ```json
/// { "message": "تم إرسال طلب انضمامك للتطبيق بنجاح", "role": "Club", "data": {} }
/// ```
///
/// **There is no token in this response** — confirmed against the live endpoint.
/// So even if we wanted to auto-login here, there would be nothing to do it
/// with. The user goes to the login screen, and the account is now in the
/// *pending approval* state (`LoginClub` will answer `status: "Warning"` until
/// an admin approves it).
final class OtpConfirmation extends Equatable {
  const OtpConfirmation({required this.message, this.role});

  /// The server's own words — shown to the user verbatim.
  final String message;

  /// Present in the response, though the app has nothing to do with it yet:
  /// the role only matters once the account is approved and login issues a
  /// session.
  final UserRole? role;

  @override
  List<Object?> get props => [message, role];
}
