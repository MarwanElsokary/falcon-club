class ApiConstants {
  static const String apiBaseUrl = "https://falconai.net/api/";
  static const String storgeApis = "https://falconai.net";

  //mapKey
  static const String mapKey = "AIzaSyCSCPuaywN_flJUl2y6w5B6V4RMGxwTPNc";

  //auth
  //login
  static const String login = "Account/Login";
  static const String verifypay = "'Payment/VerifyPayment'";

  //Payment/CreatePayment
  static const String payPackage = "Payment/CreatePayment";

  //register
  static const String register = "Account/RegisterClub";

  //RegisterClubStep2
  static const String registerStep2 = "Account/RegisterClubStep2";

  //updateProfile
  static const String updateProfile = "Club/UpdateProfile";

  //otp
  static const String otp = "Account/ConfirmPhoneByOtp";

  //countries
  static const String countries = "Club/GetCountries";

  //ClubsByCountry
  static const String clubsByCountry = "Club/GetClubsByCountry";

  //myProfile
  static const String myProfile = "Club/GetProfile";

  //Payment/GetAllPackages
  static const String allPackages = "Payment/GetAllPackages";

  //profileById
  static const String profileById = "Club/GetPlayerProfileById";

  //rank
  static const String rank = "Club/GetTopPlayers";

  //reals
  static const String reals = "Club/GetReels";

  //ProfileFeature
  static const String profileFeature = "Club/PlayerProfileFeature";

  //toggleLikeReel
  static const String toggleLikeReel = "Club/ToggleLikeReel";

  //addComment
  static const String addComment = "Club/AddComment";

  //categories
  static const String categories = "Club/GetCategories";

  //Club/GetAllTrials
  static const String allTrials = "Club/GetAllTrials";

  //allExercises
  static const String allExercises = "Club/GetAllExercises";

  //trialDetails
  static const String trialDetails = "Club/GetTrial";

  //exerciseDetails
  static const String exerciseDetails = "Club/GetExercise";

  //addAttempt
  static const String addAttempt = "Club/AddAttempt";

  //addReel
  static const String addReel = "Club/AddReel";

  //club-specific endpoints
  static const String sendInvitation = "Club/SendInvitation";
  static const String getPlayersList = "Club/GetPlayersList";
  static const String getClubTeam = "Club/GetClubTeam";
  static const String addPlayerNote = "Club/AddPlayerNote";
  static const String getPlayerNotes = "Club/GetPlayerNotes";
  static const String createPlayerReport = "Club/CreatePlayerReport";
  static const String getPlayerReports = "Club/GetPlayerReports";
  static const String addPlayerToTeam = "Club/AddPlayerToTeam";
  static const String removePlayerFromTeam = "Club/RemovePlayerFromTeam";

  //send-verification-code
  static const String sendVerificationCode = "auth/send-otp";

  //verify-code
  static const String verifyCode = "auth/verify-otp";

  //
  static const String completeProfile = "auth/complete-profile";

  //auth/me
  static const String userData = "auth/me";

  //all areas
  static const String area = "areas";

  //all posts
  static const String posts = "posts";

  //allPlaces
  static const String places = "places";

  //guided-tours/place
  static const String placesTours = "guided-tours/place/";

  //restaurants
  static const String restaurants = "restaurants";

  //search restaurants
  static const String searchRestaurants = "restaurants/search";

  //reviews
  static const String reviews = "reviews";

  //activities
  static const String activities = "activities";

  //deletAccount
  static const String deleteAccount = "delete-account";
  static const String getTermsAndPolicies = "/Account/GetTermsAndPolicies";

  static const String forgetPasswordByPhone =
      '/Account/ForgetPasswordByOtpPhone';
  static const String checkOtp = '/Account/CheckOtp';
  static const String resetPassword = '/Account/ResetPassword';
  static const String allMeasurements = '/Account/ResetPassword';
  static const String measurementDetails = '/Account/ResetPassword';
  static const String addMeasurementAttempt = '/Account/ResetPassword';

}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String badResponseError = "badResponseError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
