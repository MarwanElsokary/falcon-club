class ApiConstants {
  static const String apiBaseUrl = "https://falconai.net/api/";
  static const String storgeApis = "https://falconai.net";

  /// CDN host for uploaded media (images, videos), distinct from the API host.
  ///
  /// Most media arrives **absolute** already — `photoPath` and an attempt's raw
  /// `video` come back as `https://files.fteet.ai/…`, which is why images and the
  /// raw video have always played. The exception is an attempt's `aiVideo`, which
  /// the backend sends **relative** (`Videos/HLS/AI/….m3u8`); it is resolved
  /// against this base (see `MediaUrl.resolve`). Confirmed as the stable
  /// production media host.
  static const String mediaBaseUrl = "https://files.fteet.ai/";

  //mapKey
  static const String mapKey = "AIzaSyCSCPuaywN_flJUl2y6w5B6V4RMGxwTPNc";

  //auth
  static const String login = "Account/LoginClub";
  static const String verifypay = "'Payment/VerifyPayment'";

  //Payment/CreatePayment
  static const String payPackage = "Payment/CreatePayment";

  //register
  static const String register = "Account/RegisterPlayer";

  //registerClub
  static const String registerClub = "Account/RegisterClub";

  //registerScout
  static const String registerScout = "Account/RegisterScout";
  static const String toggleFavPlayer = "Club/ToggleFavPlayer";

  //clubUpdateProfile
  static const String clubUpdateProfile = "Club/UpdateProfile";

  //clubGetPlayers
  static const String clubGetPlayers = "Club/GetPlayersByClub";

  //clubGetProfile
  static const String clubGetProfile = "Club/GetProfile";

  //RegisterPlayerStep2
  static const String registerStep2 = "Account/RegisterPlayerStep2";

  //register
  static const String updateProfile = "Player/UpdateProfile";

  //otp
  static const String otp = "Account/ConfirmPhoneByOtp";

  // Phone confirmation. Both authenticate via the Bearer token issued by
  // RegisterClub/RegisterScout — they take no phone number and no user id,
  // because the backend resolves the account from that token.
  static const String confirmPhoneByOtp = "Account/ConfirmPhoneByOtp";
  static const String resendPhoneOtp = "Account/ResendPhoneOtp";

  //countries
  static const String countries = "Player/GetCountries";

  //ClubsByCountry
  static const String clubsByCountry = "Player/GetClubsByCountry";

  //myProfile
  static const String myProfile = "Club/GetProfile";
  static const String clubProfile = "Club/GetProfile";

  //Payment/GetAllPackages
  static const String allPackages = "Payment/GetAllPackages";

  //
  static const String profileById = "Player/GetProfileById";

  // One entry per distinct exercise a player has completed (bookings = count).
  static const String getPlayerExercises = "Player/GetPlayerExercises";

  //
  static const String rank = "Player/GetRankingExercise";

  static const String getClubRequests = 'Club/GetClubRequests';
  static const String getPlayerRequests = 'Club/GetPlayerRequests';

  // Club Requests
  static const String acceptClub = '/Club/AcceptClub';
  static const String rejectClub = '/Club/RejectClub';
  static const String deleteClub = '/Club/DeleteClub';

  // Player Requests
  static const String acceptPlayer = '/Player/AcceptPlayer';
  static const String rejectPlayer = '/Player/RejectPlayer';
  static const String deletePlayer = '/Player/DeletePlayer';

  //reals
  static const String reals = "Player/GetReels";

  //getReelsByPlayerId
  static const String getReelsByPlayerId = "Player/GetReels";

  //getFav
  static const String getFav = "Club/GetFavPlayers";

  //ProfileFeature
  static const String profileFeature = "Player/ProfileFeature";

  //toggleLikeReel
  static const String toggleLikeReel = "Player/ToggleLikeReel";

  //addComment
  static const String addComment = "Player/AddComment";

  // Reel + comment editing. Paths follow the established Player/<Verb><Noun>
  // convention used by AddComment / ToggleLikeReel / AddReel above.
  static const String updateReel = "Player/UpdateReel";
  static const String deleteReel = "Player/DeleteReel";
  static const String updateComment = "Player/UpdateComment";
  static const String deleteComment = "Player/DeleteComment";

  //categories
  static const String categories = "Player/GetCaregories";

  //Player/GetAllTrials
  static const String allTrials = "club/GetAllTrials";

  //allExercises
  static const String allExercises = "club/GetAllExercises";

  //trialDetails
  static const String trialDetails = "club/GetTrial";

  //exerciseDetails
  static const String exerciseDetails = "club/GetExercise";

  //addAttempt
  static const String addAttempt = "Player/AddAttempt";

  //clubAddAttempt
  static const String clubAddAttempt = "Club/AddAttempt";

  /// A player's attempts on one exercise. Scoped to the caller's own team by
  /// the bearer token — it takes no club id, and must not grow one.
  static const String clubGetPlayerAttempts = "Club/GetPlayerAttempts";

  //
  static const String addReel = "Player/AddReel";

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

/// Human-readable fallbacks, shown ONLY when the backend/exception provides no
/// real message of its own (see `ErrorHandler`). They used to be literal keys
/// ("noInternetError", "defaultError", …) that were displayed verbatim — so a
/// user could actually see the text "noInternetError" on screen.
class ApiErrors {
  static const String badRequestError = "الطلب غير صحيح";
  static const String noContent = "لا يوجد محتوى";
  static const String forbiddenError = "ليس لديك صلاحية للوصول";
  static const String unauthorizedError = "انتهت الجلسة، سجّل الدخول من جديد";
  static const String badResponseError = "استجابة غير متوقعة من الخادم";
  static const String notFoundError = "لم يتم العثور على البيانات";
  static const String conflictError = "تعارض في البيانات";
  static const String internalServerError = "خطأ في الخادم، حاول لاحقًا";
  static const String unknownError = "حدث خطأ غير متوقع";
  static const String timeoutError = "انتهت مهلة الاتصال، حاول مجددًا";
  static const String defaultError = "حدث خطأ ما، حاول مرة أخرى";
  static const String cacheError = "خطأ في البيانات المخزّنة";
  static const String noInternetError = "تعذّر الاتصال بالإنترنت";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
