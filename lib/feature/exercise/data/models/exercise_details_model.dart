import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/player_position.dart';
import '../../domain/entities/exercise_details.dart';
import '../../domain/entities/exercise_player.dart';
import 'exercise_model.dart';

/// Parses `club/GetExercise`.
///
/// ## ⚠ Not verified against a captured response
///
/// Inferred from the two DTOs it replaces — `ExerciseDetailsModel` (which reads
/// `attempts`/`score`/`attemptsCount`) and `ExerciseDetailsWithPlayersModel`
/// (which reads `players`). They parse the *same endpoint*; see
/// [ExerciseDetails] for why only the `players` shape can occur in this app.
///
/// Assumptions worth checking against a real 200:
///
/// * **`players[].age`** — assumed a number, read through [Json.asInt] so `12`,
///   `"12"` and `12.0` all work, and anything else becomes `null` rather than a
///   crash. The old DTO types it `dynamic` and no screen reads it, so nothing in
///   the codebase pins it down.
/// * **`players[].attemptCount`** — assumed a count; defaults to 0, matching the
///   old `ExercisePlayer.fromJson`.
/// * **`players[].position`** — a free-text label, mapped through
///   [PlayerPosition.fromApiValue], which degrades unknown labels to
///   `PlayerPosition.unknown` instead of throwing.
/// * **`equipments`** — assumed `[{name, image}]`. The club DTO types the list
///   `List<dynamic>` and never renders it, so the element shape comes from the
///   *other* DTO's `Equipment` class.
abstract final class ExerciseDetailsModel {
  const ExerciseDetailsModel._();

  static ExerciseDetails fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Json.asObject(json['data']);

    return ExerciseDetails(
      id: data['id']?.toString() ?? '',
      title: Json.asString(data['title']) ?? '',
      description: Json.asString(data['description']),
      photoUrl: Json.asString(data['photoPath']),
      skillNames: ExerciseModel.skillNamesOf(data['skills']),
      equipment: _equipmentOf(data['equipments']),
      playerInstructions: ExerciseModel.skillNamesOf(
        data['playerInstructions'],
      ),
      videos: _videosOf(data['videos']),
      players: _playersOf(data['players']),
    );
  }

  /// An absent roster is an empty roster, not an error: the endpoint omits
  /// `players` entirely for a caller with no team.
  static List<ExercisePlayer> _playersOf(Object? value) =>
      _objectsOf(value).map(_playerFrom).toList(growable: false);

  static ExercisePlayer _playerFrom(Map<String, dynamic> json) =>
      ExercisePlayer(
        id: json['id']?.toString() ?? '',
        name: Json.asString(json['name']) ?? '',
        position: PlayerPosition.fromApiValue(Json.asString(json['position'])),
        attemptCount: Json.asInt(json['attemptCount']) ?? 0,
        photoUrl: Json.asString(json['photo']),
        age: Json.asInt(json['age']),
      );

  static List<Equipment> _equipmentOf(Object? value) => _objectsOf(value)
      .map(
        (Map<String, dynamic> json) => Equipment(
          name: Json.asString(json['name']) ?? '',
          imageUrl: Json.asString(json['image']),
        ),
      )
      .toList(growable: false);

  /// A video with no URL is not a video — those rows are dropped rather than
  /// rendered as a broken player.
  static List<ExerciseVideo> _videosOf(Object? value) => _objectsOf(value)
      .map(
        (Map<String, dynamic> json) => ExerciseVideo(
          url: Json.asString(json['video']) ?? '',
          description: Json.asString(json['description']),
          number: Json.asInt(json['number']),
        ),
      )
      .where((ExerciseVideo video) => video.url.isNotEmpty)
      .toList(growable: false);

  /// Unlike `Json.asObjectList`, a missing list here is *not* a contract
  /// violation — `equipments`, `videos` and `players` are all legitimately
  /// absent — so this degrades to empty rather than throwing.
  static List<Map<String, dynamic>> _objectsOf(Object? value) {
    if (value is! List) return const <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList(growable: false);
  }
}
