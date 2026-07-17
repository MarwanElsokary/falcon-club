import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';

/// A video file selected for upload as an attempt.
///
/// ## Why a value object for "a string path"
///
/// Because three separate places currently derive the upload filename with
/// `path.split('/').last` — inside a widget's `build()`
/// (`ClubTrainingDetailsScreen.dart:742`, `upload_attempt_sheet.dart:330`) and
/// inside a repository (`experiance_details_repo.dart:87`). All three hard-code
/// the POSIX separator, so a Windows-style path yields the whole path as the
/// "filename". Deriving it once, here, means there is one place to be right.
///
/// It also makes "no video selected" unrepresentable downstream: the upload use
/// case takes an [AttemptVideo], not a `String?`, so it cannot be called with an
/// empty path. The current cubit guards this with
/// `if (videoPath.isNotEmpty)` *inside* the FormData builder — and then uploads
/// an empty multipart body if the check fails.
final class AttemptVideo extends Equatable {
  const AttemptVideo._(this.path);

  final String path;

  /// Rejects a blank path rather than letting an empty upload reach the wire.
  static Either<ValidationFailure, AttemptVideo> create(String path) {
    final String trimmed = path.trim();
    if (trimmed.isEmpty) {
      return const Left<ValidationFailure, AttemptVideo>(
        ValidationFailure(message: _blankPathMessage),
      );
    }
    return Right<ValidationFailure, AttemptVideo>(AttemptVideo._(trimmed));
  }

  static const String _blankPathMessage = 'لم يتم اختيار فيديو';

  /// The name to send as the multipart filename.
  ///
  /// Splits on both separators, so this does not silently depend on the host
  /// platform the way the three inline copies do.
  String get fileName {
    final int lastSeparator = math.max(
      path.lastIndexOf('/'),
      path.lastIndexOf(r'\'),
    );
    return lastSeparator == -1 ? path : path.substring(lastSeparator + 1);
  }

  @override
  List<Object?> get props => [path];

  /// Never dump a full device path into a log or an error message.
  @override
  String toString() => 'AttemptVideo($fileName)';
}
