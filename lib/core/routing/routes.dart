class AppRoute {
  static const String splashScreen = '/';

  static const String clubInfoScreen = '/clubInfoScreen';

  /// Exercise details — one screen for every role (Club, Scout, MainClub).
  ///
  /// Replaces the old `clubTrainingDetailsScreen` / `scoutTrainingDetailsScreen`
  /// pair. What a viewer may do on this screen is decided by the
  /// `ExerciseCapability` resolved at the route, not by which route was taken —
  /// so there is exactly one destination and no role-specific fork to keep in
  /// sync.
  static const String exerciseDetailsScreen = '/exerciseDetailsScreen';

  static const String resetPasswordScreen = '/resetPassword';
  static const String scoutMainScreen = '/scoutMainScreen';
  static const String mainClubScreen = '/mainClubScreen';
  static const String clubProfileScreen = '/clubMyTeamScreen';
  static const String requestsScreen = '/requestsScreen';
  static const String scoutTrainingScreen = '/scoutTrainingScreen';

  //forgetPasswordScreen
  static const String forgetPasswordScreen = '/forgotPasswordScreen';

  //SendOtp
  static const String sendOtp = '/sendOtp';

  //onboarding
  static const String onBoardingScreen = '/onBoardingScreen';

  //login
  static const String loginScreen = '/loginScreen';

  //registrationTypeScreen
  static const String registrationTypeScreen = '/registrationTypeScreen';

  //clubSignUpScreen
  static const String clubSignUpScreen = '/clubSignUpScreen';

  //clubMainScreen
  static const String clubMainScreen = '/clubMainScreen';

  static const String clubMyTeamScreen = '/ClubMyTeamScreen';

  /// Phone confirmation. One screen for every entry point — after registration,
  /// and from the login screen when an unconfirmed account tries to sign in.
  static const String otpScreen = '/otpScreen';

  //playerProfile
  static const String playerProfile = '/playerProfile';

  //mainRealsScreen
  static const String mainRealsScreen = '/mainRealsScreen';

  //trainingScreen
  static const String trainingScreen = '/trainingScreen';

  //experianceDetailsScreen
  static const String experianceDetailsScreen = '/experianceDetailsScreen';

  //rankScreen
  static const String rankScreen = '/rankScreen';

  //allExperimentScreen
  static const String allExperimentScreen = '/allExperimentScreen';

  //packageScreen
  static const String packageScreen = '/packageScreen';

  //packagePayMentScreen
  static const String packagePayMentScreen = '/packagePayMentScreen';

  // playerAttemptsScreen
  static const String playerAttemptsScreen = '/playerAttemptsScreen';

  // playerAttemptDetailScreen
  static const String playerAttemptDetailScreen = '/playerAttemptDetailScreen';

  // scoutSignUpScreen
  static const String scoutSignUpScreen = '/scoutSignUpScreen';
}