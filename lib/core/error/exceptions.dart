/// Thrown by *data sources only* — never by domain or presentation.
///
/// SRP / layer discipline: a data source's job is to talk to a transport and
/// throw when the transport misbehaves. It is the repository implementation's
/// job to catch these and translate them into [Failure]s via [ErrorMapper].
/// This keeps `try/catch` out of use cases and cubits entirely.
///
/// These are exceptions (thrown) while `Failure`s are values (returned). The
/// existing `ErrorHandler` conflated the two — it `implements Exception` yet is
/// only ever used as a value inside `ApiResult.failure`. Splitting them removes
/// that ambiguity.
sealed class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

/// Transport reached the server; the server responded with an error status or
/// an unparseable body.
final class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

/// Transport never reached the server (offline, DNS, timeout, cancelled).
final class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

/// Server explicitly rejected the caller's credentials (401/403).
final class UnauthorizedException extends AppException {
  const UnauthorizedException({required super.message, super.statusCode});
}

/// Local persistence read/write failed.
final class CacheException extends AppException {
  const CacheException({required super.message});
}
