import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/exercise.dart';

/// Parses one row of `Club/GetAllExercises`.
///
/// ## ⚠ Not verified against a captured response
///
/// There is no Postman capture for this endpoint, so the shape below is
/// inferred from the DTO it replaces (`AllExerciseList`), whose fields are all
/// typed `dynamic` — which means the DTO itself is evidence of nothing beyond
/// the key names. Every field is therefore read tolerantly:
///
/// * **`id`** is stringified verbatim rather than parsed. It is handed straight
///   back to the backend as a route argument and as `ExerciseId`, so re-typing
///   it risks changing the request. (`ClubTrainingDetailsScreen` and
///   `scout_players_section` currently do `int.tryParse(exerciseId) ?? 0` —
///   silently turning an unparseable id into exercise **0**.)
/// * **`bookings`** — *assumption*: a count. Read through [Json.asInt], which
///   accepts `7`, `"7"` and `7.0`. Defaults to 0.
/// * **`isPaid`** — read but not acted on; see [Exercise.isPaid].
///
/// A row missing `title` degrades to an empty string rather than throwing: the
/// old `AllExercisesModel.fromJson` calls `json["data"].map(...)` with no null
/// guard and `List<String>.from(json["skills"].map(...))` with none either, so a
/// single malformed row takes down the whole list.
abstract final class ExerciseModel {
  const ExerciseModel._();

  static Exercise fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id']?.toString() ?? '',
    title: Json.asString(json['title']) ?? '',
    description: Json.asString(json['description']),
    photoUrl: Json.asString(json['photoPath']),
    categoryId: Json.asString(json['categoryId']),
    categoryName: Json.asString(json['categoryName']),
    categoryIconUrl: Json.asString(json['categoryIcon']),
    skillNames: skillNamesOf(json['skills']),
    bookingsCount: Json.asInt(json['bookings']) ?? 0,
    isPaid: Json.asBool(json['isPaid']) ?? false,
    // A bare hex string, no leading '#'. Kept verbatim; `ColorCode.parse` turns
    // it into a Color at the presentation boundary, and falls back to the old
    // palette if it is missing or malformed.
    colorCode: Json.asString(json['colorCode']),
  );

  /// Skills arrive as a bare list of strings. A non-list degrades to empty
  /// rather than throwing — an exercise with no skill chips is still usable.
  static List<String> skillNamesOf(Object? value) {
    if (value is! List) return const <String>[];
    return value.map(Json.asString).whereType<String>().toList(growable: false);
  }
}
