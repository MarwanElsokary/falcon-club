import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/otp_confirmation.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:falconclubapp/feature/auth/domain/entities/resend_outcome.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/confirm_phone_otp.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/resend_phone_otp.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/otp_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../credential_fixture.dart';

class _MockConfirmPhoneOtp extends Mock implements ConfirmPhoneOtp {}

class _MockResendPhoneOtp extends Mock implements ResendPhoneOtp {}

void main() {
  late _MockConfirmPhoneOtp confirmPhoneOtp;
  late _MockResendPhoneOtp resendPhoneOtp;

  /// A *live* credential. It must carry a real, unexpired `exp` claim: the cubit
  /// now refuses to call the backend once the 15-minute registration window has
  /// closed, and an unparseable token counts as expired (fail-closed).
  final RegistrationCredential credential = credentialValidFor(
    const Duration(minutes: 15),
  );

  const OtpConfirmation confirmation = OtpConfirmation(
    message: 'تم إرسال طلب انضمامك للتطبيق بنجاح',
  );

  setUpAll(() {
    registerFallbackValue(
      ConfirmPhoneOtpParams(
        code: OtpCode.create('123456').getRight().toNullable()!,
        credential: credential,
      ),
    );
    registerFallbackValue(credential);
  });

  setUp(() {
    confirmPhoneOtp = _MockConfirmPhoneOtp();
    resendPhoneOtp = _MockResendPhoneOtp();
  });

  OtpCubit buildCubit() =>
      OtpCubit(confirmPhoneOtp, resendPhoneOtp, credential);

  blocTest<OtpCubit, OtpState>(
    'emits [Confirming, Confirmed] on a valid code',
    build: () {
      when(() => confirmPhoneOtp(any())).thenAnswer(
        (_) async => const Right<Failure, OtpConfirmation>(confirmation),
      );
      return buildCubit();
    },
    act: (OtpCubit cubit) => cubit.confirm('123456'),
    expect: () => const <OtpState>[OtpConfirming(), OtpConfirmed(confirmation)],
  );

  // The leading zero must reach the use case intact — never parsed to an int.
  blocTest<OtpCubit, OtpState>(
    'passes a leading-zero code through unchanged',
    build: () {
      when(() => confirmPhoneOtp(any())).thenAnswer(
        (_) async => const Right<Failure, OtpConfirmation>(confirmation),
      );
      return buildCubit();
    },
    act: (OtpCubit cubit) => cubit.confirm('012345'),
    verify: (_) {
      final ConfirmPhoneOtpParams params =
          verify(() => confirmPhoneOtp(captureAny())).captured.single
              as ConfirmPhoneOtpParams;
      expect(params.code.value, '012345');
      expect(params.credential, credential);
    },
  );

  blocTest<OtpCubit, OtpState>(
    'rejects a short code in the domain, without calling the use case',
    build: buildCubit,
    act: (OtpCubit cubit) => cubit.confirm('123'),
    expect: () => <Matcher>[isA<OtpFailed>()],
    verify: (_) => verifyNever(() => confirmPhoneOtp(any())),
  );

  blocTest<OtpCubit, OtpState>(
    'surfaces the server message when the code is rejected',
    build: () {
      when(() => confirmPhoneOtp(any())).thenAnswer(
        (_) async => const Left<Failure, OtpConfirmation>(
          ServerFailure(message: 'الرمز غير صالح أو منتهي الصلاحية'),
        ),
      );
      return buildCubit();
    },
    act: (OtpCubit cubit) => cubit.confirm('123456'),
    expect: () => const <OtpState>[
      OtpConfirming(),
      OtpFailed('الرمز غير صالح أو منتهي الصلاحية'),
    ],
  );

  blocTest<OtpCubit, OtpState>(
    'emits [Resending, Resent] — resend actually calls the backend now',
    build: () {
      when(() => resendPhoneOtp(any())).thenAnswer(
        (_) async => const Right<Failure, ResendOutcome>(
          ResendOutcome(message: 'تم إعادة إرسال رمز OTP بنجاح'),
        ),
      );
      return buildCubit();
    },
    act: (OtpCubit cubit) => cubit.resend(),
    expect: () => const <OtpState>[
      OtpResending(),
      OtpResent('تم إعادة إرسال رمز OTP بنجاح'),
    ],
    verify: (_) => verify(() => resendPhoneOtp(credential)).called(1),
  );

  blocTest<OtpCubit, OtpState>(
    'a failed resend does not look like a failed confirmation',
    build: () {
      when(() => resendPhoneOtp(any())).thenAnswer(
        (_) async => const Left<Failure, ResendOutcome>(NetworkFailure()),
      );
      return buildCubit();
    },
    act: (OtpCubit cubit) => cubit.resend(),
    expect: () => <Matcher>[isA<OtpResending>(), isA<OtpFailed>()],
  );
}
