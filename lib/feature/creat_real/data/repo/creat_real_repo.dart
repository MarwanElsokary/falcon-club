// import 'package:dio/dio.dart';
// import 'package:falconclubapp/core/helpers/constants.dart';
// import 'package:falconclubapp/core/networking/api_constants.dart';
// import 'package:falconclubapp/core/networking/api_result.dart';
//
// import '../../../../core/helpers/shared_pref_helper.dart';
// import '../../../../core/networking/api_error_handler.dart';
// import '../../../../core/networking/api_service.dart';
//
// class CreatRealRepo {
//   // ignore: unused_field
//   final ApiService _apiService;
//
//   CreatRealRepo(this._apiService);
//
//   //addReel
//   Future<ApiResult> addReel({
//     required FormData addReelBody,
//     required String description,
//     Function(int sent, int total)? onSendProgress,
//   }) async {
//     try {
//       final dio = Dio();
//
//       // إضافة headers
//       dio.options.headers = {
//         'Accept-Language': 'ar',
//         'Authorization':
//             'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
//         "Accept": "application/json",
//       };
//
//       // Logging all request & response
//       dio.interceptors.add(
//         LogInterceptor(
//           request: true,
//           requestBody: true,
//           responseBody: true,
//           responseHeader: true,
//           error: true,
//           logPrint: (obj) => print(obj),
//         ),
//       );
//
//       final response = await dio.post(
//         '${ApiConstants.apiBaseUrl}${ApiConstants.addReel}',
//         data: addReelBody,
//         queryParameters: {'Description': description},
//         onSendProgress: onSendProgress,
//       );
//
//       return ApiResult.success(response.data);
//     } catch (error) {
//       return ApiResult.failure(ErrorHandler.handle(error));
//     }
//   }
// }
