import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/attempt.dart';
import '../value_objects/attempt_video.dart';

/// Reports upload progress, 0–100.
typedef UploadProgress = void Function(int percent);

/// Reads and creates attempts.
///
/// ## Only one direction of upload exists here
///
/// The backend exposes two upload endpoints: `Club/AddAttempt` (a coach uploads
/// *for* a player) and `Player/AddAttempt` (a player uploads their own). This
/// app only ever does the first. Player self-upload is handled by a separate,
/// dedicated application, and this app cannot even hold a player token — sign-in
/// refuses the `Player` role outright.
///
/// So `Player/AddAttempt` is **not modelled**. The old code implements it in
/// full (`TrainingDetailsRepo.addAttempt` + `TrainingDetailsCubit
/// .emitAddAttemptStates` + four state cases) and calls it from nowhere; that
/// whole chain is deleted in Phase 8. Modelling a capability the product does
/// not have is how it comes back.
///
/// ## Scoping
///
/// As with [ExerciseRepository], no club id is passed. Every [playerId] that
/// reaches [uploadAttemptForPlayer] originates from a roster the backend already
/// scoped to the caller's own team.
abstract interface class AttemptRepository {
  /// Every attempt [playerId] has logged against [exerciseId].
  ///
  /// Returns the attempts themselves rather than a pre-computed summary; the
  /// roll-up the header needs is [AttemptTally.of], which is a domain
  /// calculation, not a network concern. Today `player_attempts_screen`
  /// recomputes those four counters inside `build()` on every rebuild.
  ResultFuture<List<Attempt>> getPlayerAttempts({
    required String exerciseId,
    required String playerId,
  });

  /// Uploads [video] as an attempt for [playerId] on [exerciseId].
  ///
  /// [onProgress] is optional because progress is a *transport* detail the
  /// domain merely forwards. It exists on the interface at all because the
  /// upload is a large multipart POST over a phone connection, and a UI with no
  /// progress for thirty seconds is indistinguishable from a hang — which is
  /// precisely the bug this feature shipped with.
  ResultVoid uploadAttemptForPlayer({
    required String playerId,
    required String exerciseId,
    required AttemptVideo video,
    UploadProgress? onProgress,
  });
}
