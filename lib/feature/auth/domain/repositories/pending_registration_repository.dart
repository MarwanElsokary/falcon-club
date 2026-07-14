import '../../../../core/usecase/usecase.dart';
import '../entities/registration_credential.dart';

/// Storage for the not-yet-confirmed registration's credential.
///
/// ISP: three methods, one concern — deliberately **not** folded into
/// [SessionRepository]. Keeping them apart is what guarantees the credential can
/// never be mistaken for, or promoted into, a session: the two write to
/// different keys and neither reads the other's.
///
/// It exists so a user who registers, closes the app, and comes back tomorrow
/// can still confirm their phone. The backend offers no way to re-issue this
/// token — the unconfirmed-login response is a bare 400 with only a message — so
/// if we did not keep it, delayed confirmation would be impossible.
abstract interface class PendingRegistrationRepository {
  /// The stored credential, or `null` if there is no pending registration.
  ResultFuture<RegistrationCredential?> read();

  ResultVoid save(RegistrationCredential credential);

  /// Called the moment confirmation succeeds.
  ResultVoid clear();
}
