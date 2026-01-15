import 'package:dio/dio.dart';
import 'package:falcon/feature/experiance_details_screen/data/model/trial_details_model.dart';
import 'package:falcon/feature/experiments/data/model/all_trials_model.dart';
import 'package:falcon/feature/login/data/model/country_model.dart';
import 'package:falcon/feature/main_screen/data/model/categories_model.dart';
import 'package:falcon/feature/reals/data/model/real_model.dart';
import 'package:falcon/feature/training_details/data/model/exercise_details_model.dart';

import 'package:retrofit/retrofit.dart';

import '../../feature/forget_password/data/model/forget_password_model.dart';
import '../../feature/main_screen/data/model/my_profile_model.dart';
import '../../feature/player_profile/data/model/profile_feat.dart';
import '../../feature/rank/data/model/rank_model.dart';
import '../../feature/training/data/model/all_exercises_model.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  //login

  @POST(ApiConstants.login)
  Future login(@Body() loginBody);

  //register
  @POST(ApiConstants.register)
  Future register(@Body() registerBody);

  //register step 2
  @POST(ApiConstants.registerStep2)
  Future completeRegistration(@Body() FormData body);

  //update
  @PUT(ApiConstants.updateProfile)
  Future updateProfile(@Body() updateProfileBody);

  //otp
  @POST(ApiConstants.otp)
  Future otp(@Query('otp') int otp);

  //Player/GetCountries
  @GET(ApiConstants.countries)
  Future<CountriesClubModel> countries();

  //clubsByCountry
  @GET(ApiConstants.clubsByCountry)
  Future<CountriesClubModel> clubsByCountry(
    @Query('CountryId') String countryId,
  );

  //myProfile
  @GET(ApiConstants.myProfile)
  Future<MyProfileModel> myProfile();

  @GET(ApiConstants.allPackages)
  Future allPackages();

  //
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

  //delete account
  @DELETE(ApiConstants.deleteAccount)
  Future deleteAccount();

  //ProfileFeature
  // ProfileFeature
  @GET(ApiConstants.profileFeature)
  Future<SkillsResponse> getSkills(@Query('UserId') String userId);

  // Forget Password Endpoints
  @POST(ApiConstants.forgetPasswordByPhone)
  Future<ForgetPasswordResponse> forgetPasswordByPhone(
    @Query('phoneNumber') String phoneNumber,
  );

  @POST(ApiConstants.checkOtp)
  @FormUrlEncoded()
  Future<CheckOtpResponse> checkOtp(
    @Field('otp') String otp,
    @Field('phoneNumber') String phoneNumber,
  );

  @POST(ApiConstants.resetPassword)
  @FormUrlEncoded()
  Future<ResetPasswordResponse> resetPassword(
    @Field('Token') String token,
    @Field('Password') String password,
    @Field('ConfirmPassword') String confirmPassword,
  );
}
