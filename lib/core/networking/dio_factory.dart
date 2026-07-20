
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../helpers/constants.dart';
import '../helpers/shared_pref_helper.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

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

      _addTokenInterceptor(); // ← بيجيب الـ token قبل كل request
      addDioInterceptor();
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

  // ─── Logger ─────────────────────────────────────────────────────────────────
  static void addDioInterceptor() {
    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true),
      );
    }
  }

  // ─── No token refresh ───────────────────────────────────────────────────────
  //
  // There was a 401 interceptor here that tried to refresh the token. It could
  // never work, and was not merely pointed at the wrong URL:
  //
  //   * This backend exposes no refresh endpoint. The Account controller has
  //     login, registration, OTP and password-reset — nothing else.
  //   * Login never issues a refresh token. LoginResponseModel carries a single
  //     `token` (the JWT); there is no refresh field to store.
  //   * Nothing ever wrote one, so the stored value was always empty.
  //
  // It POSTed that empty value as `Bearer null`, over cleartext http, to
  // `ec2-3-91-38-73.compute-1.amazonaws.com/api/driver/refresh` — a third-party
  // host belonging to an unrelated *driver* app, along with its snake_case
  // `data.access_token` response shape. So every 401 in the app produced an
  // outbound plaintext request to a machine we do not control, then failed
  // anyway.
  //
  // A 401 now surfaces immediately as an ordinary error: `ErrorHandler` maps it
  // through `_serverMessageOr`, so the caller receives the backend's own message
  // when it sends one and a generic auth failure otherwise, and the screen that
  // made the request shows it. Note this is *not* a session-expiry flow — the
  // stored session is left untouched and the user is not redirected. Adding that
  // needs a global navigator (none exists) and a policy for which 401s mean
  // "session dead" rather than "not permitted"; see the accompanying report.

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
