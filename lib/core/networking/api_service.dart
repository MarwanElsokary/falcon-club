import 'package:dio/dio.dart';
import 'package:falconclubapp/feature/experiance_details_screen/data/model/trial_details_model.dart';
import 'package:falconclubapp/feature/experiments/data/model/all_trials_model.dart';
import 'package:falconclubapp/feature/main_screen/data/model/categories_model.dart';
import 'package:falconclubapp/feature/reals/data/model/real_model.dart';
import 'package:falconclubapp/feature/training_details/data/model/exercise_details_model.dart';

import 'package:retrofit/retrofit.dart';

import '../../feature/main_screen/data/model/club_profile_model.dart';
import '../../feature/main_screen/data/model/my_profile_model.dart';
import '../../feature/main_screen/data/repo/main_repo.dart';
import '../../feature/rank/data/model/rank_model.dart';
import '../../feature/training/data/model/all_exercises_model.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  //login

  @POST(ApiConstants.registerStep2)
  Future<dynamic> getCurrentUser();

  @GET('/Club/GetClubTrainees')
  Future<dynamic> getClubTrainees();

  @DELETE('/Club/DeletePlayer')
  Future<dynamic> deleteTrainee(@Query('PlayerId') String playerId);

  // أضف هذه الدالة للتحقق من الدفع بعد 3DS
  @POST(ApiConstants.verifypay) // تأكد من المسار الصحيح
  Future<dynamic> verifyPayment(@Body() int packageId);

  @POST(ApiConstants.login)
  Future login(@Body() loginBody);

  //register
  @POST(ApiConstants.register)
  Future register(@Body() registerBody);

  //registerClub
  @POST(ApiConstants.registerClub)
  Future registerClub(@Body() FormData body);

  //registerScout
  @POST(ApiConstants.registerScout)
  Future registerScout(@Body() FormData body);

  //clubUpdateProfile
  @PUT(ApiConstants.clubUpdateProfile)
  Future clubUpdateProfile(@Body() FormData body);

  //clubGetPlayers
  @GET(ApiConstants.clubGetPlayers)
  Future clubGetPlayers();

  //clubGetProfile
  @GET(ApiConstants.clubGetProfile)
  Future clubGetProfile();

  @GET(ApiConstants.getReelsByPlayerId)
  Future<dynamic> getPlayerReports(String playerId);

  // endpoint: GET /api/reports/player/{playerId}  ← عدّل حسب الـ API بتاعك

  //getReelsByPlayerId
  @GET(ApiConstants.getReelsByPlayerId)
  Future<dynamic> getReelsByPlayerId();

  //addToFav
  @POST(ApiConstants.addToFav)
  Future<dynamic> addToFav(@Query("playerId") String playerId);

  //removeFromFav
  @DELETE(ApiConstants.removeFromFav)
  Future<dynamic> removeFromFav(@Query("playerId") String playerId);

  //GetFavPlayers
  @GET(ApiConstants.getFav)
  Future<dynamic> getFav();

  //register step 2
  @POST(ApiConstants.registerStep2)
  Future completeRegistration(@Body() FormData body);

  //update
  @PUT(ApiConstants.updateProfile)
  Future updateProfile(@Body() updateProfileBody);

  //otp
  @POST(ApiConstants.otp)
  Future otp(@Query('otp') int otp);

  // ── Phone confirmation ────────────────────────────────────────────────────
  // The Authorization header is passed EXPLICITLY, not left to DioFactory's
  // interceptor. That interceptor only attaches the *session* token
  // (`userToken`), and these calls are made with the *registration* token —
  // which is deliberately never stored as a session. Passing it here keeps the
  // registration credential from having to masquerade as one.
  //
  // `otp` is a STRING. Sending it as an int (as `otp()` above does) destroys a
  // leading zero: int.parse("012345") == 12345, so the wrong code goes out.
  @POST(ApiConstants.confirmPhoneByOtp)
  Future<dynamic> confirmPhoneByOtp(
    @Header('Authorization') String bearer,
    @Query('otp') String otp,
  );

  @POST(ApiConstants.resendPhoneOtp)
  Future<dynamic> resendPhoneOtp(@Header('Authorization') String bearer);

  // أضف في قسم الـ GET endpoints في ApiService
  @GET(ApiConstants.getTermsAndPolicies)
  Future getTermsAndPolicies();

  // ── City / club directory ─────────────────────────────────────────────────
  // Declared as `dynamic`, like most of this class. The typed `CountriesClubModel`
  // these used to return lived in `feature/login`, so `core` depended on a
  // feature — backwards, and it kept a deleted feature alive. `CityModel` /
  // `ClubOptionModel` parse the raw body under `feature/auth/data` instead,
  // which is where knowledge of the wire shape belongs.
  @GET(ApiConstants.countries)
  Future<dynamic> countries();

  @GET(ApiConstants.clubsByCountry)
  Future<dynamic> clubsByCountry(@Query('CountryId') String countryId);

  //myProfile
  @GET(ApiConstants.myProfile)
  Future<MyProfileModel> myProfile();

  @POST(ApiConstants.toggleFavPlayer)
  Future<ToggleFavResponse> toggleFavPlayer(
    @Query('PlayerId') String playerId,
    // ← لو Retrofit
  );

  //myProfile
  @GET(ApiConstants.clubProfile)
  Future<ClubProfileModel> clubProfile();

  @GET(ApiConstants.allPackages)
  Future allPackages();

  @GET(ApiConstants.getClubRequests)
  Future<dynamic> getClubRequests();

  //
  @GET(ApiConstants.getPlayerRequests)
  Future<dynamic> getPlayerRequests();

  @PUT(ApiConstants.acceptClub)
  Future<dynamic> acceptClub(@Query('ClubId') String clubId);

  @PUT(ApiConstants.rejectClub)
  Future<dynamic> rejectClub(@Query('ClubId') String clubId);

  @DELETE(ApiConstants.deleteClub)
  Future<dynamic> deleteClub(@Query('ClubId') String clubId);

  @PUT(ApiConstants.acceptPlayer)
  Future<dynamic> acceptPlayer(@Query('PlayerId') String playerId);

  @PUT(ApiConstants.rejectPlayer)
  Future<dynamic> rejectPlayer(@Query('PlayerId') String playerId);

  @DELETE(ApiConstants.deletePlayer)
  Future<dynamic> deletePlayer(@Query('PlayerId') String playerId);

  @POST(ApiConstants.payPackage)
  Future payPackage(@Body() payPackageBody);

  //myProfile
  @GET(ApiConstants.profileById)
  Future<MyProfileModel> profileById(@Query('UserId') String userId);

  //rank
  @GET(ApiConstants.rank)
  Future<RankModel> rank();

  //real
  @GET(ApiConstants.reals)
  Future<RealModel> reals(
    @Query('pageNumber') String pageNumber,
    @Query('pageSize') String pageSize,
    @Query('playerId') String playerId,
  );

  //toggleLikeReel
  @POST(ApiConstants.toggleLikeReel)
  Future toggleLikeReel(@Query('ReelId') int reelId);

  //addComment
  @POST(ApiConstants.addComment)
  Future addComment(
    @Query('ReelId') int reelId,
    @Query('Comment') String comment,
  );

  //categories
  @GET(ApiConstants.categories)
  Future<CategoriesModel> categories();

  //allTrials
  @GET(ApiConstants.allTrials)
  Future<AllTrialsModel> allTrials(
    @Query('CategoryId') String categoryId,
    @Query('Popular') String popular,
  );

  //allExercises
  @GET(ApiConstants.allExercises)
  Future<AllExercisesModel> allExercises(
    @Query('CategoryId') String categoryId,
    @Query('Popular') String popular,
  );

  //trialDetails
  @GET(ApiConstants.trialDetails)
  Future<TrialDetailsModel> trialDetails(@Query('TrialId') String trialId);

  //trialDetails
  @GET(ApiConstants.exerciseDetails)
  Future<ExerciseDetailsModel> exerciseDetails(
    @Query('ExerciseId') String exerciseId,
  );

  @POST(ApiConstants.addAttempt)
  Future addAttempt(
    @Body() addAttemptBody,
    @Query('ExerciseId') String exerciseId,
  );

  // POST /api/Club/AddAttempt — المدرب يرفع فيديو للاعب
  @POST(ApiConstants.clubAddAttempt)
  Future clubAddAttempt(
    @Body() FormData body,
    @Query('PlayerId') String playerId,
    @Query('ExerciseId') int exerciseId,
  );

  //delete account
  @DELETE(ApiConstants.deleteAccount)
  Future deleteAccount();

  //ProfileFeature
  // ProfileFeature
  @GET(ApiConstants.profileFeature)
  Future<SkillsResponse> getSkills(@Query('UserId') String userId);

  // ── Password reset ────────────────────────────────────────────────────────
  // Also `dynamic` now. The freezed models these returned declared `message` and
  // `resetToken` **non-nullable and required**: a response missing either threw a
  // `TypeError` out of `fromJson` and the user saw a crash instead of the
  // server's own error text. The replacements in
  // `feature/auth/data/models/password_reset_models.dart` treat every field as
  // optional, so a shape change degrades into a clean failure.
  @POST(ApiConstants.forgetPasswordByPhone)
  Future<dynamic> forgetPasswordByPhone(
    @Query('phoneNumber') String phoneNumber,
  );

  @POST(ApiConstants.checkOtp)
  @FormUrlEncoded()
  Future<dynamic> checkOtp(
    @Field('otp') String otp,
    @Field('phoneNumber') String phoneNumber,
  );

  @POST(ApiConstants.resetPassword)
  @FormUrlEncoded()
  Future<dynamic> resetPassword(
    @Field('Token') String token,
    @Field('Password') String password,
    @Field('ConfirmPassword') String confirmPassword,
  );
}
