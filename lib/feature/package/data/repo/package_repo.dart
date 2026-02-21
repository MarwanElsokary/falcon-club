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

  //getTermsAndPolicies
  Future<ApiResult> getTermsAndPolicies() async {
    try {
      final response = await _apiService.getTermsAndPolicies();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
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

  // دالة جديدة للتحقق من حالة الدفع بعد الـ verification
  Future<ApiResult> verifyPaymentStatus({required int packageId}) async {
    try {
      // استبدل هذا بالـ endpoint الصحيح من الباك اند
      final response = await _apiService.verifyPayment(packageId);
      return ApiResult.success(response);
    } catch (errro) {
      return ApiResult.failure(ErrorHandler.handle(errro));
    }
  }
}