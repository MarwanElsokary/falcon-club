import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/exercise.dart';

/// A trial (تجربة) — a themed collection of exercises with an eligibility band.
///
/// Named `Trial` because that is what the backend calls it (`club/GetTrial`).
/// The feature currently calling itself `experiance_details_screen` is this,
/// misspelled; and its DTO declares a top-level class literally named `Data`
/// alongside a *second* top-level `Exercise` that collides with the shared one.
///
/// ## What is deliberately missing
///
/// The payload also carries `gender`, `country` and `exerciseCount`. None of
/// them is read by any screen, and `gender` is typed `dynamic` in the DTO — so
/// whether it arrives as `0`/`1` or as an Arabic label is not something I can
/// establish from the code. Rather than guess an encoding and bake a wrong
/// mapping into the domain, they are left out. Add them when a screen needs
/// them, against a real response.
final class Trial extends Equatable {
  const Trial({
    required this.title,
    this.photoUrl,
    this.minAge,
    this.maxAge,
    this.exercises = const <Exercise>[],
  });

  final String title;
  final String? photoUrl;
  final int? minAge;
  final int? maxAge;
  final List<Exercise> exercises;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// The eligibility band is only meaningful when both ends are known.
  ///
  /// `experience_training_info_widget.dart:53` interpolates `minAge` and
  /// `maxAge` straight into a sentence with no null check, so a trial missing
  /// either renders the literal text "من null إلى null سنة" to the user.
  bool get hasAgeRange => minAge != null && maxAge != null;

  /// Trust the list we actually received over the backend's own `exerciseCount`,
  /// which can disagree with it.
  int get exerciseCount => exercises.length;

  @override
  List<Object?> get props => [title, photoUrl, minAge, maxAge, exercises];
}
