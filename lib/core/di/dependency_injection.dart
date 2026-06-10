import 'package:dio/dio.dart';
import 'package:falconclubapp/feature/creat_real/cubit/creat_real_cubit.dart';
import 'package:falconclubapp/feature/creat_real/data/repo/creat_real_repo.dart';
import 'package:falconclubapp/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:falconclubapp/feature/login/data/repos/login_repo.dart';
import 'package:falconclubapp/feature/package/cubit/package_cubit.dart';
import 'package:falconclubapp/feature/package/data/repo/package_repo.dart';
import 'package:falconclubapp/feature/player_reels/cubit/player_reels_cubit.dart';
import 'package:falconclubapp/feature/player_reels/data/repo/player_reels_repo.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_cubit.dart';
import 'package:falconclubapp/feature/rank/data/repo/rank_repo.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/data/repo/reals_repo.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_team_repo.dart';
import 'package:get_it/get_it.dart';
import '../../feature/Measurement/cubit/MeasurementCubit.dart';
import '../../feature/Measurement/data/repo/MeasurementRepo.dart';
import '../../feature/club_team/cubit/club_exercises_cubit.dart';
import '../../feature/digital_report/cubit/digitalReportCubit.dart';
import '../../feature/main_club/cubit/requests_cubit.dart';
import '../../feature/main_club/data/repo/requests_repo.dart';
import '../../feature/scout/cubit/scout_register_cubit.dart';
import '../../feature/scout/data/repo/scout_repo.dart';
import '../../feature/club_team/data/repo/club_exercises_repo.dart';
import '../../feature/digital_report/data/repo/digitalReportRepo.dart';
import '../../feature/player_attempts/cubit/player_attempts_cubit.dart';
import '../../feature/player_attempts/data/repo/player_attempts_repo.dart';
import '../../feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../feature/experiance_details_screen/data/repo/experiance_details_repo.dart';
import '../../feature/experiments/data/repo/experiments_repo.dart';
import '../../feature/forget_password/cubit/forget_password_cubit.dart';
import '../../feature/forget_password/data/repo/forget_password_repo.dart';
import '../../feature/main_screen/cubit/main_cubit.dart';
import '../../feature/main_screen/data/repo/main_repo.dart';
import '../../feature/player_profile/cubit/player_profile_cubit.dart';
import '../../feature/player_profile/data/repo/skills_repo.dart';
import '../../feature/scout/scout_training/cubit/scout_training_cubit.dart';
import '../../feature/scout/scout_training/cubit/scout_training_details_cubit.dart';
import '../../feature/scout/scout_training/data/repo/scout_training_details_repo.dart';
import '../../feature/scout/scout_training/data/repo/scout_training_repo.dart';
import '../../feature/training/cubit/training_cubit.dart';
import '../../feature/training/data/repo/training_repo.dart';
import '../../feature/training_details/cubit/training_details_cubit.dart';
import '../../feature/training_details/data/repo/training_details_repo.dart';

