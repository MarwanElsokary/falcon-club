import '../../feature/exercise/presentation/cubit/exercise_list_cubit.dart';
import '../../feature/exercise/presentation/screens/exercise_list_screen.dart';
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
import '../../feature/player_profile/presentation/screen/player_profile_screen.dart';
import '../../feature/all_experiment/ui/screen/all_experiment_screen.dart';
import '../../feature/club_team/ui/screen/club_my_team_screen.dart';
import '../../feature/favorites/presentation/cubit/player_favorite_cubit.dart';
import '../../feature/profile/presentation/cubit/completed_exercises_cubit.dart';
import '../../feature/profile/presentation/cubit/player_profile_cubit.dart';
import '../../feature/profile/presentation/cubit/profile_cubit.dart';
import '../../feature/profile/presentation/cubit/profile_edit_cubit.dart';
import '../../feature/profile/presentation/screens/coach_profile_screen.dart';
import '../../feature/profile/presentation/screens/scout_profile_screen.dart';
import '../../feature/profile/presentation/screens/main_club_profile_screen.dart';
import '../../feature/exercise/presentation/cubit/exercise_details_cubit.dart';
import '../../feature/trial_details/cubit/trial_details_cubit.dart';
import '../../feature/trial_details/ui/screen/trial_details_screen.dart';
import '../../feature/experiments/cubit/experiments_cubit.dart';
import '../../feature/auth/presentation/cubit/sign_in_cubit.dart';
import '../../feature/auth/presentation/screens/sign_in_screen.dart';
import '../../feature/main_club/cubit/requests_cubit.dart';
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
import '../../feature/auth/presentation/screens/registration_type_screen.dart';
import '../../feature/club_team/cubit/club_team_cubit.dart';
import '../../feature/club_team/ui/screen/club_main_screen.dart';
import '../../feature/scout/ui/screen/scout_main_screen.dart';
import '../../feature/splash_screen/splash_screen.dart';
import '../../feature/exercise/presentation/screens/exercise_details_screen.dart';
import '../../feature/exercise/domain/repositories/viewer_capability_port.dart';
import '../../feature/player_attempts/cubit/player_attempts_cubit.dart';
import '../../shared/domain/entities/attempt.dart';
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
          builder: (_) => MultiBlocProvider(
            providers: [
              // Display via the domain ProfileCubit; edit via the domain
              // ProfileEditCubit (Phase 3). Both live entirely in the profile
              // feature now — the coach profile no longer touches ClubTeamCubit.
              BlocProvider(create: (_) => getIt<ProfileCubit>()..load()),
              BlocProvider(create: (_) => getIt<ProfileEditCubit>()),
            ],
            child: const CoachProfileScreen(),
          ),
        );

      case AppRoute.scoutProfileScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              // Same domain stack as the coach profile — Scout uses the same
              // Club/GetProfile + Club/UpdateProfile backend.
              BlocProvider(create: (_) => getIt<ProfileCubit>()..load()),
              BlocProvider(create: (_) => getIt<ProfileEditCubit>()),
            ],
            child: const ScoutProfileScreen(),
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
            create: (_) => getIt<ProfileCubit>()..load(),
            child: const MainClubProfileScreen(),
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
              // Profile display via the domain PlayerProfileCubit (Phase 4).
              BlocProvider(
                create: (_) => getIt<PlayerProfileCubit>()..load(playerId),
              ),
              // Favourite heart (Phase 6): resolves membership + toggles.
              BlocProvider(
                create: (_) => getIt<PlayerFavoriteCubit>()..load(playerId),
              ),
              // Completed-exercises section (التمارين المنجزة).
              BlocProvider(
                create: (_) =>
                    getIt<CompletedExercisesCubit>()..load(playerId),
              ),
              // MainCubit stays for the skills radar + the (dormant) favourite
              // toggle; skills is triggered lazily by the screen once the
              // profile loads, so there is no emitProfileById here.
              BlocProvider(create: (_) => getIt<MainCubit>()),
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
      // ── قائمة التمارين — شاشة واحدة لكل الأدوار ──────────────────────────
      // Both routes render the SAME list screen with the SAME cubit, and now a
      // tapped exercise leads to the SAME details route for every role — the
      // Club and Scout detail screens merged in Phase 4. The two list routes
      // remain only because each role's shell links to its own.
      case AppRoute.trainingScreen:
      case AppRoute.scoutTrainingScreen:
        return MaterialPageRoute(builder: (_) => _exerciseList());

      // ── شاشة تفاصيل التمرين — شاشة واحدة لكل الأدوار ──────────────────────
      // One screen for Club, Scout and MainClub. The viewer's
      // `ExerciseCapability` — resolved here, once, from the stored role and
      // subscription — decides what the screen offers (upload vs view, paywall
      // or not). The screen itself contains no role check, so every entry point
      // that lands here is governed by the same rule.
      case AppRoute.exerciseDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final exerciseId = args['exerciseId'] as String;
        final capability = getIt<ViewerCapabilityPort>().current();

        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<ExerciseDetailsCubit>()..load(exerciseId),
            child: ExerciseDetailsScreen(capability: capability),
          ),
        );

      // ========================================================================
      // TRIAL DETAILS
      // ========================================================================
      case AppRoute.trialDetailsScreen:
        final args = arguments as Map<String, dynamic>;
        final heroTag = args['heroTag'] as String;
        final trialImage = args['trialImage'] as String;
        final trialId = args['trialId'] as String;
        final title = args['title'] as String;

        return _fadeTransitionRoute(
          BlocProvider(
            create: (_) => getIt<TrialDetailsCubit>()..load(trialId),
            child: TrialDetailsScreen(
              title: title,
              heroTag: heroTag,
              trialImage: trialImage,
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
              exerciseId: args['exerciseId'] as String,
              playerId: args['playerId'] as String,
              playerName: args['playerName'] as String,
              playerPhoto: args['playerPhoto'] as String?,
              // Coerced tolerantly rather than cast: the count crosses a
              // `dynamic` arg map, so `7`, `7.0` and `"7"` must all survive.
              totalAttempts: switch (args['totalAttempts']) {
                final int n => n,
                final num n => n.toInt(),
                final String s => int.tryParse(s) ?? 0,
                _ => 0,
              },
            ),
          ),
        );

      case AppRoute.playerAttemptDetailScreen:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PlayerAttemptDetailScreen(
            attempt: args['attempt'] as Attempt,
            attemptIndex: args['attemptIndex'] as int,
            playerName: args['playerName'] as String,
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

  /// The exercise list — one screen for every role.
  ///
  /// One screen, one cubit, one endpoint, one details destination. Since the
  /// detail screens merged in Phase 4 the role no longer decides where a tapped
  /// exercise leads, so there is nothing role-specific to pass in.
  /// [MainCubit] is still the owner of the category chips, app-wide.
  Widget _exerciseList() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ExerciseListCubit>()..loadAll()),
        BlocProvider(create: (_) => getIt<MainCubit>()..emitCategories()),
      ],
      child: const ExerciseListScreen(),
    );
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
