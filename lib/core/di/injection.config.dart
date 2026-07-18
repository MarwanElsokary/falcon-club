// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../feature/auth/data/datasources/auth_remote_data_source.dart'
    as _i794;
import '../../feature/auth/data/datasources/club_directory_remote_data_source.dart'
    as _i990;
import '../../feature/auth/data/datasources/otp_remote_data_source.dart'
    as _i36;
import '../../feature/auth/data/datasources/password_reset_remote_data_source.dart'
    as _i545;
import '../../feature/auth/data/datasources/pending_registration_local_data_source.dart'
    as _i343;
import '../../feature/auth/data/datasources/session_local_data_source.dart'
    as _i601;
import '../../feature/auth/data/datasources/terms_remote_data_source.dart'
    as _i891;
import '../../feature/auth/data/models/registration_request_builder.dart'
    as _i1059;
import '../../feature/auth/data/repositories/auth_repository_impl.dart'
    as _i263;
import '../../feature/auth/data/repositories/club_directory_repository_impl.dart'
    as _i940;
import '../../feature/auth/data/repositories/otp_repository_impl.dart' as _i462;
import '../../feature/auth/data/repositories/password_reset_repository_impl.dart'
    as _i373;
import '../../feature/auth/data/repositories/pending_registration_repository_impl.dart'
    as _i168;
import '../../feature/auth/data/repositories/session_repository_impl.dart'
    as _i457;
import '../../feature/auth/data/repositories/terms_repository_impl.dart'
    as _i433;
import '../../feature/auth/domain/entities/registration_credential.dart'
    as _i508;
import '../../feature/auth/domain/repositories/auth_repository.dart' as _i488;
import '../../feature/auth/domain/repositories/club_directory_repository.dart'
    as _i841;
import '../../feature/auth/domain/repositories/otp_repository.dart' as _i317;
import '../../feature/auth/domain/repositories/password_reset_repository.dart'
    as _i897;
import '../../feature/auth/domain/repositories/pending_registration_repository.dart'
    as _i858;
import '../../feature/auth/domain/repositories/session_repository.dart'
    as _i700;
import '../../feature/auth/domain/repositories/terms_repository.dart' as _i506;
import '../../feature/auth/domain/usecases/confirm_phone_otp.dart' as _i461;
import '../../feature/auth/domain/usecases/describe_session.dart' as _i136;
import '../../feature/auth/domain/usecases/get_cities.dart' as _i1030;
import '../../feature/auth/domain/usecases/get_clubs_in_city.dart' as _i859;
import '../../feature/auth/domain/usecases/get_terms_and_policies.dart'
    as _i910;
import '../../feature/auth/domain/usecases/log_in.dart' as _i330;
import '../../feature/auth/domain/usecases/log_out.dart' as _i825;
import '../../feature/auth/domain/usecases/read_pending_registration.dart'
    as _i702;
import '../../feature/auth/domain/usecases/read_session.dart' as _i349;
import '../../feature/auth/domain/usecases/register_club.dart' as _i852;
import '../../feature/auth/domain/usecases/register_scout.dart' as _i141;
import '../../feature/auth/domain/usecases/request_password_reset.dart'
    as _i938;
import '../../feature/auth/domain/usecases/resend_phone_otp.dart' as _i420;
import '../../feature/auth/domain/usecases/reset_password.dart' as _i70;
import '../../feature/auth/domain/usecases/verify_password_reset_otp.dart'
    as _i521;
import '../../feature/auth/presentation/cubit/club_directory_cubit.dart'
    as _i741;
import '../../feature/auth/presentation/cubit/club_registration_cubit.dart'
    as _i398;
import '../../feature/auth/presentation/cubit/otp_cubit.dart' as _i840;
import '../../feature/auth/presentation/cubit/password_reset_cubit.dart'
    as _i714;
import '../../feature/auth/presentation/cubit/scout_registration_cubit.dart'
    as _i731;
import '../../feature/auth/presentation/cubit/sign_in_cubit.dart' as _i770;
import '../../feature/auth/presentation/cubit/terms_cubit.dart' as _i608;
import '../../feature/exercise/data/datasources/cached_viewer_capability.dart'
    as _i37;
import '../../feature/exercise/data/datasources/exercise_remote_data_source.dart'
    as _i958;
import '../../feature/exercise/data/repositories/attempt_repository_impl.dart'
    as _i1037;
import '../../feature/exercise/data/repositories/exercise_repository_impl.dart'
    as _i745;
import '../../feature/exercise/data/repositories/trial_repository_impl.dart'
    as _i533;
