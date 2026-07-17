import 'package:dio/dio.dart';
import 'api_error_model.dart';
import 'api_constants.dart';

enum DataSource {
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  BAD_RESPONSE,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

class ResponseCode {
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int UNAUTORISED = 401;
  static const int BAD_RESPONSE = 302;
  static const int FORBIDDEN = 403;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int NOT_FOUND = 404;
  static const int API_LOGIC_ERROR = 422;

  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String NO_CONTENT = ApiErrors.noContent;
  static const String BAD_REQUEST = ApiErrors.badRequestError;
  static const String UNAUTORISED = ApiErrors.unauthorizedError;
  static String BAD_RESPONSE = ApiErrors.badResponseError;
  static const String FORBIDDEN = ApiErrors.forbiddenError;
  static const String INTERNAL_SERVER_ERROR = ApiErrors.internalServerError;
  static const String NOT_FOUND = ApiErrors.notFoundError;

  static String CONNECT_TIMEOUT = ApiErrors.timeoutError;
  static String CANCEL = ApiErrors.defaultError;
  static String RECIEVE_TIMEOUT = ApiErrors.timeoutError;
  static String SEND_TIMEOUT = ApiErrors.timeoutError;
  static String CACHE_ERROR = ApiErrors.cacheError;
  static String NO_INTERNET_CONNECTION = ApiErrors.noInternetError;
  static String DEFAULT = ApiErrors.defaultError;
}

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.NO_CONTENT:
        return ApiErrorModel(
          code: ResponseCode.NO_CONTENT,
          message: ResponseMessage.NO_CONTENT,
        );
      case DataSource.BAD_REQUEST:
        return ApiErrorModel(
          code: ResponseCode.BAD_REQUEST,
          message: ResponseMessage.BAD_REQUEST,
        );
      case DataSource.UNAUTORISED:
        return ApiErrorModel(
          code: ResponseCode.UNAUTORISED,
          message: ResponseMessage.UNAUTORISED,
        );
      case DataSource.BAD_RESPONSE:
        return ApiErrorModel(
          code: ResponseCode.BAD_RESPONSE,
          message: ResponseMessage.BAD_RESPONSE,
        );
      case DataSource.FORBIDDEN:
        return ApiErrorModel(
          code: ResponseCode.FORBIDDEN,
          message: ResponseMessage.FORBIDDEN,
        );
      case DataSource.NOT_FOUND:
        return ApiErrorModel(
          code: ResponseCode.NOT_FOUND,
          message: ResponseMessage.NOT_FOUND,
        );
      case DataSource.INTERNAL_SERVER_ERROR:
        return ApiErrorModel(
          code: ResponseCode.INTERNAL_SERVER_ERROR,
          message: ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.CONNECT_TIMEOUT,
          message: ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return ApiErrorModel(
          code: ResponseCode.CANCEL,
          message: ResponseMessage.CANCEL,
        );
      case DataSource.RECIEVE_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.RECIEVE_TIMEOUT,
          message: ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return ApiErrorModel(
          code: ResponseCode.SEND_TIMEOUT,
          message: ResponseMessage.SEND_TIMEOUT,
        );
      case DataSource.CACHE_ERROR:
        return ApiErrorModel(
          code: ResponseCode.CACHE_ERROR,
          message: ResponseMessage.CACHE_ERROR,
        );
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiErrorModel(
          code: ResponseCode.NO_INTERNET_CONNECTION,
          message: ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.DEFAULT:
        return ApiErrorModel(
          code: ResponseCode.DEFAULT,
          message: ResponseMessage.DEFAULT,
        );
    }
  }
}

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      apiErrorModel = _handleError(error);
    } else {
      // A non-Dio failure (usually a parsing/`TypeError`). Carry its real text
      // rather than a bare generic — see [_serverMessageOr].
      apiErrorModel = ApiErrorModel(
        code: ResponseCode.DEFAULT,
        message: error.toString(),
      );
    }
  }
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();

    // Both branches: prefer the backend's own message when the response carries
    // one, and only fall back to a sensible generic when it does not.
    case DioExceptionType.badResponse:
      return _serverMessageOr(error, DataSource.DEFAULT.getFailure());

    case DioExceptionType.unknown:
      return _serverMessageOr(
        error,
        DataSource.NO_INTERNET_CONNECTION.getFailure(),
      );
  }
}

/// Reads the backend's `message` from the response body when present, otherwise
/// returns [fallback].
///
/// The body is usually `{ "message": "…" }`, but some endpoints return the
/// message as a bare string; both are honoured. Anything else degrades to the
/// generic [fallback] — which is now a human sentence, not a bare error code.
ApiErrorModel _serverMessageOr(DioException error, ApiErrorModel fallback) {
  final data = error.response?.data;
  if (data == null) return fallback;

  try {
    if (data is Map<String, dynamic>) {
      final parsed = ApiErrorModel.fromJson(data);
      final message = parsed.message;
      if (message != null && message.trim().isNotEmpty) return parsed;
    } else if (data is String && data.trim().isNotEmpty) {
      return ApiErrorModel(
        code: error.response?.statusCode,
        message: data.trim(),
      );
    }
  } catch (_) {
    // Fall through to the generic below.
  }
  return fallback;
}

class ApiInternalStatus {
  static const int SUCCESS = 0;
  static const int FAILURE = 1;
}
