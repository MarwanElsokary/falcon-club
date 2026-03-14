import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../feature/Measurement/cubit/MeasurementCubit.dart';
import '../../feature/Measurement/ui/MeasurementScreen.dart';
import '../../feature/Player_profile/ui/screen/player_profile_screen.dart';
import '../../feature/all_experiment/ui/screen/all_experiment_screen.dart';
import '../../feature/creat_real/cubit/creat_real_cubit.dart';
import '../../feature/creat_real/ui/screen/publish_my_video.dart';
import '../../feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../feature/experiance_details_screen/ui/screen/experiance_details_screen.dart';
import '../../feature/experiments/cubit/experiments_cubit.dart';
import '../../feature/forget_password/cubit/forget_password_cubit.dart';
import '../../feature/forget_password/ui/forget_password_screen.dart';
import '../../feature/forget_password/ui/reset_password_screen.dart';
import '../../feature/forget_password/ui/send_otp.dart';
import '../../feature/last_attempt/ui/screen/last_attempt_screen.dart';
import '../../feature/login/cubit/login_cubit.dart';
import '../../feature/login/ui/screen/login_screen.dart';
import '../../feature/main_screen/cubit/main_cubit.dart';
import '../../feature/main_screen/ui/screen/main_screen.dart';
import '../../feature/on-boarding/screen/on_boarding_screen.dart';
import '../../feature/package/cubit/package_cubit.dart';
import '../../feature/package/data/model/pakcage_model.dart';
import '../../feature/package/ui/screen/package_pay_ment_screen.dart';
import '../../feature/package/ui/screen/package_screen.dart';
import '../../feature/package/ui/widget/verification_webview_screen.dart';
import '../../feature/rank/cubit/rank_cubit.dart';
import '../../feature/rank/ui/screen/rank_screen.dart';
import '../../feature/reals/cubit/reals_cubit.dart';
import '../../feature/reals/ui/screen/main_reals_screen.dart';
import '../../feature/signup/ui/screen/club_sign_up_screen.dart';
import '../../feature/signup/ui/screen/complete_profile_screen.dart';
import '../../feature/signup/ui/screen/position_screen.dart';
import '../../feature/signup/ui/screen/registration_type_screen.dart';
import '../../feature/signup/ui/screen/scout_sign_up_screen.dart';
import '../../feature/signup/ui/screen/sign_up_screen.dart';
import '../../feature/club_team/cubit/club_team_cubit.dart';
import '../../feature/club_team/ui/screen/club_main_screen.dart';
import '../../feature/scout/cubit/scout_cubit.dart';
import '../../feature/scout/ui/screens/scout_main_screen.dart';
import '../../feature/signup/cubit/scout_register_cubit.dart';
import '../../feature/splash_screen/splash_screen.dart';
import '../../feature/training/cubit/training_cubit.dart';
import '../../feature/training/ui/screen/training_screen.dart';
import '../../feature/training_details/cubit/training_details_cubit.dart';
import '../../feature/training_details/data/model/exercise_details_model.dart';
import '../../feature/training_details/ui/screen/ai_generate_screen.dart';
import '../../feature/training_details/ui/screen/training_details_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
    // ========================================================================
    // CORE SCREENS
    // ========================================================================
      case AppRoute.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case AppRoute.onBoardingScreen:
        return _fadeTransitionRoute(const OnBoardingScreen());

    // ========================================================================
    // AUTH SCREENS
    // ========================================================================
      case AppRoute.loginScreen:
        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );
    // case AppRoute.paymentVerificationScreen:
    //   final args = settings.arguments as Map<String, dynamic>;
    //   return MaterialPageRoute(
    //     builder: (_) => BlocProvider.value(
    //       value: getIt<PackageCubit>(),
    //       child: PaymentVerificationScreen(
    //         verificationUrl: args['verificationUrl'],
    //         packageId: args['packageId'],
    //       ),
    //     ),
    //   );

      case AppRoute.signUpScreen:
        final args = arguments as Map<String, dynamic>?;
        final update = args?['update'] ?? false;

        return MaterialWithModalsPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>()..loadCountries(),
            child: SignUpScreen(update: update),
          ),
        );

      case AppRoute.registrationTypeScreen:
        return _fadeTransitionRoute(const RegistrationTypeScreen());

      case AppRoute.clubSignUpScreen:
        return MaterialWithModalsPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>()..loadCountries(),
            child: const ClubSignUpScreen(),
          ),
        );

      case AppRoute.clubMainScreen:
        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<ClubTeamCubit>()..emitMyProfile(),
            child: const ClubMainScreen(),
          ),
        );

      case AppRoute.scoutMainScreen:
        return _fadeTransitionRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<ScoutCubit>()..fetchProfile(),
              ),
              BlocProvider(
                create: (_) => getIt<ClubTeamCubit>()..fetchClubPlayers(),
              ),
            ],
            child: const ScoutMainScreen(),
          ),
        );

      case AppRoute.scoutSignUpScreen:
        return MaterialWithModalsPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ScoutRegisterCubit>(),
            child: const ScoutSignUpScreen(),
          ),
        );

      case AppRoute.completeProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<LoginCubit>()..loadCountries(),
            child: const CompleteProfileScreen(),
          ),
        );

      case AppRoute.positionScreen:
        final args = arguments as Map<String, dynamic>;
        final context = args['context'] as BuildContext;

        return MaterialWithModalsPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<LoginCubit>(context),
            child: const PositionScreen(),
          ),
        );

    // ========================================================================
    // PASSWORD RECOVERY
    // ========================================================================
      case AppRoute.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ForgetPasswordCubit>(),
            child: const ForgetPasswordScreen(),
          ),
        );

      case AppRoute.sendOtp:
        final args = arguments as Map<String, dynamic>;
        final phoneNumber = args['phoneNumber'] ?? '';

        return MaterialPageRoute(
          builder: (_) => SendOtpScreen(phoneNumber: phoneNumber),
        );

      case AppRoute.resetPasswordScreen:
        final args = arguments as Map<String, dynamic>;
        final token = args['token'] as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ForgetPasswordCubit>(),
            child: ResetPasswordScreen(token: token),
          ),
        );

    // ========================================================================
    // MAIN APP
    // ========================================================================
      case AppRoute.mainScreen:
        return _fadeTransitionRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<MainCubit>()
                  ..emitMyProfile()
                  ..emitCategories(),
              ),
              BlocProvider(
                create: (_) => getIt<RankCubit>()..emitRank(),
              ),
            ],
            child: const MainScreen(),
          ),
        );

    // ========================================================================
    // PLAYER PROFILE
    // ========================================================================
      case AppRoute.playerProfile:
        final args = arguments as Map<String, dynamic>;
        final isMyProfile = args['isMyProfile'] as bool;
        final playerId = args['playerId'] as String;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<RealsCubit>()..emitreals(
                  playerId: playerId,
                ),
              ),
              BlocProvider(
                create: (_) => getIt<MainCubit>()..emitProfileById(userId: playerId),
              ),
            ],
            child: PlayerProfileScreen(
              ismyProfile: isMyProfile,
              playerId: playerId,
            ),
          ),
        );

    // ========================================================================
    // REALS/VIDEOS
    // ========================================================================
      case AppRoute.mainRealsScreen:
        final args = arguments as Map<String, dynamic>;
        final context = args['context'] as BuildContext;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<RealsCubit>()),
              BlocProvider.value(value: context.read<MainCubit>()),
            ],
            child: const MainRealsScreen(
              playnowOrNot: true,
              playerProfile: true,
            ),
          ),
        );

      case AppRoute.publishMyVideo:
        final args = arguments as Map<String, dynamic>;
        final outputPath = args['outputPath'] as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<CreatRealCubit>(),
            child: PublishMyVideo(videoPath: outputPath),
          ),
        );

    // ========================================================================
    // TRAINING
    // ========================================================================
      case AppRoute.trainingScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<TrainingCubit>()
                  ..emitallExercises(categoryId: '', popular: false),
              ),
              BlocProvider(
                create: (_) => getIt<MainCubit>()..emitCategories(),
              ),
            ],
            child: const TrainingScreen(),
          ),
        );

      case AppRoute.trainingDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final exerciseId = args['exerciseId'] as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<TrainingDetailsCubit>()
              ..emitexerciseDetails(exerciseId: exerciseId),
            child: const TrainingDetailsScreen(),
          ),
        );

      case AppRoute.lastAttemptScreen:
        final args = arguments as Map<String, dynamic>;
        final exerciseDetails = args['exerciseDetails'] as ExerciseDetailsModel;

        return MaterialPageRoute(
          builder: (_) => LastAttemptScreen(exerciseDetails: exerciseDetails),
        );

      case AppRoute.aiGenerateScreen:
        return MaterialPageRoute(
          builder: (_) => const AiGenerateScreen(),
        );

    // ========================================================================
    // EXPERIMENTS
    // ========================================================================
      case AppRoute.experianceDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final heroTag = args['heroTag'] as String;
        final experianceImage = args['experianceImage'] as String;
        final trialId = args['trialId'] as String;
        final title = args['title'] as String;

        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<ExperianceDetailsCubit>()
              ..emittrialsDetails(trialId: trialId),
            child: ExperianceDetailsScreen(
              title: title,
              heroTag: heroTag,
              experianceImage: experianceImage,
            ),
          ),
        );

      case AppRoute.allExperimentScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ExperimentsCubit>()
              ..emitallTrials(categoryId: ''),
            child: const AllExperimentScreen(),
          ),
        );

    // ========================================================================
    // RANKING
    // ========================================================================
      case AppRoute.rankScreen:
        final args = arguments as Map<String, dynamic>;
        final context = args['context'] as BuildContext;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<RankCubit>(),
            child: const RankScreen(),
          ),
        );

    // ========================================================================
    // PACKAGES
    // ========================================================================
      case AppRoute.packageScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PackageCubit>()..emitAllPackagesState(),
            child: const PackageScreen(),
          ),
        );

      case AppRoute.packagePayMentScreen:
        final args = arguments as Map<String, dynamic>;
        final packageModel = args['packageModel'] as PackageModel;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PackageCubit>()..emitAllPackagesState(),
            child: PackagePayMentScreen(packageModel: packageModel),
          ),
        );

    // ========================================================================
    // MEASUREMENT
    // ========================================================================
      case AppRoute.measurementScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<MeasurementCubit>(),
            child: const MeasurementScreen(),
          ),
        );

    // ========================================================================
    // DEFAULT
    // ========================================================================
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }

  // Helper method for fade transitions
  PageRouteBuilder _fadeTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}