import '../../feature/exercise/domain/repositories/attempt_repository.dart'
    as _i314;
import '../../feature/exercise/domain/repositories/exercise_repository.dart'
    as _i1032;
import '../../feature/exercise/domain/repositories/trial_repository.dart'
    as _i787;
import '../../feature/exercise/domain/repositories/viewer_capability_port.dart'
    as _i826;
import '../../feature/exercise/domain/usecases/get_exercise_details.dart'
    as _i616;
import '../../feature/exercise/domain/usecases/get_exercises.dart' as _i876;
import '../../feature/exercise/domain/usecases/get_player_attempts.dart'
    as _i396;
import '../../feature/exercise/domain/usecases/get_trial_details.dart' as _i836;
import '../../feature/exercise/domain/usecases/upload_attempt_for_player.dart'
    as _i544;
import '../../feature/exercise/presentation/cubit/attempt_upload_cubit.dart'
    as _i491;
import '../../feature/exercise/presentation/cubit/exercise_details_cubit.dart'
    as _i527;
import '../../feature/exercise/presentation/cubit/exercise_list_cubit.dart'
    as _i973;
import '../../feature/player_attempts/cubit/player_attempts_cubit.dart' as _i72;
import '../../feature/profile/data/datasources/profile_remote_data_source.dart'
    as _i256;
import '../../feature/profile/data/repositories/profile_repository_impl.dart'
    as _i1035;
import '../../feature/profile/domain/repositories/profile_repository.dart'
    as _i173;
import '../../feature/profile/domain/usecases/get_my_profile.dart' as _i352;
import '../../feature/profile/domain/usecases/get_player_profile.dart' as _i513;
import '../../feature/profile/domain/usecases/update_my_profile.dart' as _i567;
import '../../feature/profile/presentation/cubit/profile_cubit.dart' as _i499;
import '../../feature/profile/presentation/cubit/profile_edit_cubit.dart'
    as _i394;
