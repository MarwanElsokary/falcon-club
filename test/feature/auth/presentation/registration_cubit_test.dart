import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/club_option.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_details.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_fields.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_outcome.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/register_club.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/register_scout.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/club_registration_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/registration_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/registration_state.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/scout_registration_cubit.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockRegisterClub extends Mock implements RegisterClub {}

class _MockRegisterScout extends Mock implements RegisterScout {}

void main() {
  late _MockRegisterClub registerClub;
  late _MockRegisterScout registerScout;

  const ClubOption club = ClubOption(id: 'club-guid', name: 'نادي الهلال');
  final RegistrationOutcome outcome = RegistrationOutcome(
    message: 'تم إنشاء الحساب بنجاح',
    // Authenticates the OTP step that follows. Not a session.
    credential: RegistrationCredential.issuedNow('registration-jwt'),
    emailSent: true,
  );

  RegistrationInput validInput({ClubOption? withClub, Gender? gender = Gender.male}) =>
      RegistrationInput(
        firstName: 'مروان',
        lastName: 'ياسر',
        email: 'mmaasnnas@gmail.com',
        phone: '500000005',
        password: 'Str0ng!Pass',
        gender: gender,
        club: withClub,
      );

  RegistrationFields someFields() => RegistrationFields.create(
    firstName: 'م',
    lastName: 'ي',
    email: 'a@b.com',
    phone: '500000005',
    password: 'Str0ng!Pass',
    gender: Gender.male,
  ).getRight().toNullable()!;

  setUpAll(() {
    registerFallbackValue(
      ClubRegistrationDetails(fields: someFields(), club: club),
    );
    registerFallbackValue(ScoutRegistrationDetails(fields: someFields()));
  });

  setUp(() {
    registerClub = _MockRegisterClub();
    registerScout = _MockRegisterScout();
  });

  group('ClubRegistrationCubit', () {
    blocTest<RegistrationCubit, RegistrationState>(
      'emits [InProgress, Succeeded] and passes the chosen club through',
      build: () {
        when(() => registerClub(any())).thenAnswer(
          (_) async => Right<Failure, RegistrationOutcome>(outcome),
        );
        return ClubRegistrationCubit(registerClub);
      },
      act: (RegistrationCubit cubit) =>
          cubit.submit(validInput(withClub: club)),
      expect: () => <RegistrationState>[
        RegistrationInProgress(),
        RegistrationSucceeded(outcome),
      ],
      verify: (_) {
        final ClubRegistrationDetails sent =
            verify(() => registerClub(captureAny())).captured.single
                as ClubRegistrationDetails;
        // B1: the club actually reaches the request.
        expect(sent.club, club);
      },
    );

    // The old code validated the club, blocked submission without it, and then
    // sent a body with no ClubId. Now no club means no request at all.
    blocTest<RegistrationCubit, RegistrationState>(
      'refuses to register without a club, and never calls the use case',
      build: () => ClubRegistrationCubit(registerClub),
      act: (RegistrationCubit cubit) => cubit.submit(validInput()),
      expect: () => <Matcher>[isA<RegistrationFailed>()],
      verify: (_) => verifyNever(() => registerClub(any())),
    );

    // B5: gender currently defaults to 0 (male) when unselected.
    blocTest<RegistrationCubit, RegistrationState>(
      'refuses an unselected gender instead of defaulting it to male',
      build: () => ClubRegistrationCubit(registerClub),
      act: (RegistrationCubit cubit) =>
          cubit.submit(validInput(withClub: club, gender: null)),
      expect: () => <Matcher>[isA<RegistrationFailed>()],
      verify: (_) => verifyNever(() => registerClub(any())),
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'surfaces a server failure',
      build: () {
        when(() => registerClub(any())).thenAnswer(
          (_) async => const Left<Failure, RegistrationOutcome>(
            ServerFailure(message: 'رقم الجوال مسجل بالفعل'),
          ),
        );
        return ClubRegistrationCubit(registerClub);
      },
      act: (RegistrationCubit cubit) =>
          cubit.submit(validInput(withClub: club)),
      expect: () => <RegistrationState>[
        RegistrationInProgress(),
        RegistrationFailed('رقم الجوال مسجل بالفعل'),
      ],
    );
  });

  group('ScoutRegistrationCubit', () {
    blocTest<RegistrationCubit, RegistrationState>(
      'registers with no club at all',
      build: () {
        when(() => registerScout(any())).thenAnswer(
          (_) async => Right<Failure, RegistrationOutcome>(outcome),
        );
        return ScoutRegistrationCubit(registerScout);
      },
      act: (RegistrationCubit cubit) => cubit.submit(validInput()),
      expect: () => <RegistrationState>[
        RegistrationInProgress(),
        RegistrationSucceeded(outcome),
      ],
    );

    blocTest<RegistrationCubit, RegistrationState>(
      'ignores a club even if one is supplied — scouts are club-less',
      build: () {
        when(() => registerScout(any())).thenAnswer(
          (_) async => Right<Failure, RegistrationOutcome>(outcome),
        );
        return ScoutRegistrationCubit(registerScout);
      },
      act: (RegistrationCubit cubit) =>
          cubit.submit(validInput(withClub: club)),
      expect: () => <RegistrationState>[
        RegistrationInProgress(),
        RegistrationSucceeded(outcome),
      ],
      verify: (_) {
        // ScoutRegistrationDetails has no club field — there is nowhere for it
        // to go, which is the point.
        expect(
          verify(() => registerScout(captureAny())).captured.single,
          isA<ScoutRegistrationDetails>(),
        );
      },
    );
  });

  // The outcome DOES carry a token — it has to, because the OTP endpoints
  // identify the account by nothing else. What makes registration safe is not
  // that the token is discarded, but that it is a RegistrationCredential rather
  // than an AuthSession, kept under a key readSession() never reads.
  //
  // That isolation is proven in pending_registration_isolation_test.dart; here
  // we only assert the credential is present and typed correctly.
  test('RegistrationOutcome carries a credential, not a session', () {
    expect(outcome.credential, isA<RegistrationCredential>());
    expect(outcome.credential.token, 'registration-jwt');
    expect(outcome.message, isNotEmpty);
  });
}
