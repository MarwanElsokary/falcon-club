import 'package:dio/dio.dart';
import 'package:falconclubapp/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falconclubapp/feature/package/cubit/package_cubit.dart';
import 'package:falconclubapp/feature/package/data/repo/package_repo.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_cubit.dart';
import 'package:falconclubapp/feature/rank/data/repo/rank_repo.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/data/repo/reals_repo.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_team_repo.dart';
import 'package:get_it/get_it.dart';
import '../../feature/club_team/cubit/club_exercises_cubit.dart';
import '../../feature/digital_report/cubit/digitalReportCubit.dart';
import '../../feature/main_club/cubit/requests_cubit.dart';
import '../../feature/main_club/data/repo/requests_repo.dart';
import '../../feature/club_team/data/repo/club_exercises_repo.dart';
import '../../feature/digital_report/data/repo/digitalReportRepo.dart';
import '../../feature/player_attempts/cubit/player_attempts_cubit.dart';
import '../../feature/player_attempts/data/repo/player_attempts_repo.dart';
import '../../feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../feature/experiance_details_screen/data/repo/experiance_details_repo.dart';
import '../../feature/experiments/data/repo/experiments_repo.dart';
import '../../feature/main_screen/cubit/main_cubit.dart';
import '../../feature/main_screen/data/repo/main_repo.dart';
import '../../feature/training/cubit/training_cubit.dart';
import '../../feature/training/data/repo/training_repo.dart';
import '../../feature/training_details/cubit/training_details_cubit.dart';
import '../../feature/training_details/data/repo/training_details_repo.dart';

// ── Scout Training (feature منفصلة) ─────────────────────────────────────────
// ────────────────────────────────────────────────────────────────────────────
import '../networking/api_service.dart';

final getIt = GetIt.instance;

/// Legacy, hand-wired registrations.
///
/// Being strangled by `injection.dart` (`configureDependencies()`), which now
/// owns `Dio` and `ApiService` via `RegisterModule`. Both run against the same
/// [GetIt] instance, so the repositories below still resolve
/// `getIt<ApiService>()` exactly as before.
///
/// Registrations move out of here feature by feature. When this function is
/// empty, it gets deleted.
Future<void> setupGetIt() async {
  // MARK: - Main
  getIt.registerLazySingleton<MainRepo>(() => MainRepo(getIt()));
  getIt.registerFactory<MainCubit>(() => MainCubit(getIt()));

  // MARK: - Club Team
  getIt.registerLazySingleton<ClubTeamRepo>(() => ClubTeamRepo(getIt()));
  getIt.registerFactory<ClubTeamCubit>(() => ClubTeamCubit(getIt()));

  // MARK: - Experiments
  getIt.registerLazySingleton<ExperimentsRepo>(() => ExperimentsRepo(getIt()));
  getIt.registerFactory<ExperimentsCubit>(() => ExperimentsCubit(getIt()));

  // MARK: - Training (النادي)
  getIt.registerLazySingleton<TrainingRepo>(() => TrainingRepo(getIt()));
  getIt.registerFactory<TrainingCubit>(() => TrainingCubit(getIt()));

  // MARK: - Scout Training — removed in Phase 4.
  // The Scout list fork went first (one ExerciseListCubit for every role); the
  // Scout *details* fork (ScoutTrainingDetailsRepo/Cubit/Screen) is now gone
  // too. Club and Scout share one ExerciseDetailsScreen driven by an injected
  // ExerciseCapability — there is nothing role-specific left to register.

  // MARK: - ExperianceDetails
  // Reads only now (trial details + player roster). The attempt upload it used
  // to own — the one reason it held a `Dio` and a `ViewerCapabilityPort` —
  // moved to the exercise feature's AttemptUploadCubit in Phase 5.
  getIt.registerLazySingleton<ExperianceDetailsRepo>(
    () => ExperianceDetailsRepo(getIt<ApiService>()),
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

  // MARK: - Package
  getIt.registerLazySingleton<PackageRepo>(() => PackageRepo(getIt()));
  getIt.registerFactory<PackageCubit>(() => PackageCubit(getIt()));

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

  // MARK: - DigitalReport
  getIt.registerLazySingleton<DigitalReportRepo>(
    () => DigitalReportRepo(getIt<Dio>()),
  );
  getIt.registerFactory<DigitalReportCubit>(
    () => DigitalReportCubit(getIt<DigitalReportRepo>()),
  );

  // MARK: - Requests (MainClub)
  getIt.registerLazySingleton<RequestsRepo>(
    () => RequestsRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<RequestsCubit>(
    () => RequestsCubit(getIt<RequestsRepo>()),
  );
}
