import '../../../../core/usecase/usecase.dart';
import '../entities/auth_session.dart';
import '../entities/session_diagnostics.dart';

/// Persistence of the signed-in session.
///
/// ISP: three methods, one concern. Kept separate from [AuthRepository] (which
/// talks to the network) because saving a token and calling `LoginClub` are
/// different reasons to change. A use case that only needs to sign out does not
/// have to know an HTTP client exists.
///
/// DIP: declared in `domain`, implemented in `data`. Use cases depend on this
/// interface, never on `SecureStore`, `SharedPreferences`, or `CacheHelper`.
/// This is what removes the current situation where 15 widgets read
/// `CacheHelper` / `SharedPrefHelper` directly — including a screen that
/// performs logout by clearing secure storage inline
/// (`club_profile_screen.dart:361`).
abstract interface class SessionRepository {
  /// The current session, or `null` when nobody is signed in.
  ResultFuture<AuthSession?> readSession();

  /// Called only after a successful login (never after registration).
  ResultVoid saveSession(AuthSession session);

  /// Signs out: removes the token, the role, and the user id.
  ResultVoid clearSession();

  /// A redacted report of what is actually stored — for diagnosing a session
  /// that exists when it should not. Never returns the token itself.
  ResultFuture<SessionDiagnostics> describeSession();
}
