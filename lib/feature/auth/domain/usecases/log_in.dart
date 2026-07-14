import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/user_role.dart';
import '../entities/auth_session.dart';
import '../entities/login_credentials.dart';
import '../entities/sign_in_response.dart';
import '../repositories/auth_repository.dart';
import '../repositories/session_repository.dart';

/// Signs a user in, and persists the session only if the sign-in is legitimate.
///
/// This is where the *policy* lives — the three checks that currently sit
/// inline in a 589-line cubit:
///
/// 1. the account must be approved (`status == Accepted`);
/// 2. the role must be one this app hosts (a `Player` is refused);
/// 3. the server must actually have issued a token and a user id.
///
/// Only then is the session written. That ordering matters: the current
/// `_saveAuthData()` persists the role *before* checking whether a token even
/// exists, and logs a warning when it doesn't.
///
/// SRP: one verb. It depends on two small ports — [AuthRepository] to ask the
/// server, [SessionRepository] to remember the answer — and on no Flutter type
/// whatsoever, so every branch below is testable without a widget tree.
@injectable
class LogIn implements UseCase<AuthSession, LoginCredentials> {
  const LogIn(this._authRepository, this._sessionRepository);

  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;

  /// Shown when the backend authenticates a role this app does not host.
  /// Players have their own app.
  static const String unsupportedRoleMessage =
      'هذا التطبيق مخصص للأندية والكشافين فقط.\n'
      'إذا كنت لاعباً، يرجى استخدام تطبيق اللاعبين.';

  static const String missingCredentialsMessage =
      'لم يصدر الخادم بيانات دخول صالحة';

  @override
  ResultFuture<AuthSession> call(LoginCredentials credentials) async {
    final signIn = await _authRepository.signIn(credentials);
    return signIn.fold(
      (Failure failure) => Left<Failure, AuthSession>(failure),
      _grantSessionIfPermitted,
    );
  }

  /// Applies the three admission rules, then persists.
  Future<Either<Failure, AuthSession>> _grantSessionIfPermitted(
    SignInResponse response,
  ) async {
    final Either<Failure, AuthSession> admission = _admit(response);
    return admission.fold(
      (Failure failure) => Left<Failure, AuthSession>(failure),
      _persist,
    );
  }

  /// Pure: decides whether [response] grants entry. No I/O.
  Either<Failure, AuthSession> _admit(SignInResponse response) {
    if (!response.status.canSignIn) {
      // The server's own words — e.g. "لم يتم تأكيد رقم الجوال بعد."
      return Left<Failure, AuthSession>(
        ValidationFailure(message: response.message),
      );
    }
    final UserRole? role = response.role;
    if (role == null) {
      return const Left<Failure, AuthSession>(
        ValidationFailure(message: unsupportedRoleMessage),
      );
    }
    if (!response.hasCredentials) {
      return const Left<Failure, AuthSession>(
        ServerFailure(message: missingCredentialsMessage),
      );
    }
    return Right<Failure, AuthSession>(
      AuthSession(token: response.token!, userId: response.userId!, role: role),
    );
  }

  /// Persists the session; a storage failure fails the whole sign-in rather
  /// than leaving the app "logged in" with nothing on disk.
  Future<Either<Failure, AuthSession>> _persist(AuthSession session) async {
    final saved = await _sessionRepository.saveSession(session);
    return saved.fold(
      (Failure failure) => Left<Failure, AuthSession>(failure),
      (_) => Right<Failure, AuthSession>(session),
    );
  }
}
