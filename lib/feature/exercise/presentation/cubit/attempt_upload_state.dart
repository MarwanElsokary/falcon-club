import 'package:equatable/equatable.dart';

/// Where a single attempt upload currently is.
///
/// A flat, four-state machine — deliberately not the legacy shape it replaces,
/// which split "loading" and "progress" into two states even though the UI drove
/// both from one `_isUploading` flag. Here [AttemptUploadInProgress] *is* the
/// loading state: it starts at `0` and climbs, so there is nothing for a
/// separate "loading" case to represent.
///
/// There is no throwing anywhere in this flow. The legacy cubit emitted an error
/// state *and* rethrew, because one caller listened to states and another
/// awaited a thrown exception. Both callers now observe these states, so
/// [AttemptUploadFailure] is the only failure channel — validation refusals, the
/// domain's Scout ban, and transport errors all arrive the same way.
sealed class AttemptUploadState extends Equatable {
  const AttemptUploadState();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Nothing in flight — the initial state, and where the sheet sits before a
/// video is picked.
final class AttemptUploadIdle extends AttemptUploadState {
  const AttemptUploadIdle();
}

/// Uploading, [percent] of the multipart body sent (0–100).
final class AttemptUploadInProgress extends AttemptUploadState {
  const AttemptUploadInProgress(this.percent);

  final int percent;

  @override
  List<Object?> get props => <Object?>[percent];
}

/// The attempt was accepted by the backend.
final class AttemptUploadSuccess extends AttemptUploadState {
  const AttemptUploadSuccess();
}

/// The upload did not happen. [message] is already user-facing Arabic — a
/// validation message from [AttemptVideo], the domain's not-permitted message,
/// or a mapped transport failure.
final class AttemptUploadFailure extends AttemptUploadState {
  const AttemptUploadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
