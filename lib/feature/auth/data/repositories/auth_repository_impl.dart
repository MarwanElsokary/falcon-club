import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/registration_details.dart';
import '../../domain/entities/registration_outcome.dart';
import '../../domain/entities/sign_in_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// [AuthRepository] over the remote API.
///
/// SRP: DTO → entity, exception → [Failure]. It makes no decision about whether
/// the sign-in is *permitted* — that policy is the `LogIn` use case's, so it can
/// be tested without stubbing a network at all.
///
/// A refused sign-in (`status != Accepted`) is **not** an error here: the
/// request succeeded, and the server's answer was "no". It comes back as a
/// `Right(SignInResponse)` carrying the refusal, and `LogIn` turns it into a
/// `Left`. Only transport and parsing problems are `Left`s at this level.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final AuthRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<SignInResponse> signIn(LoginCredentials credentials) async {
    try {
      final response = await _remoteDataSource.signIn(credentials);
      return Right<Failure, SignInResponse>(response.toEntity());
    } catch (error) {
      return Left<Failure, SignInResponse>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<RegistrationOutcome> register(
    RegistrationDetails details,
  ) async {
    try {
      final response = await _remoteDataSource.register(details);
      return Right<Failure, RegistrationOutcome>(response.toEntity());
    } catch (error) {
      return Left<Failure, RegistrationOutcome>(_errorMapper.map(error));
    }
  }
}
