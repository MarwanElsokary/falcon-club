import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_constants.dart';
import 'package:falconclubapp/core/networking/api_error_handler.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/core/helpers/constants.dart';
import 'package:falconclubapp/core/helpers/shared_pref_helper.dart';

class ScoutRepo {
  final Dio _dio;

  ScoutRepo(this._dio);

  /// POST /api/Account/RegisterScout
  Future<ApiResult<Map<String, dynamic>>> registerScout({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required int gender,
    String? imagePath,
  }) async {
    try {
      final formMap = <String, dynamic>{
        'PlayerId': '1',
        'FirstName': firstName,
        'LastName': lastName,
        'Email': email,
        'PhoneNumber': phoneNumber,
        'Password': password,
        'Gender': gender,
      };

      if (imagePath != null && imagePath.isNotEmpty) {
        formMap['Photo'] = await MultipartFile.fromFile(imagePath);
      }

      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );

      final response = await _dio.post(
        '${ApiConstants.apiBaseUrl}Account/RegisterScout',
        data: FormData.fromMap(formMap),
        options: Options(
          headers: token.isNotEmpty
              ? {'Authorization': 'Bearer $token'}
              : null,
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return ApiResult.success(data);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}