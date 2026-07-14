import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/otp_confirmation.dart';
import '../../domain/entities/registration_credential.dart';
import '../../domain/entities/resend_outcome.dart';
import '../../domain/repositories/otp_repository.dart';
import '../../domain/value_objects/otp_code.dart';
import '../datasources/otp_remote_data_source.dart';

/// [OtpRepository] over the remote API.
///
/// A wrong or expired code comes back as a **400** with the server's message
/// ("الرمز غير صالح أو منتهي الصلاحية"), which [ErrorMapper] lifts into a
/// [ServerFailure] carrying that text — so the user sees the backend's own
/// wording rather than something invented here.
@LazySingleton(as: OtpRepository)
class OtpRepositoryImpl implements OtpRepository {
  const OtpRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final OtpRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<OtpConfirmation> confirmPhone({
    required OtpCode code,
    required RegistrationCredential credential,
  }) async {
    try {
      final response = await _remoteDataSource.confirmPhone(
        code: code,
        credential: credential,
      );
      return Right<Failure, OtpConfirmation>(response.toEntity());
    } catch (error) {
      return Left<Failure, OtpConfirmation>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<ResendOutcome> resendOtp(
    RegistrationCredential credential,
  ) async {
    try {
      final response = await _remoteDataSource.resendOtp(credential);
      return Right<Failure, ResendOutcome>(response.toEntity());
    } catch (error) {
      return Left<Failure, ResendOutcome>(_errorMapper.map(error));
    }
  }
}
