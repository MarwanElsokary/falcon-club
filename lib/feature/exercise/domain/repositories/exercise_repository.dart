import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/exercise.dart';
import '../entities/exercise_details.dart';

/// Reads exercises and their rosters.
///
/// ## Team scoping is an invariant of this interface — do not add a club id
///
/// Neither method takes a club, team or coach identifier, and that is
/// deliberate. The backend derives the caller's club from the bearer token:
/// `Club/GetAllExercises` and `club/GetExercise` return only the exercises and
/// only the players belonging to **the caller's own team**. A Club coach has no
/// parameter through which to ask for another club's roster, so the boundary is
/// structural rather than a filter the client could forget to apply.
///
/// This is written down because it is the sort of thing that gets "helpfully"
/// parameterised later — someone adds `String? clubId` to make the method
/// reusable, the backend honours it, and a coach can suddenly enumerate another
/// club's players. **Adding a club/team parameter here would be a security
/// regression, not a feature.** If a genuine cross-club view is ever needed, it
/// belongs behind a separate, explicitly-authorised endpoint and a separate
/// method.
///
/// DIP: declared in `domain`, implemented in `data`. Nothing above this layer
/// knows an HTTP client exists.
abstract interface class ExerciseRepository {
  /// All exercises visible to the caller, optionally filtered.
  ///
  /// [categoryId] empty means "no category filter" — the value the category
  /// chips send when the user clears their selection.
  ///
  /// [popular] is a *query filter*, not a property of an exercise. It is passed
  /// here and nowhere else; it is not a field on [Exercise].
  ResultFuture<List<Exercise>> getExercises({
    required String categoryId,
    required bool popular,
  });

  /// One exercise, with the roster of the caller's own players on it.
  ResultFuture<ExerciseDetails> getExerciseDetails(String exerciseId);
}
