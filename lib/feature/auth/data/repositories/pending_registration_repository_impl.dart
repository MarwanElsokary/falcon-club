import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/registration_credential.dart';
import '../../domain/repositories/pending_registration_repository.dart';
import '../datasources/pending_registration_local_data_source.dart';

/// [PendingRegistrationRepository] over secure storage.
///
/// Writes only to `StorageKeys.pendingRegistrationToken`. It has no reference to
/// `SessionLocalDataSource` and no way to reach `StorageKeys.authToken`, so a
/// pending registration cannot leak into a session even by mistake.
@LazySingleton(as: PendingRegistrationRepository)
class PendingRegistrationRepositoryImpl
    implements PendingRegistrationRepository {
  const PendingRegistrationRepositoryImpl(
    this._localDataSource,
    this._errorMapper,
  );

  final PendingRegistrationLocalDataSource _localDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<RegistrationCredential?> read() async {
    try {
      final String? token = await _localDataSource.readToken();
      final DateTime? issuedAt = await _localDataSource.readIssuedAt();

      // Without the issue time the 15-minute deadline is unknowable — the token
      // does not encode it. Fail closed rather than invent one.
      if (token == null || token.isEmpty || issuedAt == null) {
        return const Right<Failure, RegistrationCredential?>(null);
      }

      return Right<Failure, RegistrationCredential?>(
        RegistrationCredential(token, issuedAt: issuedAt),
      );
    } catch (error) {
      return Left<Failure, RegistrationCredential?>(_errorMapper.map(error));
    }
  }

  @override
  ResultVoid save(RegistrationCredential credential) async {
    try {
      await _localDataSource.write(
        token: credential.token,
        issuedAt: credential.issuedAt,
      );
      return const Right<Failure, void>(null);
    } catch (error) {
      return Left<Failure, void>(_errorMapper.map(error));
    }
  }

  @override
  ResultVoid clear() async {
    try {
      await _localDataSource.clear();
      return const Right<Failure, void>(null);
    } catch (error) {
      return Left<Failure, void>(_errorMapper.map(error));
    }
  }
}
