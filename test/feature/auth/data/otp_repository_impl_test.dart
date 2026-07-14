import 'package:dio/dio.dart';
import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/error/exceptions.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/feature/auth/data/datasources/otp_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/data/models/otp_response_models.dart';
import 'package:falconclubapp/feature/auth/data/repositories/otp_repository_impl.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOtpRemoteDataSource extends Mock implements OtpRemoteDataSource {}

class _MockApiService extends Mock implements ApiService {}

void main() {
  final RegistrationCredential credential = RegistrationCredential.issuedNow(
    'registration-jwt',
  );
  final OtpCode code = OtpCode.create('012345').getRight().toNullable()!;

  setUpAll(() {
    registerFallbackValue(code);
    registerFallbackValue(credential);
  });

  group('OtpRepositoryImpl', () {
    late _MockOtpRemoteDataSource dataSource;
    late OtpRepositoryImpl repository;

    setUp(() {
      dataSource = _MockOtpRemoteDataSource();
      repository = OtpRepositoryImpl(dataSource, const ErrorMapper());
    });

    test('maps the live confirmation body — message and role, no token',
        () async {
      when(
        () => dataSource.confirmPhone(
          code: any(named: 'code'),
          credential: any(named: 'credential'),
        ),
      ).thenAnswer(
        (_) async => OtpConfirmationModel.fromJson(<String, dynamic>{
          'message': 'تم إرسال طلب انضمامك للتطبيق بنجاح',
          'role': 'Club',
          'data': <String, dynamic>{},
        }),
      );

      final result = await repository.confirmPhone(
        code: code,
        credential: credential,
      );

      expect(
        result.getRight().toNullable()?.message,
        'تم إرسال طلب انضمامك للتطبيق بنجاح',
      );
      expect(result.getRight().toNullable()?.role, UserRole.club);
    });

    // The server's own wording for a wrong/expired code.
    test('surfaces the server message on a rejected code', () async {
      when(
        () => dataSource.confirmPhone(
          code: any(named: 'code'),
          credential: any(named: 'credential'),
        ),
      ).thenThrow(
        const ServerException(
          message: 'الرمز غير صالح أو منتهي الصلاحية',
          statusCode: 400,
        ),
      );

      final result = await repository.confirmPhone(
        code: code,
        credential: credential,
      );

      expect(
        result.getLeft().toNullable()?.message,
        'الرمز غير صالح أو منتهي الصلاحية',
      );
    });

    test('maps the live resend body', () async {
      when(() => dataSource.resendOtp(any())).thenAnswer(
        (_) async => ResendOtpResponseModel.fromJson(<String, dynamic>{
          'message': 'تم إعادة إرسال رمز OTP بنجاح',
          'emailSent': true,
          'data': <String, dynamic>{},
        }),
      );

      final result = await repository.resendOtp(credential);

      expect(
        result.getRight().toNullable()?.message,
        'تم إعادة إرسال رمز OTP بنجاح',
      );
      expect(result.getRight().toNullable()?.emailSent, isTrue);
    });

    test('maps a transport error to a NetworkFailure', () async {
      when(() => dataSource.resendOtp(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.resendOtp(credential);

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('RetrofitOtpRemoteDataSource', () {
    late _MockApiService apiService;
    late RetrofitOtpRemoteDataSource dataSource;

    setUp(() {
      apiService = _MockApiService();
      dataSource = RetrofitOtpRemoteDataSource(apiService);
    });

    // The endpoints take NO phone number and NO user id — the Bearer token is
    // the only thing that identifies the account. If it were ever dropped, the
    // call would silently confirm nobody.
    test('sends the registration token as the Authorization header', () async {
      when(() => apiService.confirmPhoneByOtp(any(), any())).thenAnswer(
        (_) async => <String, dynamic>{'message': 'ok', 'role': 'Club'},
      );

      await dataSource.confirmPhone(code: code, credential: credential);

      verify(
        () => apiService.confirmPhoneByOtp(
          'Bearer registration-jwt',
          any(),
        ),
      ).called(1);
    });

    // The leading zero must survive all the way to the wire.
    test('sends the code as a String, preserving its leading zero', () async {
      when(() => apiService.confirmPhoneByOtp(any(), any())).thenAnswer(
        (_) async => <String, dynamic>{'message': 'ok'},
      );

      await dataSource.confirmPhone(code: code, credential: credential);

      verify(() => apiService.confirmPhoneByOtp(any(), '012345')).called(1);
    });

    test('resend also authenticates with the registration token', () async {
      when(() => apiService.resendPhoneOtp(any())).thenAnswer(
        (_) async => <String, dynamic>{'message': 'ok', 'emailSent': true},
      );

      await dataSource.resendOtp(credential);

      verify(() => apiService.resendPhoneOtp('Bearer registration-jwt'))
          .called(1);
    });
  });
}
