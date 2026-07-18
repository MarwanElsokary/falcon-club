/// A user's gender.
///
/// The backend encodes gender **two different ways**: the registration endpoint
/// takes an int ([apiValue] 0/1), while the profile endpoints (`Club/GetProfile`,
/// `GetProfileById`) return an Arabic label ([arabicLabel] "ذكر"/"أنثى"). Both
/// serializations live here so no caller hard-codes either.
///
/// Modelled as an enum rather than a raw int/string — this closes finding B5:
/// `LoginCubit` held `int gender = -1` and submitted `gender == -1 ? 0 : gender`,
/// silently registering a skipped field as [male]; and `club_team_cubit.dart:181`
/// type-checked profile gender for `int` — a shape the backend never sends — and
/// fell back to male on the Arabic string it actually receives. Here "unknown"
/// is a **null Gender** ([fromArabic] returns null for an unrecognised label), so
/// a value we do not recognise must be surfaced, never guessed as male.
enum Gender {
  male(apiValue: 0, arabicLabel: 'ذكر'),
  female(apiValue: 1, arabicLabel: 'أنثى');

  const Gender({required this.apiValue, required this.arabicLabel});

  /// The registration wire format (int).
  final int apiValue;

  /// The label the profile endpoints send and display (Arabic).
  final String arabicLabel;

  /// Reads the Arabic label the profile endpoints return, or `null` for a
  /// null/empty/unrecognised value ("unknown" — to be surfaced, never male).
  ///
  /// `"أنثى"` is standard Arabic for female but is not yet confirmed by a
  /// captured female-account response.
  static Gender? fromArabic(String? value) {
    final String? trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    for (final Gender gender in Gender.values) {
      if (gender.arabicLabel == trimmed) return gender;
    }
    return null;
  }
}
