import 'package:equatable/equatable.dart';

/// A single rated attribute (speed, accuracy, control…) with its score.
///
/// SRP: holds a name and a score, and knows how to describe its own magnitude.
/// It does not know how it will be drawn (radar chart, bar, badge) — that is
/// the presentation layer's business.
final class Skill extends Equatable {
  const Skill({required this.name, required this.score});

  final String name;

  /// Normalised to [minScore]..[maxScore].
  final double score;

  static const double minScore = 0;
  static const double maxScore = 100;

  /// Clamps any out-of-range value the backend might send, so the UI never has
  /// to defend against it. Widgets currently clamp this inline in three places.
  factory Skill.clamped({required String name, required num rawScore}) => Skill(
    name: name,
    score: rawScore.toDouble().clamp(minScore, maxScore),
  );

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
