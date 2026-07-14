import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/password_reset_ticket.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/request_password_reset.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/reset_password.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/verify_password_reset_otp.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/password_reset_state.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestPasswordReset extends Mock implements RequestPasswordReset {}

class _MockVerifyPasswordResetOtp extends Mock
    implements VerifyPasswordResetOtp {}

class _MockResetPassword extends Mock implements ResetPassword {}

void main() {
  late _MockRequestPasswordReset requestReset;
  late _MockVerifyPasswordResetOtp verifyOtp;
  late _MockResetPassword resetPassword;

  const String phone = '500000005';
  const PasswordResetTicket ticket = PasswordResetTicket('reset-token');

  setUpAll(() {
    registerFallbackValue(
      PhoneNumber.permissive(phone).getRight().toNullable()!,
    );
    registerFallbackValue(
      VerifyPasswordResetOtpParams(
        phone: PhoneNumber.permissive(phone).getRight().toNullable()!,
        code: OtpCode.create('123456').getRight().toNullable()!,
      ),
    );
    registerFallbackValue(
      ResetPasswordParams(
        ticket: ticket,
        password: Password.create('Str0ng!Pass').getRight().toNullable()!,
      ),
    );
  });

  setUp(() {
    requestReset = _MockRequestPasswordReset();
    verifyOtp = _MockVerifyPasswordResetOtp();
    resetPassword = _MockResetPassword();
  });

  PasswordResetCubit buildCubit() =>
      PasswordResetCubit(requestReset, verifyOtp, resetPassword);

  group('step 1 — request a code', () {
    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits [InProgress, CodeSent]',
      build: () {
        when(() => requestReset(any()))
            .thenAnswer((_) async => const Right<Failure, String>('sent'));
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) => cubit.requestReset(phone),
      expect: () => const <PasswordResetState>[
        PasswordResetInProgress(),
        ResetCodeSent('sent'),
      ],
    );

    // Resend must NOT re-navigate — the user stays on the code screen.
    blocTest<PasswordResetCubit, PasswordResetState>(
      'a resend emits CodeResent, a distinct state from CodeSent',
      build: () {
        when(() => requestReset(any()))
            .thenAnswer((_) async => const Right<Failure, String>('resent'));
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) => cubit.resendCode(phone),
      expect: () => const <PasswordResetState>[
        PasswordResetInProgress(),
        ResetCodeResent('resent'),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'rejects a blank phone without calling the backend',
      build: buildCubit,
      act: (PasswordResetCubit cubit) => cubit.requestReset('  '),
      expect: () => <Matcher>[isA<PasswordResetFailed>()],
      verify: (_) => verifyNever(() => requestReset(any())),
    );

    // Permissive, not strict-Saudi: a reset is a lookup on an existing account.
    // Strict validation would lock out an account whose stored number predates
    // that rule.
    blocTest<PasswordResetCubit, PasswordResetState>(
      'accepts a non-Saudi-format phone — the server decides',
      build: () {
        when(() => requestReset(any()))
            .thenAnswer((_) async => const Right<Failure, String>('sent'));
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) => cubit.requestReset('123'),
      expect: () => const <PasswordResetState>[
        PasswordResetInProgress(),
        ResetCodeSent('sent'),
      ],
    );
  });

  group('step 2 — verify the code', () {
    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits [InProgress, OtpVerified] carrying the ticket',
      build: () {
        when(() => verifyOtp(any())).thenAnswer(
          (_) async => const Right<Failure, PasswordResetTicket>(ticket),
        );
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) =>
          cubit.verifyCode(phone: phone, typedCode: '123456'),
      expect: () => const <PasswordResetState>[
        PasswordResetInProgress(),
        ResetOtpVerified(ticket),
      ],
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'passes a leading-zero code through unchanged',
      build: () {
        when(() => verifyOtp(any())).thenAnswer(
          (_) async => const Right<Failure, PasswordResetTicket>(ticket),
        );
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) =>
          cubit.verifyCode(phone: phone, typedCode: '012345'),
      verify: (_) {
        final VerifyPasswordResetOtpParams params =
            verify(() => verifyOtp(captureAny())).captured.single
                as VerifyPasswordResetOtpParams;
        expect(params.code.value, '012345');
      },
    );

    blocTest<PasswordResetCubit, PasswordResetState>(
      'rejects a short code in the domain, without calling the backend',
      build: buildCubit,
      act: (PasswordResetCubit cubit) =>
          cubit.verifyCode(phone: phone, typedCode: '12'),
      expect: () => <Matcher>[isA<PasswordResetFailed>()],
      verify: (_) => verifyNever(() => verifyOtp(any())),
    );

    // A wrong code keeps the user on the code screen — no ticket, no advance.
    blocTest<PasswordResetCubit, PasswordResetState>(
      'surfaces the server message for a rejected code',
      build: () {
        when(() => verifyOtp(any())).thenAnswer(
          (_) async => const Left<Failure, PasswordResetTicket>(
            ServerFailure(message: 'الرمز غير صالح'),
          ),
        );
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) =>
          cubit.verifyCode(phone: phone, typedCode: '123456'),
      expect: () => const <PasswordResetState>[
        PasswordResetInProgress(),
        PasswordResetFailed('الرمز غير صالح'),
      ],
    );
  });

  group('step 3 — set the new password', () {
    blocTest<PasswordResetCubit, PasswordResetState>(
      'emits [InProgress, Completed]',
      build: () {
        when(() => resetPassword(any()))
            .thenAnswer((_) async => const Right<Failure, String>('done'));
        return buildCubit();
      },
      act: (PasswordResetCubit cubit) => cubit.submitNewPassword(
        ticket: ticket,
        password: 'Str0ng!Pass',
        confirmation: 'Str0ng!Pass',
      ),
      expect: () => const <PasswordResetState>[
        PasswordResetInProgress(),
        PasswordResetCompleted('done'),
      ],
    );

    // Checked in the domain, before any I/O — not against a form key in a
    // 579-line widget.
    blocTest<PasswordResetCubit, PasswordResetState>(
      'rejects a mismatched confirmation without calling the backend',
      build: buildCubit,
      act: (PasswordResetCubit cubit) => cubit.submitNewPassword(
        ticket: ticket,
        password: 'Str0ng!Pass',
        confirmation: 'Different!1',
      ),
      expect: () => <Matcher>[isA<PasswordResetFailed>()],
      verify: (_) => verifyNever(() => resetPassword(any())),
    );

    // Choosing a password IS strict — unlike sign-in, where an existing
    // password must be accepted even if it fails today's rules.
    blocTest<PasswordResetCubit, PasswordResetState>(
      'rejects a weak password without calling the backend',
      build: buildCubit,
      act: (PasswordResetCubit cubit) => cubit.submitNewPassword(
        ticket: ticket,
        password: 'weak',
        confirmation: 'weak',
      ),
      expect: () => <Matcher>[isA<PasswordResetFailed>()],
      verify: (_) => verifyNever(() => resetPassword(any())),
    );
  });
}
