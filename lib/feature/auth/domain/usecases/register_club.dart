import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/registration_details.dart';
import '../entities/registration_outcome.dart';
import '../repositories/auth_repository.dart';
import '../repositories/pending_registration_repository.dart';

/// Creates a club account.
///
/// Its input type is [ClubRegistrationDetails], not the sealed base — so a
/// caller physically cannot invoke club registration without a club. That, plus
/// the required `club` field on the details, is what makes B1 unrepeatable.
///
/// ## It saves a credential, not a session
///
/// It does **not** touch `SessionRepository`. It stores the registration token
/// through [PendingRegistrationRepository], under a key that
/// `SessionRepository.readSession()` never reads — so registration still creates
/// no session and still cannot auto-login anyone.
///
/// Persisting it (rather than holding it only in memory) is what lets a user who
/// registers, closes the app, and returns later still confirm their phone. The
/// backend offers no way to re-issue this token: the unconfirmed-login response
/// is a bare 400 with only a message.
@injectable
class RegisterClub
    implements UseCase<RegistrationOutcome, ClubRegistrationDetails> {
  const RegisterClub(this._authRepository, this._pendingRegistration);

  final AuthRepository _authRepository;
  final PendingRegistrationRepository _pendingRegistration;

  @override
  ResultFuture<RegistrationOutcome> call(
    ClubRegistrationDetails details,
  ) async {
    final registration = await _authRepository.register(details);
    return registration.fold(
      (Failure failure) => Left<Failure, RegistrationOutcome>(failure),
      _rememberCredential,
    );
  }

  /// The account exists; keep the token that authorises confirming its phone.
  ///
  /// A storage failure does not fail the registration — the account *was*
  /// created, and the outcome still carries the credential in memory, so the OTP
  /// screen works for this run. Only the delayed-retry path would be lost.
  Future<Either<Failure, RegistrationOutcome>> _rememberCredential(
    RegistrationOutcome outcome,
  ) async {
    await _pendingRegistration.save(outcome.credential);
    return Right<Failure, RegistrationOutcome>(outcome);
  }
}
