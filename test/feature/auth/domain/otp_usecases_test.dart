import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/otp_confirmation.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:falconclubapp/feature/auth/domain/entities/resend_outcome.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/otp_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/pending_registration_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/confirm_phone_otp.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/resend_phone_otp.dart';
import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockOtpRepository extends Mock implements OtpRepository {}

class _MockPendingRegistrationRepository extends Mock
    implements PendingRegistrationRepository {}

void main() {
  late _MockOtpRepository otpRepository;
  late _MockPendingRegistrationRepository pendingRegistration;

  final RegistrationCredential credential = RegistrationCredential.issuedNow(
    'jwt',
  );
  const OtpConfirmation confirmation = OtpConfirmation(
    message: 'تم إرسال طلب انضمامك للتطبيق بنجاح',
  );

  final OtpCode code = OtpCode.create('012345').getRight().toNullable()!;

  setUpAll(() {
    registerFallbackValue(credential);
    registerFallbackValue(code);
  });

  setUp(() {
    otpRepository = _MockOtpRepository();
    pendingRegistration = _MockPendingRegistrationRepository();
    when(() => pendingRegistration.clear())
        .thenAnswer((_) async => const Right<Failure, void>(null));
  });

  group('ConfirmPhoneOtp', () {
    ConfirmPhoneOtp buildUseCase() =>
        ConfirmPhoneOtp(otpRepository, pendingRegistration);

    void stubConfirm(Either<Failure, OtpConfirmation> result) {
      when(
        () => otpRepository.confirmPhone(
          code: any(named: 'code'),
          credential: any(named: 'credential'),
        ),
      ).thenAnswer((_) async => result);
    }

    test('confirms and then discards the credential', () async {
      stubConfirm(const Right<Failure, OtpConfirmation>(confirmation));

      final result = await buildUseCase()(
        ConfirmPhoneOtpParams(code: code, credential: credential),
      );

      expect(result.getRight().toNullable(), confirmation);
      // The credential existed for exactly one purpose, and it is served.
      verify(() => pendingRegistration.clear()).called(1);
    });

    // If a user fat-fingers the code, they must be able to try again — clearing
    // the credential here would strand them with an unconfirmable account and no
    // way to get another token.
    test('keeps the credential when the code is rejected', () async {
      stubConfirm(
        const Left<Failure, OtpConfirmation>(
          ServerFailure(message: 'الرمز غير صالح أو منتهي الصلاحية'),
        ),
      );

      final result = await buildUseCase()(
        ConfirmPhoneOtpParams(code: code, credential: credential),
      );

      expect(
        result.getLeft().toNullable()?.message,
        'الرمز غير صالح أو منتهي الصلاحية',
      );
      verifyNever(() => pendingRegistration.clear());
    });

    test('passes the credential through to the repository', () async {
      stubConfirm(const Right<Failure, OtpConfirmation>(confirmation));

      await buildUseCase()(
        ConfirmPhoneOtpParams(code: code, credential: credential),
      );

      verify(
        () => otpRepository.confirmPhone(code: code, credential: credential),
      ).called(1);
    });
  });

  group('ResendPhoneOtp', () {
    test('asks the backend for a new code', () async {
      const ResendOutcome outcome = ResendOutcome(
        message: 'تم إعادة إرسال رمز OTP بنجاح',
        emailSent: true,
      );
      when(() => otpRepository.resendOtp(any()))
          .thenAnswer((_) async => const Right<Failure, ResendOutcome>(outcome));

      final result = await ResendPhoneOtp(otpRepository)(credential);

      expect(result.getRight().toNullable(), outcome);
      verify(() => otpRepository.resendOtp(credential)).called(1);
    });

    test('surfaces a failure', () async {
      when(() => otpRepository.resendOtp(any())).thenAnswer(
        (_) async => const Left<Failure, ResendOutcome>(NetworkFailure()),
      );

      final result = await ResendPhoneOtp(otpRepository)(credential);

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });
}
