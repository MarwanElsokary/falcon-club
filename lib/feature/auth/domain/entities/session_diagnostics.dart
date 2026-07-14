import 'package:equatable/equatable.dart';

/// A redacted description of what is actually sitting in storage.
///
/// Exists because "why am I logged in when I never signed in?" is impossible to
/// answer from the outside — the token lives in the platform keystore, which no
/// one can inspect from the app or from a code review.
///
/// Deliberately carries **no token value** — only its length, whether it parses,
/// and when it expires. Enough to diagnose a stale session; not enough to leak
/// a credential into a log. (`SharedPrefHelper.setSecuredString` currently
/// `debugPrint`s the token in plaintext on every write.)
final class SessionDiagnostics extends Equatable {
  const SessionDiagnostics({
    required this.hasToken,
    required this.tokenLength,
    required this.isTokenExpired,
    required this.expiresAt,
    required this.userId,
    required this.storedRole,
  });

  final bool hasToken;
  final int tokenLength;
  final bool isTokenExpired;
  final DateTime? expiresAt;
  final String? userId;
  final String? storedRole;

  bool get grantsEntry => hasToken && !isTokenExpired && (userId?.isNotEmpty ?? false);

  @override
  List<Object?> get props => [
    hasToken,
    tokenLength,
    isTokenExpired,
    expiresAt,
    userId,
    storedRole,
  ];

  @override
  String toString() =>
      'SessionDiagnostics(hasToken: $hasToken, tokenLength: $tokenLength, '
      'isTokenExpired: $isTokenExpired, expiresAt: $expiresAt, '
      'userId: $userId, storedRole: $storedRole, grantsEntry: $grantsEntry)';
}
