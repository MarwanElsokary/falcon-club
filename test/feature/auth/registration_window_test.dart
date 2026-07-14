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
import 'package:falconclubapp/feature/auth/presentation/widgets/registration_window_countdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'credential_fixture.dart';

class _MockConfirmPhoneOtp extends Mock implements ConfirmPhoneOtp {}

class _MockResendPhoneOtp extends Mock implements ResendPhoneOtp {}

void main() {
  final Duration window = RegistrationCredential.registrationWindow;

  group('the deadline comes from issuedAt, NOT from the JWT', () {
    // THE regression test for the "23476350:12" countdown.
    //
    // The backend issues an effectively non-expiring JWT — its `exp` lands in
    // 2071. Reading the window from that claim produced a countdown of tens of
    // millions of minutes. The 15 minutes is a server-side rule the token does
    // not encode, so it must be measured from when we received the credential.
    test('a freshly issued credential has ~15 minutes left, not ~45 years', () {
      final RegistrationCredential credential =
          RegistrationCredential.issuedNow(longLivedToken());

      expect(credential.remainingValidity, lessThanOrEqualTo(window));
      expect(
        credential.remainingValidity.inMinutes,
        greaterThanOrEqualTo(14),
        reason: 'must be ~15 minutes, not decades',
      );
      expect(credential.isUsable, isTrue);
    });

    test('the far-future JWT exp does not leak into the deadline', () {
      final RegistrationCredential credential =
          RegistrationCredential.issuedNow(longLivedToken());

      // 2071 would be ~23 million minutes away.
      expect(credential.remainingValidity.inDays, 0);
      expect(credential.expiresAt.year, DateTime.now().toUtc().year);
    });

    test('the window closes exactly 15 minutes after issue', () {
      final DateTime issuedAt = DateTime.utc(2026, 7, 14, 12);
      final RegistrationCredential credential = RegistrationCredential(
        longLivedToken(),
        issuedAt: issuedAt,
      );

      expect(credential.expiresAt, DateTime.utc(2026, 7, 14, 12, 15));
    });

    test('a credential issued 16 minutes ago is dead', () {
      expect(credentialValidFor(-const Duration(minutes: 1)).isUsable, isFalse);
      expect(
        credentialValidFor(-const Duration(minutes: 1)).remainingValidity,
        Duration.zero,
      );
    });

    test('remainingValidity never goes negative', () {
      expect(
        credentialValidFor(-const Duration(hours: 3)).remainingValidity,
        Duration.zero,
      );
    });

    test('a blank token is unusable', () {
      expect(
        RegistrationCredential.issuedNow('').isUsable,
        isFalse,
      );
    });
  });

  // What the user actually SEES. No test asserted this before, which is exactly
  // why "23476350:12" shipped: every existing test checked booleans.
  group('the countdown display format', () {
    test('renders mm:ss', () {
      expect(
        RegistrationWindowCountdown.formatRemaining(
          const Duration(minutes: 14, seconds: 59),
        ),
        '14:59',
      );
      expect(
        RegistrationWindowCountdown.formatRemaining(
          const Duration(minutes: 15),
        ),
        '15:00',
      );
      expect(
        RegistrationWindowCountdown.formatRemaining(
          const Duration(minutes: 1, seconds: 5),
        ),
        '01:05',
      );
      expect(
        RegistrationWindowCountdown.formatRemaining(
          const Duration(seconds: 9),
        ),
        '00:09',
      );
      expect(
        RegistrationWindowCountdown.formatRemaining(Duration.zero),
        '00:00',
      );
    });

    test('a freshly issued credential displays ~15 minutes', () {
      final RegistrationCredential credential =
          RegistrationCredential.issuedNow(longLivedToken());

      final String shown = RegistrationWindowCountdown.formatRemaining(
        credential.remainingValidity,
      );

      // "14:59" or "15:00" depending on the microsecond it was stamped.
      expect(shown, matches(RegExp(r'^1[45]:\d{2}$')));
    });

    // The guard. Even if a future bug produced an absurd duration, the user must
    // never again see tens of millions of minutes.
    test('clamps an absurd duration instead of rendering garbage', () {
      expect(
        RegistrationWindowCountdown.formatRemaining(
          const Duration(days: 16000), // the old 2071-derived value
        ),
        '15:00',
      );
    });

    test('never renders a negative duration', () {
      expect(
        RegistrationWindowCountdown.formatRemaining(
          -const Duration(minutes: 5),
        ),
        '00:00',
      );
    });

    // The seconds field is modulo 60 — it can never be the huge number. The bug
    // was always in the minutes field, i.e. in the duration itself.
    test('the seconds field is always two digits', () {
      for (final Duration duration in <Duration>[
        const Duration(minutes: 14, seconds: 59),
        const Duration(minutes: 7, seconds: 3),
        const Duration(seconds: 1),
      ]) {
        final String shown = RegistrationWindowCountdown.formatRemaining(
          duration,
        );
        expect(shown.split(':').last.length, 2);
        expect(shown.split(':').first.length, 2);
      }
    });
  });

  group('OtpCubit refuses to act on a closed window', () {
    late _MockConfirmPhoneOtp confirmPhoneOtp;
    late _MockResendPhoneOtp resendPhoneOtp;

    final RegistrationCredential expired = credentialValidFor(
      -const Duration(minutes: 1),
    );
    final RegistrationCredential live = credentialValidFor(window);

    setUpAll(() {
      registerFallbackValue(
        ConfirmPhoneOtpParams(
          code: OtpCode.create('123456').getRight().toNullable()!,
          credential: live,
        ),
      );
      registerFallbackValue(live);
    });

    setUp(() {
      confirmPhoneOtp = _MockConfirmPhoneOtp();
      resendPhoneOtp = _MockResendPhoneOtp();
    });

    // Firing the request anyway would surface "invalid code" — which is wrong
    // and actively misleading. The code is fine; the window is shut.
    blocTest<OtpCubit, OtpState>(
      'confirming with an expired credential does NOT call the backend',
      build: () => OtpCubit(confirmPhoneOtp, resendPhoneOtp, expired),
      act: (OtpCubit cubit) => cubit.confirm('123456'),
      expect: () => const <OtpState>[OtpCredentialExpired()],
      verify: (_) => verifyNever(() => confirmPhoneOtp(any())),
    );

    // Resending does not extend the window — the new code is validated against
    // the same dead credential.
    blocTest<OtpCubit, OtpState>(
      'resending with an expired credential does NOT call the backend',
      build: () => OtpCubit(confirmPhoneOtp, resendPhoneOtp, expired),
      act: (OtpCubit cubit) => cubit.resend(),
      expect: () => const <OtpState>[OtpCredentialExpired()],
      verify: (_) => verifyNever(() => resendPhoneOtp(any())),
    );

    blocTest<OtpCubit, OtpState>(
      'the countdown can expire the session explicitly',
      build: () => OtpCubit(confirmPhoneOtp, resendPhoneOtp, live),
      act: (OtpCubit cubit) => cubit.expire(),
      expect: () => const <OtpState>[OtpCredentialExpired()],
    );

    blocTest<OtpCubit, OtpState>(
      'a live credential still confirms normally',
      build: () {
        when(() => confirmPhoneOtp(any())).thenAnswer(
          (_) async => const Right<Failure, OtpConfirmation>(
            OtpConfirmation(message: 'ok'),
          ),
        );
        return OtpCubit(confirmPhoneOtp, resendPhoneOtp, live);
      },
      act: (OtpCubit cubit) => cubit.confirm('123456'),
      expect: () => const <OtpState>[
        OtpConfirming(),
        OtpConfirmed(OtpConfirmation(message: 'ok')),
      ],
    );

    blocTest<OtpCubit, OtpState>(
      'a live credential still resends normally',
      build: () {
        when(() => resendPhoneOtp(any())).thenAnswer(
          (_) async => const Right<Failure, ResendOutcome>(
            ResendOutcome(message: 'sent'),
          ),
        );
        return OtpCubit(confirmPhoneOtp, resendPhoneOtp, live);
      },
      act: (OtpCubit cubit) => cubit.resend(),
      expect: () => const <OtpState>[OtpResending(), OtpResent('sent')],
    );
  });

  group('the login screen retry link', () {
    test('is offered while the window is open', () {
      expect(credentialValidFor(const Duration(minutes: 5)).isUsable, isTrue);
    });

    test('is withheld once the window has closed', () {
      expect(credentialValidFor(-const Duration(seconds: 1)).isUsable, isFalse);
    });
  });
}
