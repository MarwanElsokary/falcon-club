import 'package:equatable/equatable.dart';

import 'exercise_player.dart';

/// A piece of kit an exercise calls for.
final class Equipment extends Equatable {
  const Equipment({required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [name, imageUrl];
}

/// One demonstration video attached to an exercise.
final class ExerciseVideo extends Equatable {
  const ExerciseVideo({required this.url, this.description, this.number});

  final String url;
  final String? description;
  final int? number;

  @override
  List<Object?> get props => [url, description, number];
}

/// Everything `club/GetExercise` returns about one exercise, including the
/// roster of players on the caller's own team.
///
/// ## One shape, not two
///
/// The code this replaces parses this single endpoint into **two unrelated
/// models**: `ExerciseDetailsModel` (which declares `attempts`, `score` and
/// `attemptsCount`) and `ExerciseDetailsWithPlayersModel` (which declares
/// `players`). The endpoint is role-polymorphic — it answers with `attempts` to
/// a *player's* token and with `players` to a club/scout token — so the two
/// models are two views of one response.
///
/// Only one of them can ever occur here. This app refuses a Player at sign-in
/// (`UserRole.tryFromApiValue` returns null for `'Player'`, and `LogIn` rejects
/// it), so it never holds a player token, and the `attempts` branch is
/// unreachable by construction. That is confirmed empirically: `attempts`,
/// `score` and `attemptsCount` are declared on the old model and **read by
/// nothing**. Player-side uploads live in a separate app entirely.
///
/// So there is no optional `attempts` list here and no branching. A player's
/// attempts *against* an exercise are fetched deliberately, per player, through
/// `AttemptRepository.getPlayerAttempts` — which is what the UI actually does.
///
/// The [players] roster is scoped to the caller's own club by the backend, from
/// the bearer token. See [ExerciseRepository.getExerciseDetails].
final class ExerciseDetails extends Equatable {
  const ExerciseDetails({
    required this.id,
    required this.title,
    this.description,
    this.photoUrl,
    this.skillNames = const <String>[],
    this.equipment = const <Equipment>[],
    this.playerInstructions = const <String>[],
    this.videos = const <ExerciseVideo>[],
    this.players = const <ExercisePlayer>[],
  });

  final String id;
  final String title;
  final String? description;
  final String? photoUrl;

  /// Skills this exercise is scored against.
  final List<String> skillNames;

  final List<Equipment> equipment;
  final List<String> playerInstructions;
  final List<ExerciseVideo> videos;

  /// Players on the caller's team who are visible for this exercise.
  ///
  /// The backend truncates this list for an unsubscribed Scout — so a short
  /// roster is a *paywall* signal, not an empty team. The UI must not conclude
  /// "no players" from a truncated list; see `ExerciseCapability.isPaywalled`.
  final List<ExercisePlayer> players;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  bool get hasPlayers => players.isNotEmpty;

  /// Total attempts logged across the visible roster.
  ///
  /// Derived here rather than in a widget: three screens currently sum or
  /// display this inline.
  int get totalAttempts => players.fold(
    0,
    (int sum, ExercisePlayer player) => sum + player.attemptCount,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    photoUrl,
    skillNames,
    equipment,
    playerInstructions,
    videos,
    players,
  ];
}
