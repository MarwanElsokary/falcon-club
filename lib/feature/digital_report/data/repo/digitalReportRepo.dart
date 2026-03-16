import 'package:dio/dio.dart';
import 'package:falcon/core/helpers/constants.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
import 'package:falcon/core/networking/api_constants.dart';
import 'package:falcon/core/networking/api_error_handler.dart';
import 'package:falcon/core/networking/api_result.dart';
import '../model/digitalReportModel.dart';

class DigitalReportRepo {
  final Dio _dio;

  DigitalReportRepo(this._dio);

  Future<Map<String, dynamic>> _authHeaders() async {
    final token =
    await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  /// GET /api/Club/PlayerDigitalReports?playerId=xxx
  Future<ApiResult<List<DigitalReportSummary>>> getReports(
      String playerId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.apiBaseUrl}Club/PlayerDigitalReports',
        queryParameters: {'playerId': playerId},
        options: Options(headers: await _authHeaders()),
      );
      final data = response.data;
      if (data is List) {
        final reports = data
            .map((e) =>
            DigitalReportSummary.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResult.success(reports);
      }
      return const ApiResult.success([]);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  /// POST /api/Club/AddDigitalReport
  Future<ApiResult<void>> addReport(
      CreateDigitalReportRequest request) async {
    try {
      await _dio.post(
        '${ApiConstants.apiBaseUrl}Club/AddDigitalReport',
        data: request.toJson(),
        options: Options(headers: await _authHeaders()),
      );
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}