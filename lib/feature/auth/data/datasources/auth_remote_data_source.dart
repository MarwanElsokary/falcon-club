import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/entities/registration_details.dart';
import '../constants/auth_request_fields.dart';
import '../models/login_response_model.dart';
import '../models/registration_request_builder.dart';
import '../models/registration_response_model.dart';

/// Talks to the auth endpoints.
///
/// DIP: an interface, so the repository is testable with no HTTP client.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> signIn(LoginCredentials credentials);

  Future<RegistrationResponseModel> register(RegistrationDetails details);
}

/// Retrofit-backed, through the shared injected [ApiService].
///
/// Both registration endpoints go through one method. [_postRegistration]
/// switches over the sealed [RegistrationDetails] to pick the endpoint — an
/// exhaustive, compile-checked dispatch rather than a role string.
@LazySingleton(as: AuthRemoteDataSource)
class RetrofitAuthRemoteDataSource implements AuthRemoteDataSource {
  const RetrofitAuthRemoteDataSource(this._apiService, this._requestBuilder);

  final ApiService _apiService;
  final RegistrationRequestBuilder _requestBuilder;

  @override
  Future<LoginResponseModel> signIn(LoginCredentials credentials) async {
    final response = await _apiService.login(_signInBody(credentials));
    return LoginResponseModel.fromJson(Json.asObject(response));
  }

  @override
  Future<RegistrationResponseModel> register(
    RegistrationDetails details,
  ) async {
    final FormData body = await _requestBuilder.build(details);
    final response = await _postRegistration(details, body);
    return RegistrationResponseModel.fromJson(Json.asObject(response));
  }

  /// The only place the two registration endpoints differ.
  Future<dynamic> _postRegistration(
    RegistrationDetails details,
    FormData body,
  ) => switch (details) {
    ClubRegistrationDetails() => _apiService.registerClub(body),
    ScoutRegistrationDetails() => _apiService.registerScout(body),
  };

  /// ⚠️ `Email` here carries the **phone number** — a backend misnomer on
  /// `LoginClub`, confirmed against the contract. See [AuthRequestFields].
  FormData _signInBody(LoginCredentials credentials) => FormData.fromMap({
    AuthRequestFields.fcmToken: AuthRequestFields.unlinkedFcmToken,
    AuthRequestFields.loginPhone: credentials.phone.value,
    AuthRequestFields.password: credentials.password.value,
  });
}
