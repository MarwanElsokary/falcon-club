import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_constants.dart';
import 'package:falconclubapp/core/networking/api_error_handler.dart';
import 'package:flutter_test/flutter_test.dart';

/// #3: an error state should show the **real** message the backend (or the
/// exception) provides, and only fall back to a human generic when there is
/// none — never a bare error code like "noInternetError".
DioException _dio({
  required DioExceptionType type,
  int? statusCode,
  Object? body,
}) {
  final RequestOptions options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    type: type,
    response: (statusCode == null && body == null)
        ? null
        : Response<dynamic>(
            requestOptions: options,
            statusCode: statusCode,
            data: body,
          ),
  );
}

String _messageFor(Object error) => ErrorHandler.handle(error).apiErrorModel.message ?? '';

void main() {
  group('the backend message is preferred', () {
    test('a 4xx with a message shows that message, not a generic', () {
      final message = _messageFor(
        _dio(
          type: DioExceptionType.badResponse,
          statusCode: 400,
          body: <String, dynamic>{'message': 'الرصيد غير كافٍ'},
        ),
      );

      expect(message, 'الرصيد غير كافٍ');
    });

    test('a message returned as a bare string is honoured too', () {
      final message = _messageFor(
        _dio(
          type: DioExceptionType.badResponse,
          statusCode: 400,
          body: 'Player already registered',
        ),
      );

      expect(message, 'Player already registered');
    });

    test('an unknown-type error that still carries a body message shows it', () {
      final message = _messageFor(
        _dio(
          type: DioExceptionType.unknown,
          statusCode: 200,
          body: <String, dynamic>{'message': 'رسالة من الخادم'},
        ),
      );

      expect(message, 'رسالة من الخادم');
    });
  });

  group('sensible generic fallbacks (never a bare error code)', () {
    test('an empty backend message falls back to the human default', () {
      final message = _messageFor(
        _dio(
          type: DioExceptionType.badResponse,
          statusCode: 500,
          body: <String, dynamic>{'message': '   '},
        ),
      );

      expect(message, ApiErrors.defaultError);
      expect(message, isNot(contains('Error')), reason: 'not a raw code');
    });

    // The rank case: a List body cast-failure surfaces as unknown-no-response.
    // It must read as a human sentence, not the literal "noInternetError".
    test('unknown with no response is the human no-internet message', () {
      final message = _messageFor(_dio(type: DioExceptionType.unknown));

      expect(message, ApiErrors.noInternetError);
      expect(message, 'تعذّر الاتصال بالإنترنت');
    });

    test('a timeout is the human timeout message', () {
      final message = _messageFor(
        _dio(type: DioExceptionType.connectionTimeout),
      );

      expect(message, ApiErrors.timeoutError);
    });
  });

  test('a non-Dio exception carries its real text, not a bare generic', () {
    final message = _messageFor(const FormatException('Unexpected token < in JSON'));

    expect(message, contains('Unexpected token'));
  });
}
