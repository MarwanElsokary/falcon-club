/// Cache keys and freshness windows for this feature.
///
/// ## One key per resource, not one per role
///
/// The repositories this replaces cache the *same* `club/GetExercise` response
/// under two keys — `exercise_details_$id` (Club) and
/// `scout_exercise_details_$id` (Scout) — so the two roles keep separate,
/// separately-stale copies of identical data on the same device. The response
/// does not vary by role here, so neither does the key.
///
/// Keys are namespaced (`exercise.`) because they share `SharedPreferences` with
/// everything else the app stores, including `CacheHelper`'s unprefixed
/// `myProfile` / `categories` / `home_trials`.
abstract final class ExerciseCacheKeys {
  const ExerciseCacheKeys._();

  static const String _namespace = 'exercise.';

  static String details(String exerciseId) =>
      '${_namespace}details.$exerciseId';

  static String trial(String trialId) => '${_namespace}trial.$trialId';

  /// How long an exercise's details stay fresh.
  ///
  /// Short, because the payload contains each player's attempt count, and a
  /// coach uploading a video expects to see that number move. The upload path
  /// invalidates the entry outright, so this TTL only bounds staleness caused by
  /// *someone else's* change — another coach on the same team, or the AI
  /// pipeline finishing a review.
  ///
  /// The old code had no TTL at all: an entry written once was served until the
  /// user signed out.
  static const Duration detailsMaxAge = Duration(minutes: 5);

  /// Trials are near-static — a curated set of exercises with an age band — so
  /// they tolerate a longer window than a roster does.
  static const Duration trialMaxAge = Duration(minutes: 30);
}
