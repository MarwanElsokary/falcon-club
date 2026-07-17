import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/exercise.dart';
import '../../domain/entities/trial.dart';
import 'exercise_model.dart';

/// Parses `club/GetTrial`.
///
/// ## ⚠ Not verified against a captured response
///
/// Inferred from `TrialDetailsModel`, whose every field is `dynamic` and whose
/// nested classes are named `Data` and `Exercise` — the latter colliding with
/// the shared [Exercise] entity.
///
/// * **`minAge` / `maxAge`** — assumed numbers, read through [Json.asInt] so a
///   stringified age still works. Absent ages yield `null`, and
///   [Trial.hasAgeRange] lets the UI skip the sentence rather than rendering
///   "من null إلى null سنة", which is what ships today.
/// * **`exercises[]`** — assumed to be the same row shape as
///   `GetAllExercises`, so it reuses [ExerciseModel]. If the trial endpoint
///   returns a thinner row (no `bookings`, no category), the tolerant defaults
///   absorb it: the fields simply come back empty rather than throwing.
/// * `gender`, `country` and `exerciseCount` are present in the payload and
///   deliberately not modelled — see [Trial].
abstract final class TrialModel {
  const TrialModel._();

  static Trial fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Json.asObject(json['data']);

    return Trial(
      title: Json.asString(data['trialTitle']) ?? '',
      photoUrl: Json.asString(data['trialPhoto']),
      minAge: Json.asInt(data['minAge']),
      maxAge: Json.asInt(data['maxAge']),
      exercises: _exercisesOf(data['exercises']),
    );
  }

  static List<Exercise> _exercisesOf(Object? value) {
    if (value is! List) return const <Exercise>[];
    return value
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .map(ExerciseModel.fromJson)
        .toList(growable: false);
  }
}
