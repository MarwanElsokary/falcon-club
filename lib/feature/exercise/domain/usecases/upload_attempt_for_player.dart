import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/exercise_capability.dart';
import '../repositories/attempt_repository.dart';
import '../value_objects/attempt_video.dart';

/// Everything the upload needs, including *who is asking*.
final class AttemptUpload {
  const AttemptUpload({
    required this.capability,
    required this.playerId,
    required this.exerciseId,
    required this.video,
    this.onProgress,
  });

  /// The caller's capability. Not a role — the domain does not ask "are you a
  /// scout?", it asks "may you do this?".
  final ExerciseCapability capability;

  final String playerId;
  final String exerciseId;
  final AttemptVideo video;
  final UploadProgress? onProgress;
}

/// Uploads a video as an attempt for a player on the caller's own team.
///
/// ## The Scout ban is enforced here, not by hiding a button
///
/// [ExerciseCapability] already makes it impossible to *render* an upload
/// control for a Scout — `ScoutCapability` has no branch that produces an
/// `UploadAttemptAction`. That is a presentation guarantee, and presentation
/// guarantees have a way of being routed around: a deep link, a reused sheet, a
/// widget someone lifts into a new screen and wires to the wrong cubit.
///
/// So the rule is asserted a second time, at the domain boundary, where it
/// cannot be bypassed by any UI path. A Scout reaching this use case gets an
/// [UnauthorizedFailure] and no request is made. Defence in depth: the button is
/// unbuildable *and* the operation is unauthorised.
///
/// (This is a client-side guard on top of the backend's own — the API scopes and
/// authorises independently. It exists so the app fails cleanly and honestly
/// rather than firing a request it knows will be refused.)
@injectable
class UploadAttemptForPlayer implements UseCase<void, AttemptUpload> {
  const UploadAttemptForPlayer(this._repository);

  final AttemptRepository _repository;

  static const String _notPermitted = 'رفع المحاولات متاح للنادي فقط';

  @override
  ResultVoid call(AttemptUpload upload) async {
    if (!upload.capability.canUploadAttempt) {
      return const Left<Failure, void>(
        UnauthorizedFailure(message: _notPermitted),
      );
    }

    return _repository.uploadAttemptForPlayer(
      playerId: upload.playerId,
      exerciseId: upload.exerciseId,
      video: upload.video,
      onProgress: upload.onProgress,
    );
  }
}
