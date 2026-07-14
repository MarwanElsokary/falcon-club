import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../feature/auth/domain/entities/password_reset_ticket.dart';
import '../../feature/auth/domain/entities/registration_credential.dart';
import '../../feature/auth/presentation/cubit/password_reset_cubit.dart';
import '../../feature/auth/presentation/screens/new_password_screen.dart';
import '../../feature/auth/presentation/screens/request_reset_screen.dart';
import '../../feature/auth/presentation/screens/verify_reset_otp_screen.dart';
import '../../feature/auth/presentation/cubit/club_directory_cubit.dart';
import '../../feature/auth/presentation/cubit/club_registration_cubit.dart';
import '../../feature/auth/presentation/cubit/otp_cubit.dart';
import '../../feature/auth/presentation/cubit/registration_cubit.dart';
import '../../feature/auth/presentation/cubit/scout_registration_cubit.dart';
import '../../feature/auth/presentation/cubit/terms_cubit.dart';
import '../../feature/auth/presentation/screens/otp_screen.dart';
import '../../feature/auth/presentation/screens/registration_screen.dart';
import '../../feature/player_profile/ui/screen/player_profile_screen.dart';
import '../../feature/all_experiment/ui/screen/all_experiment_screen.dart';
import '../../feature/club_team/ui/screen/club_my_team_screen.dart';
import '../../feature/club_team/ui/screen/club_profile_screen.dart';
import '../../feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../feature/experiance_details_screen/ui/screen/experiance_details_screen.dart';
import '../../feature/experiments/cubit/experiments_cubit.dart';
import '../../feature/auth/presentation/cubit/sign_in_cubit.dart';
import '../../feature/auth/presentation/screens/sign_in_screen.dart';
import '../../feature/main_club/cubit/requests_cubit.dart';
import '../../feature/main_club/ui/screens/club_info_screen.dart';
import '../../feature/main_club/ui/screens/mainClubScreen.dart';
import '../../feature/main_club/ui/screens/requests_screen.dart';
import '../../feature/main_screen/cubit/main_cubit.dart';
import '../../feature/on-boarding/screen/on_boarding_screen.dart';
import '../../feature/package/cubit/package_cubit.dart';
import '../../feature/package/data/model/pakcage_model.dart';
import '../../feature/package/ui/screen/package_pay_ment_screen.dart';
import '../../feature/package/ui/screen/package_screen.dart';
import '../../feature/rank/cubit/rank_cubit.dart';
import '../../feature/rank/ui/screen/rank_screen.dart';
import '../../feature/reals/cubit/reals_cubit.dart';
import '../../feature/reals/ui/screen/main_reals_screen.dart';
import '../../feature/scout/scout_training/cubit/scout_training_cubit.dart';
import '../../feature/scout/scout_training/cubit/scout_training_details_cubit.dart';
import '../../feature/scout/scout_training/ui/screen/scout_training_details_screen.dart';
import '../../feature/scout/scout_training/ui/screen/scout_training_screen.dart';
import '../../feature/auth/presentation/screens/registration_type_screen.dart';
import '../../feature/club_team/cubit/club_team_cubit.dart';
import '../../feature/club_team/ui/screen/club_main_screen.dart';
import '../../feature/scout/ui/screen/scout_main_screen.dart';
import '../../feature/splash_screen/splash_screen.dart';
import '../../feature/training/cubit/training_cubit.dart';
import '../../feature/training/ui/screen/training_screen.dart';
import '../../feature/training_details/cubit/training_details_cubit.dart';
import '../../feature/training_details/ui/screen/ClubTrainingDetailsScreen.dart';
import '../../feature/player_attempts/cubit/player_attempts_cubit.dart';
import '../../feature/player_attempts/data/model/player_attempts_model.dart';
import '../../feature/player_attempts/ui/screen/player_attempts_screen.dart';
import '../../feature/player_attempts/ui/screen/player_attempt_detail_screen.dart';

