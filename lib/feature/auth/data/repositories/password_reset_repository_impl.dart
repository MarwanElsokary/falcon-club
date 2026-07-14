import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../../domain/entities/password_reset_ticket.dart';
import '../../domain/repositories/password_reset_repository.dart';
import '../../domain/value_objects/otp_code.dart';
import '../datasources/password_reset_remote_data_source.dart';

/// [PasswordResetRepository] over the remote API.
///
/// 🔒 Logs nothing — see [PasswordResetRemoteDataSource] for what the repository
/// this replaces was writing to `logcat`.
///
/// A wrong code or a spent ticket comes back as an error carrying the server's
/// own message, lifted by [ErrorMapper]. Nothing here invents wording.
@LazySingleton(as: PasswordResetRepository)
class PasswordResetRepositoryImpl implements PasswordResetRepository {
  const PasswordResetRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final PasswordResetRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<String> requestReset(PhoneNumber phone) async {
    try {
      final response = await _remoteDataSource.requestReset(phone);
      return Right<Failure, String>(response.toMessage());
    } catch (error) {
      return Left<Failure, String>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<PasswordResetTicket> verifyOtp({
    required PhoneNumber phone,
    required OtpCode code,
  }) async {
    try {
      final response = await _remoteDataSource.verifyOtp(
        phone: phone,
        code: code,
      );
      return Right<Failure, PasswordResetTicket>(response.toEntity());
    } catch (error) {
      return Left<Failure, PasswordResetTicket>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<String> resetPassword({
    required PasswordResetTicket ticket,
    required Password password,
  }) async {
    try {
      final response = await _remoteDataSource.resetPassword(
        ticket: ticket,
        password: password,
      );
      return Right<Failure, String>(response.toMessage());
    } catch (error) {
      return Left<Failure, String>(_errorMapper.map(error));
    }
  }
}
