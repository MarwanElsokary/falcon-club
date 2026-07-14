import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'exceptions.dart';
import 'failure_messages.dart';
import 'failures.dart';
import 'http_status.dart';

/// Translates transport-level errors into domain-level [Failure]s.
///
/// SRP: this class exists for exactly one reason — to know how Dio (and
/// dart:io) express errors and how the domain expresses them. It is the *only*
/// place in the app that imports both `package:dio` and `failures.dart`.
///
/// DIP in practice: because this translation is isolated here, the domain never
/// learns that Dio exists. Replacing the HTTP client means rewriting this one
/// file, not 22 repositories.
///
/// OCP: dispatch is by type (`switch` on the sealed [AppException] / on
/// [DioExceptionType]) rather than by string-matching error text, so new error
/// kinds are added by extending the switch, not by editing every caller.
@lazySingleton
class ErrorMapper {
  const ErrorMapper();

  /// Single entry point. Accepts anything caught in a `catch (error)` and
  /// always yields a [Failure] — never rethrows, never returns null.
  Failure map(Object error) => switch (error) {
    AppException() => _fromAppException(error),
    DioException() => _fromDioException(error),
    SocketException() => const NetworkFailure(),
    _ => const UnknownFailure(),
  };

  /// Data sources throw [AppException]; this is the common path.
  Failure _fromAppException(AppException exception) => switch (exception) {
    UnauthorizedException() => UnauthorizedFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    ),
    NetworkException() => NetworkFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    ),
    CacheException() => CacheFailure(message: exception.message),
    ServerException() => ServerFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    ),
  };

  /// Fallback for Dio errors that escaped a data source unwrapped.
  Failure _fromDioException(DioException exception) => switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const NetworkFailure(
      message: FailureMessages.requestTimedOut,
    ),
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.cancel => const NetworkFailure(
      message: FailureMessages.requestCancelled,
    ),
    DioExceptionType.badCertificate => const NetworkFailure(
      message: FailureMessages.serverUnreachable,
    ),
    DioExceptionType.badResponse => _fromStatusCode(exception),
    DioExceptionType.unknown => const UnknownFailure(),
  };

  Failure _fromStatusCode(DioException exception) {
    final int? statusCode = exception.response?.statusCode;
    if (HttpStatus.isAuthFailure(statusCode)) {
      return UnauthorizedFailure(statusCode: statusCode);
    }
    if (statusCode == HttpStatus.notFound) {
      return ServerFailure(
        message: FailureMessages.resourceNotFound,
        statusCode: statusCode,
      );
    }
    return ServerFailure(
      message: _serverMessageOf(exception) ??
          FailureMessages.unexpectedServerResponse,
      statusCode: statusCode,
    );
  }

  /// Best-effort extraction of the backend's own error text, so users see the
  /// server's reason rather than a generic string when one is available.
  String? _serverMessageOf(DioException exception) {
    final Object? body = exception.response?.data;
    if (body is Map<String, dynamic>) {
      final Object? message = body[_messageKey];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }

  static const String _messageKey = 'message';
}
