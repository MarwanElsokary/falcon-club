import 'dart:async';

import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/error/exceptions.dart';
import 'package:falconclubapp/feature/auth/data/datasources/password_reset_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/data/models/password_reset_models.dart';
import 'package:falconclubapp/feature/auth/data/repositories/password_reset_repository_impl.dart';
import 'package:falconclubapp/feature/auth/domain/entities/password_reset_ticket.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPasswordResetRemoteDataSource extends Mock
    implements PasswordResetRemoteDataSource {}

/// Regression test for the plaintext-credential logging in
/// `forget_password_repo.dart`.
///
/// That file writes secrets straight to `logcat`:
///
/// * line 31 — the **OTP**
/// * line 37 — the **reset token**
/// * line 54 — the **new password, the confirmation, AND the token**
///
/// Anything in `logcat` is readable by other processes with log access and gets
/// swept up by crash-reporting pipelines that scrape device logs. A password
/// reset is exactly the moment you must not do that.
///
/// This test runs the whole reset flow inside a capturing [Zone] and asserts
/// that **nothing** printed contains a secret. It fails the moment someone adds
/// a "temporary" debug `print`.
void main() {
  const String secretPassword = 'Str0ng!Secret';
  const String secretTicket = 'reset-token-abc123';
  const String secretCode = '012345';
  const String phoneValue = '500000005';

  late _MockPasswordResetRemoteDataSource dataSource;
  late PasswordResetRepositoryImpl repository;

  final PhoneNumber phone = PhoneNumber.permissive(
    phoneValue,
  ).getRight().toNullable()!;
  final OtpCode code = OtpCode.create(secretCode).getRight().toNullable()!;
  final Password password = Password.create(
    secretPassword,
  ).getRight().toNullable()!;
  const PasswordResetTicket ticket = PasswordResetTicket(secretTicket);

  setUpAll(() {
    registerFallbackValue(phone);
    registerFallbackValue(code);
    registerFallbackValue(password);
    registerFallbackValue(ticket);
  });

  setUp(() {
    dataSource = _MockPasswordResetRemoteDataSource();
    repository = PasswordResetRepositoryImpl(dataSource, const ErrorMapper());
  });

  /// Runs [body] and returns everything it printed.
  Future<List<String>> captureOutput(Future<void> Function() body) async {
    final List<String> printed = <String>[];
    await runZoned(
      body,
      zoneSpecification: ZoneSpecification(
        print: (_, __, ___, String line) => printed.add(line),
      ),
    );
    return printed;
  }

  void expectNoSecretsIn(List<String> output) {
    final String combined = output.join('\n');
    expect(
      combined,
      isNot(contains(secretPassword)),
      reason: 'the new password must never be logged',
    );
    expect(
      combined,
      isNot(contains(secretTicket)),
      reason: 'the reset token must never be logged',
    );
    expect(
      combined,
      isNot(contains(secretCode)),
      reason: 'the OTP must never be logged',
    );
  }

  group('the password-reset flow logs no secrets', () {
    test('requesting a reset prints nothing at all', () async {
      when(() => dataSource.requestReset(any())).thenAnswer(
        (_) async => const ForgetPasswordResponseModel(message: 'sent'),
      );

      final List<String> output = await captureOutput(
        () => repository.requestReset(phone),
      );

      expect(output, isEmpty);
    });

    // forget_password_repo.dart:31 logs the OTP; :37 logs the reset token.
    test('verifying the OTP leaks neither the code nor the ticket', () async {
      when(
        () => dataSource.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer(
        (_) async => const CheckOtpResponseModel(
          message: 'ok',
          resetToken: secretTicket,
        ),
      );

      final List<String> output = await captureOutput(
        () => repository.verifyOtp(phone: phone, code: code),
      );

      expect(output, isEmpty);
      expectNoSecretsIn(output);
    });

    // forget_password_repo.dart:54 — the worst one. It logs the new password,
    // the confirmation, and the token, all in one line.
    test('resetting the password leaks neither the password nor the ticket',
        () async {
      when(
        () => dataSource.resetPassword(
          ticket: any(named: 'ticket'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const ResetPasswordResponseModel(message: 'done'),
      );

      final List<String> output = await captureOutput(
        () => repository.resetPassword(ticket: ticket, password: password),
      );

      expect(output, isEmpty);
      expectNoSecretsIn(output);
    });

    // The failure path is where "temporary" debug logging usually appears.
    test('a failure leaks nothing either', () async {
      when(
        () => dataSource.resetPassword(
          ticket: any(named: 'ticket'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const ServerException(message: 'rejected'));

      final List<String> output = await captureOutput(
        () => repository.resetPassword(ticket: ticket, password: password),
      );

      expect(output, isEmpty);
      expectNoSecretsIn(output);
    });
  });

  group('secrets are redacted even when an object is stringified', () {
    // A ticket in an error message, a log line, or a crash report must not
    // become a usable credential.
    test('PasswordResetTicket.toString hides the token', () {
      expect(ticket.toString(), isNot(contains(secretTicket)));
      expect(ticket.toString(), contains('isUsable'));
    });

    test('Password.toString hides the secret', () {
      expect(password.toString(), isNot(contains(secretPassword)));
    });

    test('an empty ticket is unusable rather than silently accepted', () {
      // The legacy CheckOtpResponse declares resetToken non-nullable, so a
      // missing token throws a TypeError. Here it degrades.
      expect(
        const CheckOtpResponseModel(message: 'ok').toEntity().isUsable,
        isFalse,
      );
    });
  });
}
