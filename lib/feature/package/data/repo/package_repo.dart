import 'package:falcon/core/networking/api_result.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';

class PackageRepo {
  final ApiService _apiService;

  PackageRepo(this._apiService);

  //myProfile
  Future<ApiResult> allPackages() async {
    try {
      final response = await _apiService.allPackages();
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }

  //payPackage
  Future<ApiResult> payPackage({required payPackageBody}) async {
    try {
      final response = await _apiService.payPackage(payPackageBody);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}
