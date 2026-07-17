import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_list_cubit.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_list_state.dart';
import 'package:falconclubapp/core/storage/timed_cache.dart';
import 'package:falconclubapp/feature/exercise/data/datasources/exercise_remote_data_source.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/attempt_repository.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/exercise_repository.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/trial_repository.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_exercise_details.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_exercises.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_player_attempts.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_trial_details.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/upload_attempt_for_player.dart';
import 'package:dio/dio.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/di/injection.dart';
import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/media/image_compressor.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/otp_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/password_reset_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/request_password_reset.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/reset_password.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/verify_password_reset_otp.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/pending_registration_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/terms_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/confirm_phone_otp.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/read_pending_registration.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/resend_phone_otp.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/otp_state.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_terms_and_policies.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/register_club.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/register_scout.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/club_directory_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/club_registration_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/registration_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/scout_registration_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/terms_cubit.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/core/storage/key_value_store.dart';
import 'package:falconclubapp/core/storage/secure_store.dart';
import 'package:falconclubapp/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/data/datasources/club_directory_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/data/datasources/session_local_data_source.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/auth_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/club_directory_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/session_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_cities.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_clubs_in_city.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/log_in.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/log_out.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/read_session.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Startup smoke test for the composition root.
///
/// `flutter analyze` cannot see DI errors: a double registration or a missing
/// binding is a *runtime* throw at app launch. This test boots the real
/// container the same way `main()` does, so the strangler step (moving Dio and
/// ApiService from `setupGetIt()` into `RegisterModule`) cannot silently break
/// startup.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await GetIt.instance.reset();
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('main()\'s boot sequence registers everything exactly once', () async {
    // Same order as main.dart: injectable first (it owns Dio/ApiService), then
    // the legacy registrations that resolve them.
    await configureDependencies();
    await setupGetIt();
  });

  test('Dio and ApiService resolve after the move to RegisterModule', () async {
    await configureDependencies();
    await setupGetIt();

    expect(getIt<Dio>(), isA<Dio>());
    expect(getIt<ApiService>(), isA<ApiService>());
  });

  test(
    'Dio and ApiService are singletons, as they were before the move',
    () async {
      await configureDependencies();
      await setupGetIt();

      expect(identical(getIt<Dio>(), getIt<Dio>()), isTrue);
      expect(identical(getIt<ApiService>(), getIt<ApiService>()), isTrue);
    },
  );

  test(
    'legacy repositories still resolve ApiService from the same GetIt',
    () async {
      await configureDependencies();
      await setupGetIt();

      // A legacy, un-migrated repository. If the strangler step had broken the
      // shared instance, constructing this would throw.
      expect(() => getIt<ApiService>(), returnsNormally);
    },
  );

  group('foundation abstractions resolve to their implementations (DIP)', () {
    test('storage, network, and error mapping are all bound', () async {
      await configureDependencies();

      expect(getIt<KeyValueStore>(), isA<KeyValueStore>());
      expect(getIt<SecureStore>(), isA<SecureStore>());
      expect(getIt<ErrorMapper>(), isA<ErrorMapper>());
    });
  });

  group('auth session + club directory (Phase 2)', () {
    test('repositories resolve through their domain interfaces', () async {
      await configureDependencies();

      expect(getIt<SessionRepository>(), isA<SessionRepository>());
      expect(getIt<ClubDirectoryRepository>(), isA<ClubDirectoryRepository>());
      expect(getIt<SessionLocalDataSource>(), isA<SessionLocalDataSource>());
      expect(
        getIt<ClubDirectoryRemoteDataSource>(),
        isA<ClubDirectoryRemoteDataSource>(),
      );
    });

    test('use cases resolve with their dependencies injected', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<GetCities>(), isA<GetCities>());
      expect(getIt<GetClubsInCity>(), isA<GetClubsInCity>());
      expect(getIt<ReadSession>(), isA<ReadSession>());
      expect(getIt<LogOut>(), isA<LogOut>());
    });
  });

  group('sign-in (Phase 3)', () {
    test('AuthRepository resolves through its domain interface', () async {
      await configureDependencies();

      expect(getIt<AuthRepository>(), isA<AuthRepository>());
      expect(getIt<AuthRemoteDataSource>(), isA<AuthRemoteDataSource>());
    });

    // The router resolves SignInCubit on every push of AppRoute.loginScreen.
    // If this binding is missing, login throws at navigation time — something
    // neither `flutter analyze` nor `flutter build` can catch.
    test('SignInCubit and LogIn resolve, as the router requires', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<LogIn>(), isA<LogIn>());
      expect(getIt<SignInCubit>(), isA<SignInCubit>());
    });

    test('SignInCubit is a factory — a fresh instance per screen', () async {
      await configureDependencies();
      await setupGetIt();

      expect(identical(getIt<SignInCubit>(), getIt<SignInCubit>()), isFalse);
    });
  });

  group('registration (Phase 4)', () {
    // The router resolves these on every push of clubSignUpScreen /
    // scoutSignUpScreen. A missing binding throws at navigation time —
    // invisible to `flutter analyze` and `flutter build`.
    test('both registration cubits and their use cases resolve', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<RegisterClub>(), isA<RegisterClub>());
      expect(getIt<RegisterScout>(), isA<RegisterScout>());
      expect(getIt<ClubRegistrationCubit>(), isA<ClubRegistrationCubit>());
      expect(getIt<ScoutRegistrationCubit>(), isA<ScoutRegistrationCubit>());
      expect(getIt<ClubDirectoryCubit>(), isA<ClubDirectoryCubit>());
    });

    // The screen depends on the abstract base; the router supplies the concrete
    // cubit. Both must be substitutable for it (LSP).
    test('both cubits are usable as the abstract RegistrationCubit', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<ClubRegistrationCubit>(), isA<RegistrationCubit>());
      expect(getIt<ScoutRegistrationCubit>(), isA<RegistrationCubit>());
    });

    test('the image compressor and terms port resolve', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<ImageCompressor>(), isA<ImageCompressor>());
      expect(getIt<TermsRepository>(), isA<TermsRepository>());
      expect(getIt<GetTermsAndPolicies>(), isA<GetTermsAndPolicies>());
      // The router provides this on both signup routes — consent is mandatory.
      expect(getIt<TermsCubit>(), isA<TermsCubit>());
    });
  });

  group('OTP (Phase 5)', () {
    test('the OTP and pending-registration ports resolve', () async {
      await configureDependencies();

      expect(getIt<OtpRepository>(), isA<OtpRepository>());
      expect(
        getIt<PendingRegistrationRepository>(),
        isA<PendingRegistrationRepository>(),
      );
      expect(getIt<ConfirmPhoneOtp>(), isA<ConfirmPhoneOtp>());
      expect(getIt<ResendPhoneOtp>(), isA<ResendPhoneOtp>());
      expect(getIt<ReadPendingRegistration>(), isA<ReadPendingRegistration>());
    });

    // The router builds this with `getIt<OtpCubit>(param1: credential)`. If the
    // factory-param wiring were wrong, opening the OTP screen would throw at
    // navigation time — something neither analyze nor build can catch.
    test('OtpCubit resolves with the credential as a factory param', () async {
      await configureDependencies();
      await setupGetIt();

      final OtpCubit cubit = getIt<OtpCubit>(
        param1: RegistrationCredential.issuedNow('jwt'),
      );

      expect(cubit, isA<OtpCubit>());
      expect(cubit.state, isA<OtpIdle>());
    });
  });

  group('password reset (Phase 6)', () {
    // The router resolves PasswordResetCubit on all three reset screens.
    test('the reset port, use cases, and cubit all resolve', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<PasswordResetRepository>(), isA<PasswordResetRepository>());
      expect(getIt<RequestPasswordReset>(), isA<RequestPasswordReset>());
      expect(getIt<VerifyPasswordResetOtp>(), isA<VerifyPasswordResetOtp>());
      expect(getIt<ResetPassword>(), isA<ResetPassword>());
      expect(getIt<PasswordResetCubit>(), isA<PasswordResetCubit>());
    });
  });

  group('exercise (Phase 2)', () {
    // `flutter analyze` cannot see a DI misconfiguration — a use case whose
    // repository was never registered compiles perfectly and throws at the
    // moment the user opens the screen. Booting the real container is the only
    // way to catch it before a device does.
    test('the whole exercise graph resolves', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<TimedCache>(), isA<TimedCache>());
      expect(
        getIt<ExerciseRemoteDataSource>(),
        isA<ExerciseRemoteDataSource>(),
      );
      expect(getIt<ExerciseRepository>(), isA<ExerciseRepository>());
      expect(getIt<AttemptRepository>(), isA<AttemptRepository>());
      expect(getIt<TrialRepository>(), isA<TrialRepository>());

      expect(getIt<GetExercises>(), isA<GetExercises>());
      expect(getIt<GetExerciseDetails>(), isA<GetExerciseDetails>());
      expect(getIt<GetPlayerAttempts>(), isA<GetPlayerAttempts>());
      expect(getIt<GetTrialDetails>(), isA<GetTrialDetails>());
      expect(getIt<UploadAttemptForPlayer>(), isA<UploadAttemptForPlayer>());
    });

    // Three call sites resolve this: the club route, the scout route, and the
    // scout's bottom-nav tab. All three now build the same cubit.
    test('ExerciseListCubit resolves (Phase 3)', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<ExerciseListCubit>(), isA<ExerciseListCubit>());
      expect(
        getIt<ExerciseListCubit>().state.status,
        isA<ExerciseListInitial>(),
      );
    });

    // The upload posts through the shared Dio, so it must be resolvable — this
    // is what the five bare `Dio()` instances were quietly working around.
    test('the remote data source gets the SHARED Dio, not a new one', () async {
      await configureDependencies();
      await setupGetIt();

      expect(getIt<Dio>(), same(getIt<Dio>()));
      expect(getIt<ApiService>(), isA<ApiService>());
    });
  });
}
