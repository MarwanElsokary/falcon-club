import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/user_role.dart';

/// A signed-in user's session.
///
/// Created **only** by a successful login. Registration deliberately does not
/// produce one: per the product decision behind findings B10/B13, a successful
/// Register returns the user to the login screen and persists nothing. That is
/// why there is no `AuthSession` anywhere in the registration flow — the type
/// system now reflects the product rule.
///
/// SRP: identifies the current user and nothing else. It does not know how to
/// persist itself (that is `SessionRepository`), refresh itself, or route
/// anywhere (that is the presentation layer's `RoleRouter`).
final class AuthSession extends Equatable {
  const AuthSession({
    required this.token,
    required this.userId,
    required this.role,
  });

  final String token;
  final String userId;
  final UserRole role;

  /// A session with a blank token is not a session. Guards against the current
  /// code's habit of "saving" a role with no token (see `_saveAuthData`, which
  /// logs a warning and continues).
  bool get isUsable => token.isNotEmpty && userId.isNotEmpty;

  @override
  List<Object?> get props => [token, userId, role];

  /// Never leak the bearer token into logs or crash reports.
  @override
  String toString() => 'AuthSession(userId: $userId, role: ${role.name})';
}