import '../../feature/trial_details/cubit/trial_details_cubit.dart' as _i896;
import '../../shared/data/cached_subscription_reader.dart' as _i287;
import '../../shared/domain/subscription_reader.dart' as _i876;
import '../error/error_mapper.dart' as _i449;
import '../media/image_compressor.dart' as _i525;
import '../networking/api_service.dart' as _i700;
import '../storage/key_value_store.dart' as _i892;
import '../storage/secure_storage_store.dart' as _i314;
import '../storage/secure_store.dart' as _i271;
import '../storage/shared_prefs_store.dart' as _i204;
import '../storage/timed_cache.dart' as _i484;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i449.ErrorMapper>(() => const _i449.ErrorMapper());
    gh.lazySingleton<_i525.ImageCompressor>(
      () => const _i525.FlutterImageCompressor(),
    );
    gh.lazySingleton<_i700.ApiService>(
      () => registerModule.apiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i545.PasswordResetRemoteDataSource>(
      () => _i545.RetrofitPasswordResetRemoteDataSource(gh<_i700.ApiService>()),
    );
    gh.lazySingleton<_i271.SecureStore>(
      () => _i314.SecureStorageStore(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i892.KeyValueStore>(
      () => _i204.SharedPrefsStore(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i601.SessionLocalDataSource>(
      () => _i601.StoredSessionLocalDataSource(
        gh<_i271.SecureStore>(),
        gh<_i892.KeyValueStore>(),
      ),
    );
    gh.lazySingleton<_i897.PasswordResetRepository>(
      () => _i373.PasswordResetRepositoryImpl(
        gh<_i545.PasswordResetRemoteDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i256.ProfileRemoteDataSource>(
      () => _i256.RetrofitProfileRemoteDataSource(gh<_i700.ApiService>()),
    );
    gh.lazySingleton<_i891.TermsRemoteDataSource>(
      () => _i891.RetrofitTermsRemoteDataSource(gh<_i700.ApiService>()),
    );
    gh.lazySingleton<_i700.SessionRepository>(
      () => _i457.SessionRepositoryImpl(
        gh<_i601.SessionLocalDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i1059.RegistrationRequestBuilder>(
      () => _i1059.RegistrationRequestBuilder(gh<_i525.ImageCompressor>()),
    );
    gh.lazySingleton<_i36.OtpRemoteDataSource>(
      () => _i36.RetrofitOtpRemoteDataSource(gh<_i700.ApiService>()),
    );
    gh.lazySingleton<_i990.ClubDirectoryRemoteDataSource>(
      () => _i990.RetrofitClubDirectoryRemoteDataSource(gh<_i700.ApiService>()),
    );
    gh.lazySingleton<_i317.OtpRepository>(
      () => _i462.OtpRepositoryImpl(
        gh<_i36.OtpRemoteDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i958.ExerciseRemoteDataSource>(
      () => _i958.RetrofitExerciseRemoteDataSource(
        gh<_i700.ApiService>(),
        gh<_i361.Dio>(),
      ),
    );
    gh.lazySingleton<_i484.TimedCache>(
      () => _i484.TimedCache(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i343.PendingRegistrationLocalDataSource>(
      () => _i343.SecurePendingRegistrationLocalDataSource(
        gh<_i271.SecureStore>(),
      ),
    );
    gh.lazySingleton<_i173.ProfileRepository>(
      () => _i1035.ProfileRepositoryImpl(
        gh<_i256.ProfileRemoteDataSource>(),
        gh<_i892.KeyValueStore>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i876.SubscriptionReader>(
      () => _i287.CachedSubscriptionReader(gh<_i892.KeyValueStore>()),
    );
    gh.lazySingleton<_i858.PendingRegistrationRepository>(
      () => _i168.PendingRegistrationRepositoryImpl(
        gh<_i343.PendingRegistrationLocalDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i794.AuthRemoteDataSource>(
      () => _i794.RetrofitAuthRemoteDataSource(
        gh<_i700.ApiService>(),
        gh<_i1059.RegistrationRequestBuilder>(),
      ),
    );
    gh.factory<_i352.GetMyProfile>(
      () => _i352.GetMyProfile(gh<_i173.ProfileRepository>()),
    );
    gh.factory<_i513.GetPlayerProfile>(
      () => _i513.GetPlayerProfile(gh<_i173.ProfileRepository>()),
    );
    gh.factory<_i567.UpdateMyProfile>(
      () => _i567.UpdateMyProfile(gh<_i173.ProfileRepository>()),
    );
    gh.lazySingleton<_i506.TermsRepository>(
      () => _i433.TermsRepositoryImpl(
        gh<_i891.TermsRemoteDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i314.AttemptRepository>(
      () => _i1037.AttemptRepositoryImpl(
        gh<_i958.ExerciseRemoteDataSource>(),
        gh<_i484.TimedCache>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.lazySingleton<_i787.TrialRepository>(
      () => _i533.TrialRepositoryImpl(
        gh<_i958.ExerciseRemoteDataSource>(),
        gh<_i484.TimedCache>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.factory<_i461.ConfirmPhoneOtp>(
      () => _i461.ConfirmPhoneOtp(
        gh<_i317.OtpRepository>(),
        gh<_i858.PendingRegistrationRepository>(),
      ),
    );
    gh.lazySingleton<_i1032.ExerciseRepository>(
      () => _i745.ExerciseRepositoryImpl(
        gh<_i958.ExerciseRemoteDataSource>(),
        gh<_i484.TimedCache>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.factory<_i876.GetExercises>(
      () => _i876.GetExercises(gh<_i1032.ExerciseRepository>()),
    );
    gh.factory<_i616.GetExerciseDetails>(
      () => _i616.GetExerciseDetails(gh<_i1032.ExerciseRepository>()),
    );
    gh.factory<_i394.ProfileEditCubit>(
      () => _i394.ProfileEditCubit(gh<_i567.UpdateMyProfile>()),
    );
    gh.factory<_i420.ResendPhoneOtp>(
      () => _i420.ResendPhoneOtp(gh<_i317.OtpRepository>()),
    );
    gh.lazySingleton<_i841.ClubDirectoryRepository>(
      () => _i940.ClubDirectoryRepositoryImpl(
        gh<_i990.ClubDirectoryRemoteDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.factory<_i938.RequestPasswordReset>(
      () => _i938.RequestPasswordReset(gh<_i897.PasswordResetRepository>()),
    );
    gh.factory<_i70.ResetPassword>(
      () => _i70.ResetPassword(gh<_i897.PasswordResetRepository>()),
    );
    gh.factory<_i521.VerifyPasswordResetOtp>(
      () => _i521.VerifyPasswordResetOtp(gh<_i897.PasswordResetRepository>()),
    );
    gh.factory<_i836.GetTrialDetails>(
      () => _i836.GetTrialDetails(gh<_i787.TrialRepository>()),
    );
    gh.factory<_i527.ExerciseDetailsCubit>(
      () => _i527.ExerciseDetailsCubit(gh<_i616.GetExerciseDetails>()),
    );
    gh.factory<_i825.LogOut>(() => _i825.LogOut(gh<_i700.SessionRepository>()));
    gh.factory<_i349.ReadSession>(
      () => _i349.ReadSession(gh<_i700.SessionRepository>()),
    );
    gh.factory<_i136.DescribeSession>(
      () => _i136.DescribeSession(gh<_i700.SessionRepository>()),
    );
    gh.factory<_i499.ProfileCubit>(
      () => _i499.ProfileCubit(gh<_i352.GetMyProfile>()),
    );
    gh.factory<_i702.ReadPendingRegistration>(
      () => _i702.ReadPendingRegistration(
        gh<_i858.PendingRegistrationRepository>(),
      ),
    );
    gh.lazySingleton<_i826.ViewerCapabilityPort>(
      () => _i37.CachedViewerCapability(
        gh<_i892.KeyValueStore>(),
        gh<_i876.SubscriptionReader>(),
      ),
    );
    gh.factory<_i714.PasswordResetCubit>(
      () => _i714.PasswordResetCubit(
        gh<_i938.RequestPasswordReset>(),
        gh<_i521.VerifyPasswordResetOtp>(),
        gh<_i70.ResetPassword>(),
      ),
    );
    gh.lazySingleton<_i488.AuthRepository>(
      () => _i263.AuthRepositoryImpl(
        gh<_i794.AuthRemoteDataSource>(),
        gh<_i449.ErrorMapper>(),
      ),
    );
    gh.factory<_i1030.GetCities>(
      () => _i1030.GetCities(gh<_i841.ClubDirectoryRepository>()),
    );
    gh.factory<_i859.GetClubsInCity>(
      () => _i859.GetClubsInCity(gh<_i841.ClubDirectoryRepository>()),
    );
    gh.factory<_i910.GetTermsAndPolicies>(
      () => _i910.GetTermsAndPolicies(gh<_i506.TermsRepository>()),
    );
    gh.factory<_i852.RegisterClub>(
      () => _i852.RegisterClub(
        gh<_i488.AuthRepository>(),
        gh<_i858.PendingRegistrationRepository>(),
      ),
    );
    gh.factory<_i141.RegisterScout>(
      () => _i141.RegisterScout(
        gh<_i488.AuthRepository>(),
        gh<_i858.PendingRegistrationRepository>(),
      ),
    );
    gh.factory<_i396.GetPlayerAttempts>(
      () => _i396.GetPlayerAttempts(gh<_i314.AttemptRepository>()),
    );
    gh.factory<_i544.UploadAttemptForPlayer>(
      () => _i544.UploadAttemptForPlayer(gh<_i314.AttemptRepository>()),
    );
    gh.factory<_i731.ScoutRegistrationCubit>(
      () => _i731.ScoutRegistrationCubit(gh<_i141.RegisterScout>()),
    );
    gh.factory<_i330.LogIn>(
      () => _i330.LogIn(
        gh<_i488.AuthRepository>(),
        gh<_i700.SessionRepository>(),
      ),
    );
    gh.factory<_i72.PlayerAttemptsCubit>(
      () => _i72.PlayerAttemptsCubit(gh<_i396.GetPlayerAttempts>()),
    );
    gh.factory<_i973.ExerciseListCubit>(
      () => _i973.ExerciseListCubit(gh<_i876.GetExercises>()),
    );
    gh.factory<_i770.SignInCubit>(
      () => _i770.SignInCubit(
        gh<_i330.LogIn>(),
        gh<_i702.ReadPendingRegistration>(),
      ),
    );
    gh.factory<_i896.TrialDetailsCubit>(
      () => _i896.TrialDetailsCubit(gh<_i836.GetTrialDetails>()),
    );
    gh.factory<_i608.TermsCubit>(
      () => _i608.TermsCubit(gh<_i910.GetTermsAndPolicies>()),
    );
    gh.factoryParam<_i840.OtpCubit, _i508.RegistrationCredential, dynamic>(
      (_credential, _) => _i840.OtpCubit(
        gh<_i461.ConfirmPhoneOtp>(),
        gh<_i420.ResendPhoneOtp>(),
        _credential,
      ),
    );
    gh.factory<_i491.AttemptUploadCubit>(
      () => _i491.AttemptUploadCubit(
        gh<_i544.UploadAttemptForPlayer>(),
        gh<_i826.ViewerCapabilityPort>(),
      ),
    );
    gh.factory<_i398.ClubRegistrationCubit>(
      () => _i398.ClubRegistrationCubit(gh<_i852.RegisterClub>()),
    );
    gh.factory<_i741.ClubDirectoryCubit>(
      () => _i741.ClubDirectoryCubit(
        gh<_i1030.GetCities>(),
        gh<_i859.GetClubsInCity>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
