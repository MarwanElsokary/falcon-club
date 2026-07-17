import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/player_position.dart';

/// A player as they appear *on the roster of one exercise*.
///
/// ## Why this is not the shared [Player] entity
///
/// The obvious move is to reuse `shared/domain/entities/player.dart`. It is the
/// wrong one. That entity models a player in the squad/ranking sense — it
/// carries `jerseyNumber`, `talentScore` and `isFavorite`, none of which the
/// `club/GetExercise` roster returns, and it lacks the two facts this view is
/// entirely *about*: the player's age, and how many attempts they have logged
/// **against this exercise**.
///
/// Forcing one entity to serve both would mean five nullable fields and a name
/// that lies about what is actually in the payload. `attemptCount` is not a
/// property of a player at all — it is a property of *this player on this
/// exercise*, and it changes the moment a coach uploads a video. Modelling it as
/// a player attribute would be modelling a relationship as a thing.
///
/// What it *does* reuse is [PlayerPosition], so the roster groups and labels
/// positions the same way the team screen does, rather than passing an
/// unvalidated Arabic string around.
final class ExercisePlayer extends Equatable {
  const ExercisePlayer({
    required this.id,
    required this.name,
    required this.position,
    required this.attemptCount,
    this.photoUrl,
    this.age,
  });

  final String id;
  final String name;
  final PlayerPosition position;

  /// Attempts this player has logged **against this exercise** — not their
  /// career total.
  final int attemptCount;

  final String? photoUrl;
  final int? age;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  bool get hasAttempts => attemptCount > 0;

  /// The age to display, or `-` when there isn't one.
  ///
  /// The backend sends `"age": 0` for a player whose date of birth it does not
  /// have — most of the live roster comes back that way. Zero is not an age, and
  /// rendering "0" tells the user something false. Formatting it here means every
  /// surface that shows an age agrees, rather than each remembering the `0` case.
  ///
  /// Nothing renders an age today (it is parsed, and only ever *sent* onward, by
  /// the digital report), so this changes no pixel yet — it is the rule ready for
  /// whichever surface shows one.
  static const String unknownAge = '-';

  String get ageLabel =>
      (age == null || age == 0) ? unknownAge : age!.toString();

  /// Fallback avatar letter. Three widgets re-derive this inline today, each
  /// with its own empty-name guard — and two of them get it wrong by indexing
  /// `name[0]` without checking.
  String get initial => name.trim().isEmpty ? '؟' : name.trim()[0];

  @override
  List<Object?> get props => [id, name, position, attemptCount, photoUrl, age];
}
