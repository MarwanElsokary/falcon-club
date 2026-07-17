import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/viewer_capability_port.dart';
import '../../domain/usecases/upload_attempt_for_player.dart';
import '../../domain/value_objects/attempt_video.dart';
import 'attempt_upload_state.dart';

/// Drives one attempt upload, for both places that start one: the exercise
/// details screen and the club team's assign-exercise flow.
///
/// ## What this replaces
///
/// The legacy `ExperianceDetailsCubit.addAttemptForPlayer` did the upload *and*
/// carried the whole feature's other reads (trial details, the player roster).
/// It also served two callers with two contracts at once — it emitted states for
/// one and threw for the other. This does one thing, the same way for everyone:
/// a linear idle → progress → success/failure with no throwing.
///
/// ## DIP and where the rules live
///
/// Depends on [UploadAttemptForPlayer], never on a repository or Dio. The
/// Scout-cannot-upload rule is the use case's, asserted at the domain boundary;
/// this cubit does not re-check a role. It only resolves *who is asking* from
/// [ViewerCapabilityPort] and hands that to the use case — the same capability
/// the exercise screen was built around, resolved from one source so the two
/// entry points cannot diverge.
///
/// "No video selected" is caught here by [AttemptVideo.create] before any of
/// that: an empty path becomes an [AttemptUploadFailure], not an empty multipart
/// body on the wire.
@injectable
class AttemptUploadCubit extends Cubit<AttemptUploadState> {
  AttemptUploadCubit(this._uploadAttempt, this._capability)
    : super(const AttemptUploadIdle());

  final UploadAttemptForPlayer _uploadAttempt;
  final ViewerCapabilityPort _capability;

  /// Uploads [videoPath] as an attempt for [playerId] on [exerciseId].
  ///
  /// Returns normally in every case; the outcome is the emitted state. Callers
  /// listen — none of them needs a `try/catch`.
  Future<void> uploadAttempt({
    required String playerId,
    required String exerciseId,
    required String videoPath,
  }) async {
    if (isClosed) return;

    // Validate the file first: a blank path is a domain refusal, not a request.
    await AttemptVideo.create(videoPath).match(
      (failure) async => emit(AttemptUploadFailure(failure.message)),
      (video) => _run(
        playerId: playerId,
        exerciseId: exerciseId,
        video: video,
      ),
    );
  }

  Future<void> _run({
    required String playerId,
    required String exerciseId,
    required AttemptVideo video,
  }) async {
    emit(const AttemptUploadInProgress(0));

    final result = await _uploadAttempt(
      AttemptUpload(
        // Resolved now, from the one source every entry point shares.
        capability: _capability.current(),
        playerId: playerId,
        exerciseId: exerciseId,
        video: video,
        onProgress: (int percent) {
          if (!isClosed) emit(AttemptUploadInProgress(percent));
        },
      ),
    );

    if (isClosed) return;

    result.match(
      (failure) => emit(AttemptUploadFailure(failure.message)),
      (_) => emit(const AttemptUploadSuccess()),
    );
  }
}
