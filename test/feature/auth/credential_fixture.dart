import 'dart:convert';

import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';

/// Builds a registration credential with [remaining] left in its 15-minute
/// window. Pass a negative duration for one whose window has already closed.
///
/// The window is measured from `issuedAt`, **not** from the token's JWT `exp` —
/// the real backend issues an effectively non-expiring JWT (its `exp` lands in
/// 2071), so the token cannot tell us the deadline. See
/// [RegistrationCredential] for the full story.
RegistrationCredential credentialValidFor(Duration remaining) {
  final DateTime issuedAt = DateTime.now().toUtc().subtract(
    RegistrationCredential.registrationWindow - remaining,
  );
  return RegistrationCredential(longLivedToken(), issuedAt: issuedAt);
}

/// A JWT shaped like the one the backend actually issues: valid, parseable, and
/// with an `exp` decades away. Reading the window from *this* is what produced
/// the "23476350:12" countdown.
String longLivedToken() {
  final DateTime farFuture = DateTime.utc(2071, 3, 3);
  final String payload = base64Url.encode(
    utf8.encode(
      jsonEncode(<String, dynamic>{
        'exp':
            farFuture.millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond,
      }),
    ),
  );
  return 'header.$payload.signature';
}
