import 'package:equatable/equatable.dart';

/// One distinct exercise a player has completed, for the "التمارين المنجزة"
/// section on the player profile (`Player/GetPlayerExercises`).
///
/// Deliberately lean: only what the card shows — photo, title, and the attempt
/// count ([attemptsCount], the endpoint's `bookings`). The payload also carries
/// category/skill metadata that this section does not display, so it is not
/// modelled. There is **no rating** here — the rating source is unconfirmed and
/// is intentionally left out entirely (not a zero, not a placeholder).
final class CompletedExercise extends Equatable {
  const CompletedExercise({
    required this.id,
    required this.title,
    this.photoUrl,
    this.attemptsCount = 0,
  });

  /// The exercise id — carried as a String because the attempt-history route
  /// (`playerAttemptsScreen`) expects `exerciseId` as a String.
  final String id;
  final String title;
  final String? photoUrl;
  final int attemptsCount;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[id, title, photoUrl, attemptsCount];
}