// ── Scout Training (feature منفصلة) ─────────────────────────────────────────
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
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoute.onBoardingScreen:
        return _fadeTransitionRoute(const OnBoardingScreen());

      // ========================================================================
      // AUTH SCREENS
      // ========================================================================
      case AppRoute.loginScreen:
        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<SignInCubit>(),
            child: const SignInScreen(),
          ),
        );

      case AppRoute.registrationTypeScreen:
        return _fadeTransitionRoute(const RegistrationTypeScreen());

      case AppRoute.otpScreen:
        final args = arguments as Map<String, dynamic>;
        final credential = args['credential'] as RegistrationCredential;
        final phoneNumber = args['phoneNumber'] as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            // The credential authenticates both OTP calls — it is the only thing
            // that tells the backend whose phone this is.
            create: (_) => getIt<OtpCubit>(param1: credential),
            child: OtpScreen(phoneNumber: phoneNumber),
          ),
        );

      case AppRoute.clubSignUpScreen:
        return MaterialWithModalsPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // The abstract base is what the screen depends on — the concrete
              // cubit is chosen here. One screen, two roles.
              BlocProvider<RegistrationCubit>(
                create: (_) => getIt<ClubRegistrationCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<ClubDirectoryCubit>()..loadCities(),
              ),
              // Consent is mandatory before an account can be created.
              BlocProvider(create: (_) => getIt<TermsCubit>()..load()),
            ],
            child: RegistrationScreen(
              title: 'تسجيل نادي'.tr(),
              requiresClub: true,
            ),
          ),
        );

      case AppRoute.clubMainScreen:
        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<ClubTeamCubit>()..emitMyProfile(),
            child: const ClubMainScreen(),
          ),
        );
      case AppRoute.mainClubScreen:
        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<ClubTeamCubit>()..emitMyProfile(),
            child: const MainClubScreen(),
          ),
        );

      case AppRoute.clubProfileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ClubTeamCubit>()..emitMyProfile(),
            child: const ClubProfileScreen(),
          ),
        );
      case AppRoute.clubMyTeamScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ClubTeamCubit>()
              ..emitMyProfile()
              ..fetchClubPlayers(),
            child: const ClubMyTeamScreen(),
          ),
        );
      case AppRoute.requestsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<RequestsCubit>()..fetchRequests(),
            child: const RequestsScreen(),
          ),
        );
      case AppRoute.clubInfoScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<ClubTeamCubit>()..emitMyProfile(),
            child: const ClubInfoScreen(),
          ),
        );

      // ========================================================================
      // PASSWORD RECOVERY
      // ========================================================================
      // ── Password reset: phone → code → new password ──────────────────────
      // Each step gets its own PasswordResetCubit; the phone and the ticket are
      // carried forward as route arguments, so no state has to survive between
      // them.
      case AppRoute.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PasswordResetCubit>(),
            child: const RequestResetScreen(),
          ),
        );

      case AppRoute.sendOtp:
        final args = arguments as Map<String, dynamic>;
        final phoneNumber = args['phoneNumber'] as String? ?? '';

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PasswordResetCubit>(),
            child: VerifyResetOtpScreen(phoneNumber: phoneNumber),
          ),
        );

      case AppRoute.resetPasswordScreen:
        final args = arguments as Map<String, dynamic>;
        // A typed ticket, not a bare String. It authorises one password change
        // and is never logged or persisted.
        final ticket = args['ticket'] as PasswordResetTicket;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PasswordResetCubit>(),
            child: NewPasswordScreen(ticket: ticket),
          ),
        );

      // ========================================================================
      // PLAYER PROFILE
      // ========================================================================
      case AppRoute.playerProfile:
        final args = arguments as Map<String, dynamic>;
        final isMyProfile = args['isMyProfile'] as bool;
        final playerId = args['playerId'] as String;
        // ✅ جيب الـ flag ده من الـ args — الـ caller هو اللي يعرف نوع اليوزر
        final showFavoriteButton = args['showFavoriteButton'] as bool? ?? false;

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<RealsCubit>()..emitreals(playerId: playerId),
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

      // ========================================================================
      // TRAINING
      // ========================================================================
      case AppRoute.trainingScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<TrainingCubit>()
                      ..emitallExercises(categoryId: '', popular: false),
              ),
              BlocProvider(create: (_) => getIt<MainCubit>()..emitCategories()),
            ],
            child: const TrainingScreen(),
          ),
        );
      case AppRoute.scoutTrainingScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // ✅ ScoutTrainingCubit مش TrainingCubit
              BlocProvider(
                create: (_) =>
                    getIt<ScoutTrainingCubit>()
                      ..fetchExercises(categoryId: '', popular: false),
              ),
              BlocProvider(create: (_) => getIt<MainCubit>()..emitCategories()),
            ],
            child: const ScoutTrainingScreen(),
          ),
        );

      // ── شاشة تمرين النادي ────────────────────────────────────────────────
      case AppRoute.clubTrainingDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final exerciseId = args['exerciseId'] as String;

        return _fadeTransitionRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<TrainingDetailsCubit>()
                      ..emitexerciseDetails(exerciseId: exerciseId),
              ),
              BlocProvider(create: (_) => getIt<ExperianceDetailsCubit>()),
            ],
            child: const ClubTrainingDetailsScreen(),
          ),
        );

      // ── شاشة تفاصيل التمرين للكشاف (view only) ──────────────────────────
      case AppRoute.scoutTrainingDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final exerciseId = args['exerciseId'] as String;

        return _fadeTransitionRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<ScoutTrainingDetailsCubit>()
                      ..fetchExerciseDetails(exerciseId: exerciseId),
              ),
              BlocProvider(create: (_) => getIt<ExperianceDetailsCubit>()),
            ],
            child: const ScoutTrainingDetailsScreen(),
          ),
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
            create: (_) =>
                getIt<ExperianceDetailsCubit>()
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
            create: (_) =>
                getIt<ExperimentsCubit>()..emitallTrials(categoryId: ''),
            child: const AllExperimentScreen(),
          ),
        );

      // ========================================================================
      // RANKING
      // ========================================================================
      case AppRoute.rankScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<RankCubit>()..emitRank(),
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
      // PLAYER ATTEMPTS
      // ========================================================================
      case AppRoute.playerAttemptsScreen:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PlayerAttemptsCubit>(),
            child: PlayerAttemptsScreen(
              exerciseId: args['exerciseId'] as int,
              playerId: args['playerId'] as String,
              playerName: args['playerName'] as String,
              playerPhoto: args['playerPhoto'] as String?,
              totalAttempts: args['totalAttempts'] as int,
            ),
          ),
        );

      case AppRoute.playerAttemptDetailScreen:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PlayerAttemptDetailScreen(
            attempt: args['attempt'] as PlayerAttempt,
            attemptIndex: args['attemptIndex'] as int,
            playerName: args['playerName'] as String,
            exerciseId: args['exerciseId'] as int,
          ),
        );

      // ========================================================================
      // SCOUT
      // ========================================================================
      case AppRoute.scoutSignUpScreen:
        return MaterialWithModalsPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // Scout registration is club-less — no ClubDirectoryCubit here.
              BlocProvider<RegistrationCubit>(
                create: (_) => getIt<ScoutRegistrationCubit>(),
              ),
              BlocProvider(create: (_) => getIt<TermsCubit>()..load()),
            ],
            child: RegistrationScreen(
              title: 'تسجيل كشاف'.tr(),
              requiresClub: false,
            ),
          ),
        );

      case AppRoute.scoutMainScreen:
        return _fadeTransitionRoute(const ScoutMainScreen());

      // ========================================================================
      // DEFAULT
      // ========================================================================
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  PageRouteBuilder _fadeTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
