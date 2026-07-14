import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/security/jwt_token.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/user_role.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/session_diagnostics.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_local_data_source.dart';

/// [SessionRepository] over local storage.
///
/// SRP: translates between stored primitives and the [AuthSession] entity, and
/// turns thrown exceptions into [Failure] values. Nothing else.
///
/// Every method funnels errors through [ErrorMapper], so `try/catch` never
/// leaks upward — no use case or cubit in this feature contains one.
@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._localDataSource, this._errorMapper);

  final SessionLocalDataSource _localDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<AuthSession?> readSession() async {
    try {
      return Right<Failure, AuthSession?>(await _storedSession());
    } catch (error) {
      return Left<Failure, AuthSession?>(_errorMapper.map(error));
    }
  }

  /// The stored session, or `null` when there is nothing usable.
  ///
  /// A stale token is **not** a session. Without that check, any leftover token
  /// — from an old build, an earlier test, or an expired login — sends the user
  /// straight into a role shell on launch without ever signing in, and then 401s
  /// on every request. It fails closed: an unparseable token counts as expired.
  Future<AuthSession?> _storedSession() async {
    final String? token = await _localDataSource.readToken();
    final String? userId = await _localDataSource.readUserId();

    if (_isBlank(token) || _isBlank(userId)) return null;

    if (JwtToken.isExpired(token)) {
      // Self-heal, so the dead token stops causing 401s on every launch.
      await _localDataSource.clear();
      return null;
    }

    return AuthSession(
      token: token!,
      userId: userId!,
      role: UserRole.fromApiValue(await _localDataSource.readRole()),
    );
  }

  @override
  ResultFuture<SessionDiagnostics> describeSession() async {
    try {
      final String? token = await _localDataSource.readToken();
      return Right<Failure, SessionDiagnostics>(
        SessionDiagnostics(
          hasToken: !_isBlank(token),
          tokenLength: token?.length ?? 0,
          isTokenExpired: JwtToken.isExpired(token),
          expiresAt: JwtToken.expiryOf(token),
          userId: await _localDataSource.readUserId(),
          storedRole: await _localDataSource.readRole(),
        ),
      );
    } catch (error) {
      return Left<Failure, SessionDiagnostics>(_errorMapper.map(error));
    }
  }

  bool _isBlank(String? value) => value == null || value.isEmpty;

  @override
  ResultVoid saveSession(AuthSession session) async {
    try {
      await _localDataSource.write(
        token: session.token,
        userId: session.userId,
        role: session.role.apiValue,
      );
      return const Right<Failure, void>(null);
    } catch (error) {
      return Left<Failure, void>(_errorMapper.map(error));
    }
  }

  @override
  ResultVoid clearSession() async {
    try {
      await _localDataSource.clear();
      return const Right<Failure, void>(null);
    } catch (error) {
      return Left<Failure, void>(_errorMapper.map(error));
    }
  }
}
