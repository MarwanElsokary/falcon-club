import 'package:injectable/injectable.dart';

import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../../domain/entities/registration_credential.dart';
import '../../domain/value_objects/otp_code.dart';
import '../models/otp_response_models.dart';

/// Talks to the phone-confirmation endpoints.
abstract interface class OtpRemoteDataSource {
  Future<OtpConfirmationModel> confirmPhone({
    required OtpCode code,
    required RegistrationCredential credential,
  });

  Future<ResendOtpResponseModel> resendOtp(RegistrationCredential credential);
}

/// Retrofit-backed.
///
/// The `Authorization` header is passed **explicitly** from the
/// [RegistrationCredential], not left to `DioFactory`'s interceptor — that
/// interceptor only attaches the *session* token, which does not exist during
/// registration. This is the only mechanism by which the backend learns whose
/// phone is being confirmed: neither endpoint takes a phone number or a user id.
///
/// The code goes out as a **String**. Sending it as an int (as the legacy
/// `ApiService.otp(int)` does) destroys a leading zero.
@LazySingleton(as: OtpRemoteDataSource)
class RetrofitOtpRemoteDataSource implements OtpRemoteDataSource {
  const RetrofitOtpRemoteDataSource(this._apiService);

  final ApiService _apiService;

  @override
  Future<OtpConfirmationModel> confirmPhone({
    required OtpCode code,
    required RegistrationCredential credential,
  }) async {
    final response = await _apiService.confirmPhoneByOtp(
      credential.authorizationHeader,
      code.value,
    );
    return OtpConfirmationModel.fromJson(Json.asObject(response));
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(
    RegistrationCredential credential,
  ) async {
    final response = await _apiService.resendPhoneOtp(
      credential.authorizationHeader,
    );
    return ResendOtpResponseModel.fromJson(Json.asObject(response));
  }
}
