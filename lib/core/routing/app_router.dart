import 'package:falcon/feature/all_experiment/ui/screen/all_experiment_screen.dart';
import 'package:falcon/feature/creat_real/cubit/creat_real_cubit.dart';
import 'package:falcon/feature/forget_password/ui/forget_password_screen.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:falcon/feature/login/ui/screen/login_screen.dart';
import 'package:falcon/feature/package/cubit/package_cubit.dart';
import 'package:falcon/feature/package/ui/screen/package_pay_ment_screen.dart';
import 'package:falcon/feature/package/ui/screen/package_screen.dart';
import 'package:falcon/feature/rank/cubit/rank_cubit.dart';
import 'package:falcon/feature/rank/ui/screen/rank_screen.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:falcon/feature/signup/ui/screen/position_screen.dart';
import 'package:falcon/feature/training_details/cubit/training_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    show MaterialWithModalsPageRoute;

import '../../feature/Player_profile/ui/screen/player_profile_screen.dart';
import '../../feature/creat_real/ui/screen/publish_my_video.dart';
import '../../feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../feature/experiance_details_screen/ui/screen/experiance_details_screen.dart';
import '../../feature/experiments/cubit/experiments_cubit.dart';

import '../../feature/forget_password/cubit/forget_password_cubit.dart';
import '../../feature/forget_password/ui/reset_password_screen.dart';
import '../../feature/forget_password/ui/send_otp.dart';
import '../../feature/last_attempt/ui/screen/last_attempt_screen.dart';
import '../../feature/main_screen/cubit/main_cubit.dart';
import '../../feature/main_screen/ui/screen/main_screen.dart';
import '../../feature/on-boarding/screen/on_boarding_screen.dart';

