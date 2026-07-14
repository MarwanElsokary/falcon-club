import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/auth_session.dart';
import 'package:falconclubapp/feature/auth/domain/entities/login_credentials.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/log_in.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/read_pending_registration.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/sign_in_state.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../credential_fixture.dart';

class _MockLogIn extends Mock implements LogIn {}

class _MockReadPendingRegistration extends Mock
    implements ReadPendingRegistration {}

void main() {
  late _MockLogIn logIn;
  late _MockReadPendingRegistration readPendingRegistration;

  const AuthSession session = AuthSession(
    token: 'jwt',
    userId: 'guid',
    role: UserRole.mainClub,
  );

  // LoginCredentials is `final` and cannot be faked — register a real one.
  setUpAll(
    () => registerFallbackValue(
      LoginCredentials(
        phone: PhoneNumber.permissive('500000005').getRight().toNullable()!,
        password: Password.trusted('secret'),
      ),
    ),
  );

  setUp(() {
    logIn = _MockLogIn();
    readPendingRegistration = _MockReadPendingRegistration();
    // Default: nothing pending. Individual tests override.
    when(() => readPendingRegistration()).thenAnswer(
      (_) async => const Right<Failure, RegistrationCredential?>(null),
    );
  });

  SignInCubit buildCubit() => SignInCubit(logIn, readPendingRegistration);

  group('signing in', () {
    blocTest<SignInCubit, SignInState>(
      'emits [InProgress, Succeeded] and carries the session for routing',
      build: () {
        when(() => logIn(any())).thenAnswer(
          (_) async => const Right<Failure, AuthSession>(session),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) =>
          cubit.signIn(phone: '500000005', password: 'secret'),
      expect: () => const <SignInState>[
        SignInState(attempt: SignInInProgress()),
        SignInState(attempt: SignInSucceeded(session)),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [InProgress, Failed] with the server message on refusal',
      build: () {
        when(() => logIn(any())).thenAnswer(
          (_) async => const Left<Failure, AuthSession>(
            ValidationFailure(message: 'لم يتم تأكيد رقم الجوال بعد.'),
          ),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) =>
          cubit.signIn(phone: '500000005', password: 'secret'),
      expect: () => const <SignInState>[
        SignInState(attempt: SignInInProgress()),
        SignInState(attempt: SignInFailed('لم يتم تأكيد رقم الجوال بعد.')),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'rejects a blank phone in the domain, without calling the use case',
      build: buildCubit,
      act: (SignInCubit cubit) => cubit.signIn(phone: '  ', password: 'secret'),
      expect: () => <Matcher>[
        isA<SignInState>().having(
          (SignInState state) => state.attempt,
          'attempt',
          isA<SignInFailed>(),
        ),
      ],
      verify: (_) => verifyNever(() => logIn(any())),
    );

    blocTest<SignInCubit, SignInState>(
      'rejects a blank password without calling the use case',
      build: buildCubit,
      act: (SignInCubit cubit) => cubit.signIn(phone: '500000005', password: ''),
      expect: () => <Matcher>[
        isA<SignInState>().having(
          (SignInState state) => state.attempt,
          'attempt',
          isA<SignInFailed>(),
        ),
      ],
      verify: (_) => verifyNever(() => logIn(any())),
    );

    // A password that predates the signup strength rules must still be accepted
    // for sign-in — the server decides whether it is correct, not the client.
    blocTest<SignInCubit, SignInState>(
      'does not apply signup password rules to an existing account',
      build: () {
        when(() => logIn(any())).thenAnswer(
          (_) async => const Right<Failure, AuthSession>(session),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) =>
          cubit.signIn(phone: '500000005', password: 'weak'),
      expect: () => const <SignInState>[
        SignInState(attempt: SignInInProgress()),
        SignInState(attempt: SignInSucceeded(session)),
      ],
      verify: (_) => verify(() => logIn(any())).called(1),
    );
  });

  // Moved out of the widget: the screen used to call
  // getIt<ReadPendingRegistration>() directly, putting a service locator in the
  // UI layer — the very violation this refactor set out to remove.
  group('the pending-registration lookup', () {
    blocTest<SignInCubit, SignInState>(
      'offers the retry link when an unexpired registration exists',
      build: () {
        when(() => readPendingRegistration()).thenAnswer(
          (_) async => Right<Failure, RegistrationCredential?>(
            credentialValidFor(const Duration(minutes: 10)),
          ),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) => cubit.loadPendingRegistration(),
      verify: (SignInCubit cubit) {
        expect(cubit.state.canConfirmPhone, isTrue);
        expect(cubit.state.pendingRegistration, isNotNull);
      },
    );

    // The backend cannot re-issue the registration token, so a link built on a
    // dead credential would only produce a 401.
    blocTest<SignInCubit, SignInState>(
      'withholds the link when the 15-minute window has closed',
      build: () {
        when(() => readPendingRegistration()).thenAnswer(
          (_) async => Right<Failure, RegistrationCredential?>(
            credentialValidFor(-const Duration(minutes: 1)),
          ),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) => cubit.loadPendingRegistration(),
      verify: (SignInCubit cubit) =>
          expect(cubit.state.canConfirmPhone, isFalse),
    );

    blocTest<SignInCubit, SignInState>(
      'withholds the link when there is no pending registration',
      build: buildCubit,
      act: (SignInCubit cubit) => cubit.loadPendingRegistration(),
      verify: (SignInCubit cubit) =>
          expect(cubit.state.canConfirmPhone, isFalse),
    );

    // A storage failure must never block signing in.
    blocTest<SignInCubit, SignInState>(
      'a storage failure simply means no link — login still works',
      build: () {
        when(() => readPendingRegistration()).thenAnswer(
          (_) async =>
              const Left<Failure, RegistrationCredential?>(CacheFailure()),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) => cubit.loadPendingRegistration(),
      verify: (SignInCubit cubit) {
        expect(cubit.state.canConfirmPhone, isFalse);
        expect(cubit.state.attempt, isA<SignInIdle>());
      },
    );

    // The link must survive a failed sign-in — that is exactly when the user
    // needs it (login refuses an unconfirmed phone).
    blocTest<SignInCubit, SignInState>(
      'the retry link survives a failed sign-in attempt',
      build: () {
        when(() => readPendingRegistration()).thenAnswer(
          (_) async => Right<Failure, RegistrationCredential?>(
            credentialValidFor(const Duration(minutes: 10)),
          ),
        );
        when(() => logIn(any())).thenAnswer(
          (_) async => const Left<Failure, AuthSession>(
            ServerFailure(message: 'لم يتم تأكيد رقم الجوال بعد.'),
          ),
        );
        return buildCubit();
      },
      act: (SignInCubit cubit) async {
        await cubit.loadPendingRegistration();
        await cubit.signIn(phone: '500000005', password: 'secret');
      },
      verify: (SignInCubit cubit) {
        expect(cubit.state.attempt, isA<SignInFailed>());
        expect(cubit.state.canConfirmPhone, isTrue);
      },
    );
  });
}