// ── Scout Training (feature منفصلة) ─────────────────────────────────────────
// ────────────────────────────────────────────────────────────────────────────
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // MARK: - Dio & ApiService
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // MARK: - Measurement
  getIt.registerLazySingleton<MeasurementRepo>(() => MeasurementRepo());
  getIt.registerFactory<MeasurementCubit>(() => MeasurementCubit(getIt()));

  // MARK: - Main
  getIt.registerLazySingleton<MainRepo>(() => MainRepo(getIt()));
  getIt.registerFactory<MainCubit>(() => MainCubit(getIt()));

  // MARK: - Club Team
  getIt.registerLazySingleton<ClubTeamRepo>(() => ClubTeamRepo(getIt()));
  getIt.registerFactory<ClubTeamCubit>(() => ClubTeamCubit(getIt()));

  // MARK: - Login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  // MARK: - Experiments
  getIt.registerLazySingleton<ExperimentsRepo>(() => ExperimentsRepo(getIt()));
  getIt.registerFactory<ExperimentsCubit>(() => ExperimentsCubit(getIt()));

  // MARK: - Training (النادي)
  getIt.registerLazySingleton<TrainingRepo>(() => TrainingRepo(getIt()));
  getIt.registerFactory<TrainingCubit>(() => TrainingCubit(getIt()));

  // MARK: - Scout Training (مستقل — لا يؤثر على Training النادي)
  getIt.registerLazySingleton<ScoutTrainingRepo>(
    () => ScoutTrainingRepo(getIt()),
  );
  getIt.registerFactory<ScoutTrainingCubit>(() => ScoutTrainingCubit(getIt()));
  getIt.registerLazySingleton<ScoutTrainingDetailsRepo>(
    () => ScoutTrainingDetailsRepo(getIt()),
  );
  getIt.registerFactory<ScoutTrainingDetailsCubit>(
    () => ScoutTrainingDetailsCubit(getIt()),
  );

  // MARK: - ExperianceDetails
  getIt.registerLazySingleton<ExperianceDetailsRepo>(
    () => ExperianceDetailsRepo(getIt()),
  );
  getIt.registerFactory<ExperianceDetailsCubit>(
    () => ExperianceDetailsCubit(getIt()),
  );

  // MARK: - TrainingDetails (النادي)
  getIt.registerLazySingleton<TrainingDetailsRepo>(
    () => TrainingDetailsRepo(getIt()),
  );
  getIt.registerFactory<TrainingDetailsCubit>(
    () => TrainingDetailsCubit(getIt()),
  );

  // MARK: - Reals
  getIt.registerLazySingleton<RealsRepo>(() => RealsRepo(getIt()));
  getIt.registerFactory<RealsCubit>(() => RealsCubit(getIt()));

  // MARK: - Rank
  getIt.registerLazySingleton<RankRepo>(() => RankRepo(getIt()));
  getIt.registerFactory<RankCubit>(() => RankCubit(getIt()));

  // MARK: - PlayerProfile
  getIt.registerLazySingleton<PlayerProfileRepo>(
    () => PlayerProfileRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<PlayerProfileCubit>(
    () => PlayerProfileCubit(getIt<PlayerProfileRepo>()),
  );

  // MARK: - Package
  getIt.registerLazySingleton<PackageRepo>(() => PackageRepo(getIt()));
  getIt.registerFactory<PackageCubit>(() => PackageCubit(getIt()));

  // MARK: - Forget Password
  getIt.registerLazySingleton<ForgetPasswordRepo>(
    () => ForgetPasswordRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(getIt<ForgetPasswordRepo>()),
  );

  // MARK: - PlayerAttempts
  getIt.registerLazySingleton<PlayerAttemptsRepo>(
    () => PlayerAttemptsRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<PlayerAttemptsCubit>(
    () => PlayerAttemptsCubit(getIt<PlayerAttemptsRepo>()),
  );

  // MARK: - ClubExercises
  getIt.registerLazySingleton<ClubExercisesRepo>(
    () => ClubExercisesRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ClubExercisesCubit>(
    () => ClubExercisesCubit(getIt<ClubExercisesRepo>()),
  );

  // MARK: - PlayerReels
  getIt.registerLazySingleton<PlayerReelsRepo>(
    () => PlayerReelsRepo(getIt<ApiService>(), getIt<Dio>()),
  );
  getIt.registerFactory<PlayerReelsCubit>(
    () => PlayerReelsCubit(getIt<PlayerReelsRepo>()),
  );

  // MARK: - DigitalReport
  getIt.registerLazySingleton<DigitalReportRepo>(
    () => DigitalReportRepo(getIt<Dio>()),
  );
  getIt.registerFactory<DigitalReportCubit>(
    () => DigitalReportCubit(getIt<DigitalReportRepo>()),
  );

  // MARK: - Scout
  getIt.registerLazySingleton<ScoutRepo>(() => ScoutRepo(getIt<Dio>()));
  getIt.registerFactory<ScoutRegisterCubit>(
    () => ScoutRegisterCubit(getIt<ScoutRepo>()),
  );
  getIt.registerLazySingleton(() => RequestsRepo(getIt<ApiService>()));
  getIt.registerFactory(() => RequestsCubit(getIt<RequestsRepo>()));
}
