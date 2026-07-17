import 'package:equatable/equatable.dart';

/// A single rated attribute (speed, accuracy, control…) with its score.
///
/// SRP: holds a name and a score, and knows how to describe its own magnitude.
/// It does not know how it will be drawn (radar chart, bar, badge) — that is
/// the presentation layer's business.
final class Skill extends Equatable {
  const Skill({required this.name, required this.score});

  final String name;

  /// The AI's rating, on a **0–10** scale.
  final double score;

  static const double minScore = 0;

  /// Ten, not a hundred.
  ///
  /// This entity originally declared `maxScore = 100`, which was a guess made
  /// before any real payload existed. The live `GetPlayerAttempts` response
  /// settles it: scores come back as `0.979`, `2.317`, `1.083`, `2.360`, and
  /// `attempt_card_widget.dart:162` — the widget that has been shipping this for
  /// months — clamps the average to `0.0..10.0`.
  ///
  /// The old value was not merely cosmetic: [ratio] would have divided by 100,
  /// so a genuine 2.4/10 would have rendered as 2% of the axis on any chart or
  /// progress bar that used it.
  static const double maxScore = 10;

  /// Clamps any out-of-range value the backend might send, so the UI never has
  /// to defend against it. Widgets clamp this inline in three places today.
  factory Skill.clamped({required String name, required num rawScore}) => Skill(
    name: name,
    score: rawScore.toDouble().clamp(minScore, maxScore),
  );

  /// Position on a 0..1 axis, for charts and bars.
  double get ratio => score / maxScore;

  @override
  List<Object?> get props => [name, score];
}

/// Aggregate behaviour over a set of skills.
///
/// This is where `attempt_card_widget.dart:160`'s inline
/// `skills.map((s) => s.score).reduce((a, b) => a + b) / skills.length` belongs
/// — including the empty-list guard that the widget version is missing (it
/// throws on `reduce` of an empty list).
extension SkillScoring on List<Skill> {
  double get averageScore {
    if (isEmpty) return Skill.minScore;
    final double total = fold(
      0,
      (double sum, Skill skill) => sum + skill.score,
    );
    return total / length;
  }
}
