import 'dart:developer';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../model/forget_password_model.dart';

class ForgetPasswordRepo {
  final ApiService _apiService;

  ForgetPasswordRepo(this._apiService);

  // 1. Send OTP
  Future<ApiResult<ForgetPasswordResponse>> sendOtp(String phoneNumber) async {
    try {
      log('Sending OTP to: $phoneNumber');
      final response = await _apiService.forgetPasswordByPhone(phoneNumber);
      return ApiResult.success(response);
    } catch (error) {
      log('Error in sendOtp: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // 2. Verify OTP
  Future<ApiResult<CheckOtpResponse>> verifyOtp({
    required String otp,
    required String phoneNumber,
  }) async {
    try {
      log('Verifying OTP: otp=$otp, phoneNumber=$phoneNumber');

      final response = await _apiService.checkOtp(otp, phoneNumber);

      log('Raw OTP verification response: ${response.toString()}');
      log('Response message: ${response.message}');
      log('Response resetToken: ${response.resetToken}');

      return ApiResult.success(response);
    } catch (error) {
      log('Error in verifyOtp: $error');
      log('Error stack trace: ${error.toString()}');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // 3. Reset Password
  Future<ApiResult<ResetPasswordResponse>> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      log('Resetting password with FormData - Token: $token, Password: $password, ConfirmPassword: $confirmPassword');

      final response = await _apiService.resetPassword(
        token,  // Token
        password,  // Password
        confirmPassword,  // ConfirmPassword
      );

      log('Reset password response: $response');
      return ApiResult.success(response);
    } catch (error) {
      log('Error in resetPassword: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}