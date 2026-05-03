import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helpers/constants.dart';
import '../helpers/shared_pref_helper.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;
  static bool isRefreshing = false;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = const Duration(seconds: 30)
        ..options.receiveTimeout = const Duration(seconds: 30)
        ..options.headers = {
          'Accept-Language': 'ar',
          'Accept': 'application/json',
        };

      _addTokenInterceptor();   // ← بيجيب الـ token قبل كل request
      addDioInterceptor();
      addTokenRefreshInterceptor();
    }
    return dio!;
  }

  // ─── Token Interceptor (الحل الجديد) ────────────────────────────────────────
  // بدل ما نحط الـ token مرة واحدة وقت الـ init (وهو مش موجود بعد)،
  // بنجيبه من الـ SecureStorage قبل كل request تلقائياً.
  static void _addTokenInterceptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPrefHelper.getSecuredString(
            SharedPrefKeys.userToken,
          );
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // ─── بعد اللوجين مباشرةً — بنحدث الـ header فوراً بدون ما ننتظر request ──
  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers['Authorization'] = 'Bearer $token';
    log('✅ Token set in Dio headers after login');
  }

  // ─── Logger ─────────────────────────────────────────────────────────────────
  static void addDioInterceptor() {
    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: false),
      );
    }
  }

  // ─── Token Refresh (401) ────────────────────────────────────────────────────
  static void addTokenRefreshInterceptor() {
    dio?.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && !isRefreshing) {
            isRefreshing = true;
            try {
              final newToken = await refreshToken();
              isRefreshing = false;
              if (newToken != null) {
                setTokenIntoHeaderAfterLogin(newToken);

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
              isRefreshing = false;
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<String?> refreshToken() async {
    try {
      final storedRefreshToken = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.refreshToken,
      );
      final response = await dio!.post(
        'http://ec2-3-91-38-73.compute-1.amazonaws.com/api/driver/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer $storedRefreshToken'},
        ),
      );
      if (response.statusCode == 200) {
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];
        log('newToken: $newAccessToken');
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

  // ─── deprecated — متبقاش تستخدمها ──────────────────────────────────────────
  @Deprecated('Use _addTokenInterceptor instead — token is now set per-request')
  static void addDioHeaders() async {
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  @Deprecated('Use _addTokenInterceptor instead')
  static void addLangDioHeaders() => addDioHeaders();
}