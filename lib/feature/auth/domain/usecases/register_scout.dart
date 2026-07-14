import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/registration_details.dart';
import '../entities/registration_outcome.dart';
import '../repositories/auth_repository.dart';
import '../repositories/pending_registration_repository.dart';

/// Creates a scout account.
///
/// Takes [ScoutRegistrationDetails], which has no club — scout registration is
/// club-less by design, confirmed against the product.
///
/// Like [RegisterClub], it creates **no session**. It stores the registration
/// token as a [PendingRegistrationRepository] credential so the phone can be
/// confirmed — now, or after the app is closed and reopened. See [RegisterClub]
/// for why that is not a session.
@injectable
class RegisterScout
    implements UseCase<RegistrationOutcome, ScoutRegistrationDetails> {
  const RegisterScout(this._authRepository, this._pendingRegistration);

  final AuthRepository _authRepository;
  final PendingRegistrationRepository _pendingRegistration;

  @override
  ResultFuture<RegistrationOutcome> call(
    ScoutRegistrationDetails details,
  ) async {
    final registration = await _authRepository.register(details);
    return registration.fold(
      (Failure failure) => Left<Failure, RegistrationOutcome>(failure),
      _rememberCredential,
    );
  }

  Future<Either<Failure, RegistrationOutcome>> _rememberCredential(
    RegistrationOutcome outcome,
  ) async {
    await _pendingRegistration.save(outcome.credential);
    return Right<Failure, RegistrationOutcome>(outcome);
  }
}
