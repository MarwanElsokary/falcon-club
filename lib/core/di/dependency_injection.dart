import 'package:dio/dio.dart';
import 'package:falcon/feature/creat_real/cubit/creat_real_cubit.dart';
import 'package:falcon/feature/creat_real/data/repo/creat_real_repo.dart';
import 'package:falcon/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:falcon/feature/login/data/repos/login_repo.dart';
import 'package:falcon/feature/package/cubit/package_cubit.dart';
import 'package:falcon/feature/package/data/repo/package_repo.dart';
import 'package:falcon/feature/rank/cubit/rank_cubit.dart';
import 'package:falcon/feature/rank/data/repo/rank_repo.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:falcon/feature/reals/data/repo/reals_repo.dart';
import 'package:get_it/get_it.dart';

import '../../feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../feature/experiance_details_screen/data/repo/experiance_details_repo.dart';
import '../../feature/experiments/data/repo/experiments_repo.dart';
import '../../feature/forget_password/cubit/forget_password_cubit.dart';
import '../../feature/forget_password/data/repo/forget_password_repo.dart';
import '../../feature/main_screen/cubit/main_cubit.dart';
import '../../feature/main_screen/data/repo/main_repo.dart';
import '../../feature/player_profile/cubit/player_profile_cubit.dart';
import '../../feature/player_profile/data/repo/skills_repo.dart';
import '../../feature/training/cubit/training_cubit.dart';
import '../../feature/training/data/repo/training_repo.dart';
import '../../feature/training_details/cubit/training_details_cubit.dart';
import '../../feature/training_details/data/repo/training_details_repo.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // MARK: - Dio & ApiService
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  // MARK: - Main
  getIt.registerLazySingleton<MainRepo>(() => MainRepo(getIt()));
  getIt.registerFactory<MainCubit>(() => MainCubit(getIt()));

  // MARK: - Login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  // MARK: - Experiments
  getIt.registerLazySingleton<ExperimentsRepo>(() => ExperimentsRepo(getIt()));
  getIt.registerFactory<ExperimentsCubit>(() => ExperimentsCubit(getIt()));

  // MARK: - Training
  getIt.registerLazySingleton<TrainingRepo>(() => TrainingRepo(getIt()));
  getIt.registerFactory<TrainingCubit>(() => TrainingCubit(getIt()));

  // MARK: - ExperianceDetails
  getIt.registerLazySingleton<ExperianceDetailsRepo>(
    () => ExperianceDetailsRepo(getIt()),
  );
  getIt.registerFactory<ExperianceDetailsCubit>(
    () => ExperianceDetailsCubit(getIt()),
  );

  // MARK: - TrainingDetails
  getIt.registerLazySingleton<TrainingDetailsRepo>(
    () => TrainingDetailsRepo(getIt()),
  );
  getIt.registerFactory<TrainingDetailsCubit>(
    () => TrainingDetailsCubit(getIt()),
  );

  // MARK: - CreatReal
  getIt.registerLazySingleton<CreatRealRepo>(() => CreatRealRepo(getIt()));
  getIt.registerFactory<CreatRealCubit>(() => CreatRealCubit(getIt()));

  // MARK: - Reals
  getIt.registerLazySingleton<RealsRepo>(() => RealsRepo(getIt()));
  getIt.registerFactory<RealsCubit>(() => RealsCubit(getIt()));

  // MARK: - Rank
  getIt.registerLazySingleton<RankRepo>(() => RankRepo(getIt()));
  getIt.registerFactory<RankCubit>(() => RankCubit(getIt()));

  // MARK: - PlayerProfileRepo (مسجل كـ LazySingleton)
  getIt.registerLazySingleton<PlayerProfileRepo>(
    () => PlayerProfileRepo(getIt<ApiService>()),
  );

  // MARK: - PlayerProfileCubit
  getIt.registerFactory<PlayerProfileCubit>(
    () => PlayerProfileCubit(getIt<PlayerProfileRepo>()),
  );

  // MARK: - Package
  getIt.registerLazySingleton<PackageRepo>(() => PackageRepo(getIt()));
  getIt.registerFactory<PackageCubit>(() => PackageCubit(getIt()));

  // // MARK: - Forget Password
  // getIt.registerLazySingleton<ForgetPasswordApiService>(
  //   () => ForgetPasswordApiService(getIt<Dio>()),
  // );
  //
  // getIt.registerLazySingleton<ForgetPasswordRepo>(
  //   () => ForgetPasswordRepo(getIt<ForgetPasswordApiService>()),
  // );
  //
  // getIt.registerFactory<ForgetPasswordCubit>(
  //   () => ForgetPasswordCubit(getIt<ForgetPasswordRepo>()),
  // );
}
