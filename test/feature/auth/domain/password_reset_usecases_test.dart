import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/password_reset_ticket.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/password_reset_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/request_password_reset.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/reset_password.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/verify_password_reset_otp.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockPasswordResetRepository extends Mock
    implements PasswordResetRepository {}

void main() {
  late _MockPasswordResetRepository repository;

  final PhoneNumber phone = PhoneNumber.permissive(
    '500000005',
  ).getRight().toNullable()!;
  final OtpCode code = OtpCode.create('012345').getRight().toNullable()!;
  final Password password = Password.create(
    'Str0ng!Pass',
  ).getRight().toNullable()!;
  const PasswordResetTicket ticket = PasswordResetTicket('reset-token');

  setUpAll(() {
    registerFallbackValue(phone);
    registerFallbackValue(code);
    registerFallbackValue(password);
    registerFallbackValue(ticket);
  });

  setUp(() => repository = _MockPasswordResetRepository());

  group('RequestPasswordReset', () {
    test('asks the backend to text a code', () async {
      when(() => repository.requestReset(any()))
          .thenAnswer((_) async => const Right<Failure, String>('sent'));

      final result = await RequestPasswordReset(repository)(phone);

      expect(result.getRight().toNullable(), 'sent');
      verify(() => repository.requestReset(phone)).called(1);
    });

    test('surfaces the server message on failure', () async {
      when(() => repository.requestReset(any())).thenAnswer(
        (_) async => const Left<Failure, String>(
          ServerFailure(message: 'رقم الجوال غير مسجل'),
        ),
      );

      final result = await RequestPasswordReset(repository)(phone);

      expect(result.getLeft().toNullable()?.message, 'رقم الجوال غير مسجل');
    });
  });

  group('VerifyPasswordResetOtp', () {
    test('exchanges the code for a ticket, sending the phone too', () async {
      when(
        () => repository.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, PasswordResetTicket>(ticket),
      );

      final result = await VerifyPasswordResetOtp(repository)(
        VerifyPasswordResetOtpParams(phone: phone, code: code),
      );

      expect(result.getRight().toNullable(), ticket);
      // Unlike registration's OTP, this call is unauthenticated — the phone is
      // the only thing identifying the account.
      verify(() => repository.verifyOtp(phone: phone, code: code)).called(1);
    });

    // The code carries a leading zero. It must survive — OtpCode keeps it a
    // String, so it does.
    test('preserves a leading-zero code', () async {
      when(
        () => repository.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, PasswordResetTicket>(ticket),
      );

      await VerifyPasswordResetOtp(repository)(
        VerifyPasswordResetOtpParams(phone: phone, code: code),
      );

      final OtpCode sent =
          verify(
                () => repository.verifyOtp(
                  phone: any(named: 'phone'),
                  code: captureAny(named: 'code'),
                ),
              ).captured.single
              as OtpCode;
      expect(sent.value, '012345');
    });

    test('surfaces a rejected code', () async {
      when(
        () => repository.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer(
        (_) async => const Left<Failure, PasswordResetTicket>(
          ServerFailure(message: 'الرمز غير صالح'),
        ),
      );

      final result = await VerifyPasswordResetOtp(repository)(
        VerifyPasswordResetOtpParams(phone: phone, code: code),
      );

      expect(result.getLeft().toNullable()?.message, 'الرمز غير صالح');
    });
  });

  group('ResetPassword', () {
    test('spends the ticket on the new password', () async {
      when(
        () => repository.resetPassword(
          ticket: any(named: 'ticket'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right<Failure, String>('done'));

      final result = await ResetPassword(repository)(
        ResetPasswordParams(ticket: ticket, password: password),
      );

      expect(result.getRight().toNullable(), 'done');
    });

    // The legacy CheckOtpResponse declares resetToken non-nullable and throws
    // on a missing one. Here a blank ticket fails cleanly, before any I/O.
    test('refuses a blank ticket without calling the backend', () async {
      final result = await ResetPassword(repository)(
        ResetPasswordParams(
          ticket: const PasswordResetTicket(''),
          password: password,
        ),
      );

      expect(result.getLeft().toNullable(), isA<ValidationFailure>());
      verifyNever(
        () => repository.resetPassword(
          ticket: any(named: 'ticket'),
          password: any(named: 'password'),
        ),
      );
    });

    test('never leaks the ticket or the password through toString', () {
      final ResetPasswordParams params = ResetPasswordParams(
        ticket: ticket,
        password: password,
      );

      expect(params.toString(), isNot(contains('reset-token')));
      expect(params.toString(), isNot(contains('Str0ng!Pass')));
    });
  });
}
