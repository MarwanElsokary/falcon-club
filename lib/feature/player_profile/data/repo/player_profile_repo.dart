// import 'package:falcon/core/networking/api_result.dart';
//
// import '../../../../core/networking/api_error_handler.dart';
// import '../../../../core/networking/api_service.dart';
// import '../../../main_screen/data/model/my_profile_model.dart';
//
// class PlayerProfileRepo {
//   final ApiService _apiService;
//
//   PlayerProfileRepo(this._apiService);
//
//   //myProfile
//   Future<ApiResult<MyProfileModel>> profileById({
//     required String userId,
//   }) async {
//     try {
//       final response = await _apiService.profileById(userId);
//       return ApiResult.success(response);
//     } catch (errro) {
//       return ApiResult.failure(ErrorHandler.handle(errro));
//     }
//   }
// }
