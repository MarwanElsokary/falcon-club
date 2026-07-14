import 'package:falconclubapp/core/error/exceptions.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/feature/auth/data/datasources/club_directory_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/data/datasources/password_reset_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/domain/entities/password_reset_ticket.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockApiService extends Mock implements ApiService {}

/// Phase 7 cut the last two typed-DTO dependencies out of `ApiService`: the five
/// methods that returned `CountriesClubModel` / `ForgetPasswordResponse` /
/// `CheckOtpResponse` / `ResetPasswordResponse` now return `dynamic`, and the
/// bodies are parsed under `feature/auth/data` instead.
///
/// That moved real parsing logic into these two data sources, where nothing was
/// covering it — the repository tests mock the data source away. These tests
/// drive the *real* data sources against a mocked [ApiService], so the wire
/// contract is pinned.
void main() {
  late _MockApiService api;

  setUp(() => api = _MockApiService());

  group('club directory parses the raw body', () {
    late RetrofitClubDirectoryRemoteDataSource dataSource;

    setUp(() => dataSource = RetrofitClubDirectoryRemoteDataSource(api));

    test('reads the {message, data:[{id, name}]} shape', () async {
      when(() => api.countries()).thenAnswer(
        (_) async => <String, dynamic>{
          'message': 'ok',
          'data': <dynamic>[
            <String, dynamic>{'id': 'riyadh-guid', 'name': 'الرياض'},
            <String, dynamic>{'id': 'jeddah-guid', 'name': 'جدة'},
          ],
        },
      );

      final cities = await dataSource.fetchCities();

      expect(cities.map((c) => c.name), ['الرياض', 'جدة']);
      expect(cities.first.id, 'riyadh-guid');
    });

    // The id is handed straight back to the backend as the `CountryId` query
    // param and, for clubs, as `ClubId`. Re-typing it could change the request,
    // so a numeric id must survive as its exact string form.
    test('stringifies a numeric id verbatim rather than re-typing it', () async {
      when(() => api.clubsByCountry('7')).thenAnswer(
        (_) async => <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'id': 42, 'name': 'الهلال'},
          ],
        },
      );

      final clubs = await dataSource.fetchClubsInCity('7');

      expect(clubs.single.id, '42');
    });

    test('a row missing its name degrades to empty, it does not throw', () async {
      when(() => api.countries()).thenAnswer(
        (_) async => <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'id': 'x'},
          ],
        },
      );

      final cities = await dataSource.fetchCities();

      expect(cities.single.name, isEmpty);
      expect(cities.single.id, 'x');
    });

    test('a malformed row is skipped, the rest of the list survives', () async {
      when(() => api.countries()).thenAnswer(
        (_) async => <String, dynamic>{
          'data': <dynamic>[
            'not-an-object',
            <String, dynamic>{'id': 'ok', 'name': 'الدمام'},
          ],
        },
      );

      final cities = await dataSource.fetchCities();

      expect(cities.single.name, 'الدمام');
    });

    // A null `data` where an array was promised is a contract violation. Failing
    // loudly surfaces the server's error; degrading to `[]` would render an
    // empty dropdown the user cannot get past, with no explanation.
    test('a null data array is a server error, not an empty list', () async {
      when(
        () => api.countries(),
      ).thenAnswer((_) async => <String, dynamic>{'data': null});

      expect(dataSource.fetchCities, throwsA(isA<ServerException>()));
    });

    test('an empty city id never reaches the network', () async {
      expect(
        () => dataSource.fetchClubsInCity(''),
        throwsA(isA<ServerException>()),
      );
      verifyNever(() => api.clubsByCountry(any()));
    });
  });

  group('password reset parses the raw body', () {
    late RetrofitPasswordResetRemoteDataSource dataSource;
    late PhoneNumber phone;

    setUp(() {
      dataSource = RetrofitPasswordResetRemoteDataSource(api);
      phone = PhoneNumber.forSaudiRegistration('512345678').getRight().toNullable()!;
    });

    test('keeps the server message when a reset is requested', () async {
      when(() => api.forgetPasswordByPhone(any())).thenAnswer(
        (_) async => <String, dynamic>{'message': 'تم إرسال رمز التحقق'},
      );

      final response = await dataSource.requestReset(phone);

      expect(response.toMessage(), 'تم إرسال رمز التحقق');
    });

    test('carries the reset token off the OTP check', () async {
      when(() => api.checkOtp(any(), any())).thenAnswer(
        (_) async => <String, dynamic>{
          'message': 'ok',
          'resetToken': 'ticket-abc',
        },
      );

      final response = await dataSource.verifyOtp(
        phone: phone,
        code: OtpCode.create('012345').getRight().toNullable()!,
      );

      expect(response.toEntity(), const PasswordResetTicket('ticket-abc'));
    });

    // The freezed model this replaces declared `resetToken` non-nullable, so a
    // response without it threw a TypeError out of `fromJson` and the user saw a
    // crash. Now it yields an unusable ticket, which `ResetPassword` refuses.
    test('a missing reset token yields an unusable ticket, not a crash', () async {
      when(() => api.checkOtp(any(), any())).thenAnswer(
        (_) async => <String, dynamic>{'message': 'رمز غير صحيح'},
      );

      final response = await dataSource.verifyOtp(
        phone: phone,
        code: OtpCode.create('000000').getRight().toNullable()!,
      );

      expect(response.toEntity().isUsable, isFalse);
    });

    test('sends the confirmation as its own field and keeps the message', () async {
      when(() => api.resetPassword(any(), any(), any())).thenAnswer(
        (_) async => <String, dynamic>{'message': 'تم تغيير كلمة المرور بنجاح'},
      );
      final password = Password.create('Str0ng!Pass').getRight().toNullable()!;

      final response = await dataSource.resetPassword(
        ticket: const PasswordResetTicket('ticket-abc'),
        password: password,
      );

      expect(response.toMessage(), 'تم تغيير كلمة المرور بنجاح');
      verify(
        () => api.resetPassword('ticket-abc', 'Str0ng!Pass', 'Str0ng!Pass'),
      ).called(1);
    });

    test('a blank message falls back rather than showing an empty snackbar', () async {
      when(
        () => api.forgetPasswordByPhone(any()),
      ).thenAnswer((_) async => <String, dynamic>{});

      final response = await dataSource.requestReset(phone);

      expect(response.toMessage(), isNotEmpty);
    });
  });
}
