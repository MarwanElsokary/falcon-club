import '../../../../core/usecase/usecase.dart';
import '../entities/login_credentials.dart';
import '../entities/registration_details.dart';
import '../entities/registration_outcome.dart';
import '../entities/sign_in_response.dart';

/// The network side of authentication.
///
/// Note the asymmetry, and that it is intentional:
///
/// * [signIn] returns a [SignInResponse] — a *report* the `LogIn` use case then
///   judges (approved? role hostable? token present?). Policy stays in the
///   domain.
/// * [register] returns a [RegistrationOutcome], which carries **no session**.
///   Registration cannot log anyone in, by construction.
///
/// [register] takes the sealed [RegistrationDetails], so Club and Scout share
/// one method and the implementation dispatches by type rather than by a role
/// string.
abstract interface class AuthRepository {
  ResultFuture<SignInResponse> signIn(LoginCredentials credentials);

  ResultFuture<RegistrationOutcome> register(RegistrationDetails details);
}
