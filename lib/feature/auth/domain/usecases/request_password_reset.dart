import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../repositories/password_reset_repository.dart';

/// Step 1 — texts a reset code to the phone.
///
/// Takes a [PhoneNumber] built with `PhoneNumber.permissive`, not
/// `forSaudiRegistration`. A reset is a **lookup on an existing account**: the
/// server decides whether the number matches one. Applying the strict Saudi
/// format here would lock out any account whose stored number predates that
/// rule — the same reasoning as sign-in.
///
/// Also used for **resend**: there is no separate resend endpoint for password
/// reset, and none is needed — asking again simply sends a fresh code.
@injectable
class RequestPasswordReset implements UseCase<String, PhoneNumber> {
  const RequestPasswordReset(this._repository);

  final PasswordResetRepository _repository;

  @override
  ResultFuture<String> call(PhoneNumber phone) =>
      _repository.requestReset(phone);
}
