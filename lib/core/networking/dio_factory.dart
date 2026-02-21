import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helpers/constants.dart';
import '../helpers/shared_pref_helper.dart';

class DioFactory {
  /// Private constructor
  DioFactory._();

  static Dio? dio;
  static bool isRefreshing = false;


  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders();
      addDioInterceptor();
      addTokenRefreshInterceptor(); // Add token refresh interceptor
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeaders() async {
    dio?.options.headers = {
      'Accept-Language': 'ar',
      'Authorization':
          'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
      "Accept": "application/json",
    };
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      'Accept-Language': 'ar',
      'Authorization': 'Bearer $token',
      "Accept": "application/json",
    };
  }

  static void addLangDioHeaders() async {
    dio?.options.headers = {
      'Accept-Language': 'ar',
      'Authorization':
          'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
      "Accept": "application/json",
    };
  }

  static void addDioInterceptor() {
    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: false,
        ),
      );
    }

  }

  /// Add token refresh interceptor
  static void addTokenRefreshInterceptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Check if the error is due to an unauthorized request (token expired)
          if (error.response?.statusCode == 401 && !isRefreshing) {
            isRefreshing = true;
            try {
              final newToken = await refreshToken();
              isRefreshing = false;
              if (newToken != null) {
                // Update the header with the new token
                setTokenIntoHeaderAfterLogin(newToken);

                // Retry the original request with the new token
                final options = error.response!.requestOptions;
                options.headers['Authorization'] = 'Bearer $newToken';
                final response = await dio!.request(
                  options.path,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                );
                return handler.resolve(response);
              }
            } catch (e) {
              // If token refresh fails, propagate the error
              isRefreshing = false;
              return handler.reject(error);            }
          }
          // Propagate other errors
          return handler.next(error);
        },
      ),
    );
  }

  /// Function to refresh the token
  static Future<String?> refreshToken() async {
    try {
      final refreshToken = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.refreshToken,
      );
      final response = await dio!.post(
        'http://ec2-3-91-38-73.compute-1.amazonaws.com/api/driver/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];
        log('newToken$newAccessToken');
        log('newRefreshToken$newRefreshToken');

        // Save the new tokens to secure storage
        await SharedPrefHelper.setSecuredString(
          SharedPrefKeys.userToken,
          newAccessToken,
        );
        await SharedPrefHelper.setSecuredString(
          SharedPrefKeys.refreshToken,
          newRefreshToken,
        );

        return newAccessToken;
      }
    } catch (e) {
      log('Failed to refresh token: $e');
    }
    return null;
  }
}
