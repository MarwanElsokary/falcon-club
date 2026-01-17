import 'package:dio/dio.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../model/MeasurementModel.dart';

class MeasurementRepo {
  Future<ApiResult<MeasurementModel>> uploadMeasurementImage({
    required FormData formData,
    required String userId,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final dio = Dio();

      // Add headers
      dio.options.headers = {
        'Accept-Language': 'ar',
        'Authorization':
        'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
        "Accept": "application/json",
      };

      // Logging
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          logPrint: (obj) => print(obj),
        ),
      );

      final response = await dio.post(
        '${ApiConstants.apiBaseUrl}Dashboard/UploadMeasurementImage',
        data: formData,
        queryParameters: {'Id': userId},
        onSendProgress: onSendProgress,
      );

      final measurement = MeasurementModel.fromJson(response.data);
      return ApiResult.success(measurement);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}