import '../../feature/package/data/model/pakcage_model.dart';
import '../../feature/reals/ui/screen/main_reals_screen.dart';
import '../../feature/signup/ui/screen/sign_up_screen.dart';
import '../../feature/splash_screen/splash_screen.dart';
import '../../feature/training/cubit/training_cubit.dart';
import '../../feature/training/ui/screen/training_screen.dart';
import '../../feature/training_details/data/model/exercise_details_model.dart';
import '../../feature/training_details/ui/screen/ai_generate_screen.dart';
import '../../feature/training_details/ui/screen/training_details_screen.dart';
import '../di/dependency_injection.dart';
import 'routes.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      //splash
      case AppRoute.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      //WelcomeScreen

      //onBoarding
      case AppRoute.onBoardingScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnBoardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      case AppRoute.loginScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case AppRoute.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: ForgetPasswordScreen(),
          ),
        );

      case AppRoute.signUpScreen:
        var args = arguments as Map<String, dynamic>;

        bool update = args['update'];
        return MaterialWithModalsPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<LoginCubit>()..emitcountries(),
            child: SignUpScreen(update: update),
          ),
        );
      case AppRoute.positionScreen:
        var args = arguments as Map<String, dynamic>;

        var context = args['context'];
        return MaterialWithModalsPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<LoginCubit>(context),
            child: PositionScreen(),
          ),
        );
      //
      case AppRoute.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgetPasswordCubit>(),
            child: const ForgetPasswordScreen(),
          ),
        );

      case AppRoute.sendOtp:
        var args = arguments as Map<String, dynamic>;
        String phoneNumber = args['phoneNumber'] ?? '';
        return MaterialPageRoute(
          builder: (_) => SendOtpScreen(phoneNumber: phoneNumber),
        );

      // Add new route
      case AppRoute.resetPasswordScreen:
        var args = arguments as Map<String, dynamic>;
        String token = args['token'];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<ForgetPasswordCubit>(),
            child: ResetPasswordScreen(token: token),
          ),
        );

      case AppRoute.mainScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => getIt<MainCubit>()
                      ..emitMyProfile()
                      ..emitCategories(),
                  ),
                  BlocProvider(
                    create: (context) => getIt<RankCubit>()..emitRank(),
                  ),
                ],
                child: const MainScreen(),
              ),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      case AppRoute.playerProfile:
        var args = arguments as Map<String, dynamic>;
        bool isMyProfile = args['isMyProfile'];
        String playerId = args['playerId'];

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<RealsCubit>()
                  ..emitreals(
                    pageNumber: '1',
                    pageSize: '10',
                    playerId: playerId,
                  ),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<MainCubit>()..emitProfileById(userId: playerId),
              ),
            ],
            child: PlayerProfileScreen(
              ismyProfile: isMyProfile,
              playerId: playerId,
            ),
          ),
        );

      case AppRoute.mainRealsScreen:
        var args = arguments as Map<String, dynamic>;

        var context = args['context'];
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: BlocProvider.of<RealsCubit>(context)),
              BlocProvider.value(value: BlocProvider.of<MainCubit>(context)),
            ],
            child: MainRealsScreen(playnowOrNot: true, playerProfile: true),
          ),
        );

      case AppRoute.trainingScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<TrainingCubit>()
                      ..emitallExercises(categoryId: '', popular: false),
              ),
              BlocProvider(
                create: (context) => getIt<MainCubit>()..emitCategories(),
              ),
            ],
            child: const TrainingScreen(),
          ),
        );

      //ExperianceDetailsScreen
      case AppRoute.experianceDetailsScreen:
        var args = arguments as Map<String, dynamic>;

        //heroTag
        String heroTag = args['heroTag'];
        String experianceImage = args['experianceImage'];
        String trialId = args['trialId'];
        String title = args['title'];
        return PageRouteBuilder(
          pageBuilder: (c, animation, secondaryAnimation) => BlocProvider(
            create: (context) =>
                getIt<ExperianceDetailsCubit>()
                  ..emittrialsDetails(trialId: trialId),
            child: ExperianceDetailsScreen(
              title: title,
              heroTag: heroTag,
              experianceImage: experianceImage,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      //TrainingDetailsScreen
      case AppRoute.trainingDetailsScreen:
        var args = arguments as Map<String, dynamic>;

        String exerciseId = args['exerciseId'];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<TrainingDetailsCubit>()
                  ..emitexerciseDetails(exerciseId: exerciseId),
            child: const TrainingDetailsScreen(),
          ),
        );

      //PublishMyVideo
      case AppRoute.publishMyVideo:
        var args = arguments as Map<String, dynamic>;

        //heroTag
        String outputPath = args['outputPath'];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<CreatRealCubit>(),
            child: PublishMyVideo(videoPath: outputPath),
          ),
        );

      //LastAttemptScreen
      case AppRoute.lastAttemptScreen:
        var args = arguments as Map<String, dynamic>;

        //exerciseDetails
        ExerciseDetailsModel exerciseDetails = args['exerciseDetails'];
        return MaterialPageRoute(
          builder: (_) => LastAttemptScreen(exerciseDetails: exerciseDetails),
        );
      //RankScreen
      case AppRoute.aiGenerateScreen:
        return MaterialPageRoute(builder: (_) => AiGenerateScreen());

      //RankScreen
      case AppRoute.rankScreen:
        var args = arguments as Map<String, dynamic>;

        var context = args['context'];
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: BlocProvider.of<RankCubit>(context),
            child: const RankScreen(),
          ),
        );

      case AppRoute.allExperimentScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<ExperimentsCubit>()..emitallTrials(categoryId: ''),
            child: AllExperimentScreen(),
          ),
        );
      case AppRoute.packageScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<PackageCubit>()..emitAllPackagesState(),
            child: PackageScreen(),
          ),
        );

      case AppRoute.packagePayMentScreen:
        var args = arguments as Map<String, dynamic>;

        PackageModel packageModel = args['packageModel'];
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<PackageCubit>()..emitAllPackagesState(),
            child: PackagePayMentScreen(packageModel: packageModel),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
