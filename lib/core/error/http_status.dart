/// Named HTTP status codes.
///
/// Clean Code: removes magic numbers (`401`, `404`, `500`) from the mapping
/// logic. The existing `ResponseCode`/`DataSource` enums used SCREAMING_CASE
/// and misspelled members (`UNAUTORISED`, `RECIEVE_TIMEOUT`); this replaces
/// them with correctly-spelled, idiomatic Dart constants.
abstract final class HttpStatus {
  const HttpStatus._();

  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int unprocessableEntity = 422;
  static const int internalServerError = 500;

  /// `true` when [statusCode] means "the caller is not allowed", which the
  /// session layer treats as a signal to force re-authentication.
  static bool isAuthFailure(int? statusCode) =>
      statusCode == unauthorized || statusCode == forbidden;

  /// `true` for any 4xx/5xx.
  static bool isError(int? statusCode) =>
      statusCode != null && statusCode >= badRequest;
}
