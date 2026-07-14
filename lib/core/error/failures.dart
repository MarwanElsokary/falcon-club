import 'package:equatable/equatable.dart';

import 'failure_messages.dart';

/// The domain's vocabulary for "something went wrong".
///
/// DIP: the domain and presentation layers depend on *this* abstraction, never
/// on `DioException`, `SocketException`, or any other data/infrastructure type.
/// Swapping Dio for another HTTP client changes only [ErrorMapper] — no use
/// case, cubit, or widget is touched.
///
/// LSP: every subtype carries exactly the same contract ([message],
/// [statusCode]), so any `Failure` is substitutable wherever a `Failure` is
/// expected. Callers that only render `failure.message` never need a type test.
///
/// `sealed` gives exhaustive `switch` at the call site: adding a new failure
/// type becomes a compile error in every handler that must react to it, rather
/// than a silent fall-through.
sealed class Failure extends Equatable {
  const Failure({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// The server was reached but rejected or mishandled the request (5xx, 4xx
/// other than auth, or a malformed body).
final class ServerFailure extends Failure {
  const ServerFailure({
    super.message = FailureMessages.unexpectedServerResponse,
    super.statusCode,
  });
}

/// The server was never reached — no connectivity, DNS failure, or timeout.
///
/// Separate from [ServerFailure] because the UI reaction differs: this one is
/// retryable by the user without any change to their input.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = FailureMessages.noInternetConnection,
    super.statusCode,
  });
}

/// Credentials are missing, expired, or rejected (401/403).
///
/// Modelled separately so the session layer can react polymorphically (force
/// logout) without any caller string-matching on an error message.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = FailureMessages.sessionExpired,
    super.statusCode,
  });
}

/// Local persistence could not be read or written.
final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = FailureMessages.cacheReadFailed,
    super.statusCode,
  });
}

/// Input rejected by a domain rule *before* any I/O was attempted.
///
/// Produced by value objects (e.g. `PhoneNumber.forSaudiRegistration`), so invalid input is
/// caught in the domain rather than by a `GlobalKey<FormState>` in a cubit.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Escape hatch for genuinely unclassified errors.
///
/// Deliberately last: if this shows up often, [ErrorMapper] is missing a case.
final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = FailureMessages.unknown,
    super.statusCode,
  });
}
