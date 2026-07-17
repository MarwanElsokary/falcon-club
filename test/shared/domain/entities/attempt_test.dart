import 'package:falconclubapp/shared/domain/entities/attempt.dart';
import 'package:falconclubapp/shared/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Attempt attemptWith({
    required AttemptStatus status,
    List<Skill> skills = const <Skill>[],
  }) => Attempt(id: 'attempt-1', status: status, skills: skills);

  group('AttemptStatus', () {
    // Pins the real backend contract: isProcessed is 0/1/2, NOT 0..3.
    // An earlier version of this enum invented a fourth "processing" state,
    // which shifted every code by one and would have rendered rejected
    // attempts (2) as scored.
    test('maps the backend isProcessed codes', () {
      expect(AttemptStatus.fromCode(0), AttemptStatus.underReview);
      expect(AttemptStatus.fromCode(1), AttemptStatus.completed);
      expect(AttemptStatus.fromCode(2), AttemptStatus.rejected);
    });

    test('degrades unknown codes to under-review, never to a scored state', () {
      expect(AttemptStatus.fromCode(99), AttemptStatus.underReview);
      expect(AttemptStatus.fromCode(null), AttemptStatus.underReview);
      expect(AttemptStatus.fromCode(3), AttemptStatus.underReview);
    });

    test('only completed and rejected are terminal', () {
      expect(AttemptStatus.completed.isTerminal, isTrue);
      expect(AttemptStatus.rejected.isTerminal, isTrue);
      expect(AttemptStatus.underReview.isTerminal, isFalse);
    });

    test('only completed carries a score', () {
      expect(AttemptStatus.completed.hasScore, isTrue);
      expect(AttemptStatus.rejected.hasScore, isFalse);
      expect(AttemptStatus.underReview.hasScore, isFalse);
    });
  });

  group('Attempt.overallScore', () {
    test('averages the skill scores when completed', () {
      final Attempt attempt = attemptWith(
        status: AttemptStatus.completed,
        skills: const <Skill>[
          Skill(name: 'speed', score: 80),
          Skill(name: 'control', score: 60),
        ],
      );

      expect(attempt.overallScore, 70);
    });

    // The widget this replaces (attempt_card_widget.dart:160) calls `reduce`
    // on the skill list, which throws on an empty list.
    test('returns zero for a completed attempt with no skills, not a throw', () {
      final Attempt attempt = attemptWith(status: AttemptStatus.completed);

      expect(attempt.overallScore, 0);
    });

    test('is zero while under review, even if skills are present', () {
      final Attempt attempt = attemptWith(
        status: AttemptStatus.underReview,
        skills: const <Skill>[Skill(name: 'speed', score: 90)],
      );

      expect(attempt.overallScore, 0);
    });
  });

  group('AttemptTally', () {
    test('counts each bucket', () {
      final List<Attempt> attempts = <Attempt>[
        attemptWith(status: AttemptStatus.completed),
        attemptWith(status: AttemptStatus.completed),
        attemptWith(status: AttemptStatus.underReview),
        attemptWith(status: AttemptStatus.rejected),
      ];

      final AttemptTally tally = AttemptTally.of(attempts);

      expect(tally.total, 4);
      expect(tally.completed, 2);
      expect(tally.underReview, 1);
      expect(tally.rejected, 1);
    });

    test('is all zeroes for an empty list', () {
      final AttemptTally tally = AttemptTally.of(const <Attempt>[]);

      expect(tally.total, 0);
      expect(tally.completed, 0);
      expect(tally.underReview, 0);
      expect(tally.rejected, 0);
    });
  });

  group('Skill', () {
    // The scale is 0..10, not 0..100. This test asserted 100 — a guess made
    // before any real payload existed. The live GetPlayerAttempts response
    // returns 0.979 / 2.317 / 1.083 / 2.360, and `attempt_card_widget.dart:162`
    // clamps the average to 0.0..10.0.
    test('clamps out-of-range backend values to the 0-10 scale', () {
      expect(Skill.clamped(name: 'speed', rawScore: 140).score, 10);
      expect(Skill.clamped(name: 'speed', rawScore: -5).score, 0);
    });

    test('a real score keeps its fraction and maps onto the axis', () {
      final Skill skill = Skill.clamped(name: 'Speed', rawScore: 2.317);

      expect(skill.score, closeTo(2.317, 0.001));
      // Under the old maxScore of 100 this would have been 0.023 — a genuine
      // 2.3/10 rendering as 2% of a chart axis.
      expect(skill.ratio, closeTo(0.2317, 0.001));
    });
  });
}
