import '../../../../core/networking/json.dart';
import '../../domain/entities/completed_exercise.dart';

/// Parses one element of `Player/GetPlayerExercises` (`data: [ … ]`) into a
/// [CompletedExercise].
///
/// ## Verified against the representative capture
/// `{ id: 9, photoPath: url, title, description, categoryId, colorCode,
/// categoryName, categoryIcon, bookings: 3, skills: [...] }`
///
/// * Only `id` / `title` / `photoPath` / `bookings` are read — the section shows
///   photo + title + attempt-count and nothing else.
/// * `id` arrives as a number; read as a String because the attempt-history
///   route wants `exerciseId` as a String.
/// * `photoPath` is read tolerantly (null when absent); `bookings` defaults to 0.
/// * No rating is read or invented.
abstract final class CompletedExerciseModel {
  const CompletedExerciseModel._();

  static CompletedExercise fromJson(Map<String, dynamic> json) {
    return CompletedExercise(
      id: Json.asString(json['id']) ?? '',
      title: Json.asString(json['title']) ?? '',
      photoUrl: Json.asString(json['photoPath']),
      attemptsCount: Json.asInt(json['bookings']) ?? 0,
    );
  }
}
