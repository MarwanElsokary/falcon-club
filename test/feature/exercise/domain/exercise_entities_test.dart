import 'package:falconclubapp/feature/exercise/domain/entities/exercise_details.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_player.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/trial.dart';
import 'package:falconclubapp/shared/domain/entities/attempt.dart';
import 'package:falconclubapp/shared/domain/entities/player_position.dart';
import 'package:falconclubapp/shared/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';

ExercisePlayer _player({
  String name = 'أحمد',
  int attempts = 0,
  String position = 'مهاجم',
}) => ExercisePlayer(
  id: name,
  name: name,
  position: PlayerPosition.fromApiValue(position),
  attemptCount: attempts,
);

void main() {
  group('ExercisePlayer', () {
    test('maps the backend position label onto the shared enum', () {
      expect(_player(position: 'حارس').position, PlayerPosition.goalkeeper);
      expect(_player(position: 'مهاجم').position, PlayerPosition.striker);
    });

    test(
      'an unrecognised position degrades instead of crashing the roster',
      () {
        expect(
          _player(position: 'لاعب احتياطي').position,
          PlayerPosition.unknown,
        );
      },
    );

    // Two of the three widgets this replaces index `name[0]` with no guard,
    // which throws on a player whose name came back empty.
    test('an empty name yields a placeholder initial, not a RangeError', () {
      expect(_player(name: '').initial, '؟');
      expect(_player(name: '   ').initial, '؟');
    });

    test('hasAttempts distinguishes zero from some', () {
      expect(_player(attempts: 0).hasAttempts, isFalse);
      expect(_player(attempts: 3).hasAttempts, isTrue);
    });
  });

  group('ExerciseDetails', () {
    test('sums attempts across the visible roster', () {
      const ExerciseDetails details = ExerciseDetails(
        id: '7',
        title: 'الجري السريع',
      );

      final ExerciseDetails withPlayers = ExerciseDetails(
        id: details.id,
        title: details.title,
        players: <ExercisePlayer>[
          _player(name: 'a', attempts: 2),
          _player(name: 'b', attempts: 3),
        ],
      );

      expect(details.totalAttempts, 0);
      expect(details.hasPlayers, isFalse);
      expect(withPlayers.totalAttempts, 5);
      expect(withPlayers.hasPlayers, isTrue);
    });

    test(
      'an exercise with no photo says so rather than handing out a null',
      () {
        const ExerciseDetails details = ExerciseDetails(id: '7', title: 'x');

        expect(details.hasPhoto, isFalse);
      },
    );
  });

  group('Trial', () {
    test('an incomplete age band is not rendered as "من null إلى null"', () {
      const Trial noAges = Trial(title: 'تجربة');
      const Trial halfBand = Trial(title: 'تجربة', minAge: 10);
      const Trial fullBand = Trial(title: 'تجربة', minAge: 10, maxAge: 14);

      expect(noAges.hasAgeRange, isFalse);
      expect(halfBand.hasAgeRange, isFalse);
      expect(fullBand.hasAgeRange, isTrue);
    });

    test('the exercise count follows the list we actually received', () {
      const Trial trial = Trial(title: 'تجربة');

      expect(trial.exerciseCount, 0);
    });
  });

  group('Attempt', () {
    Attempt scored(List<Skill> skills, AttemptStatus status) =>
        Attempt(id: '1', status: status, skills: skills);

    test('averages the skill scores of a completed attempt', () {
      final Attempt attempt = scored(<Skill>[
        const Skill(name: 'سرعة', score: 80),
        const Skill(name: 'دقة', score: 60),
      ], AttemptStatus.completed);

      expect(attempt.overallScore, 70);
    });

    // The widget version calls `reduce` on the skill list, which throws on an
    // empty one — exactly the state an attempt sits in while under review.
    test('an attempt with no skills scores zero rather than throwing', () {
      expect(scored(<Skill>[], AttemptStatus.underReview).overallScore, 0);
      expect(scored(<Skill>[], AttemptStatus.completed).overallScore, 0);
    });

    test('an unscored status never reports a score', () {
      final List<Skill> skills = <Skill>[const Skill(name: 'سرعة', score: 90)];

      expect(scored(skills, AttemptStatus.underReview).overallScore, 0);
      expect(scored(skills, AttemptStatus.rejected).overallScore, 0);
      expect(scored(skills, AttemptStatus.completed).overallScore, 90);
    });

    test('analysis videos only exist on a completed attempt', () {
      const Attempt processing = Attempt(
        id: '1',
        status: AttemptStatus.underReview,
        aiVideoUrl: 'https://x/ai.mp4',
      );
      const Attempt done = Attempt(
        id: '2',
        status: AttemptStatus.completed,
        aiVideoUrl: 'https://x/ai.mp4',
      );

      expect(processing.hasAnalysis, isFalse);
      expect(done.hasAnalysis, isTrue);
    });

    test(
      'an unknown status code degrades to under review, never to scored',
      () {
        expect(AttemptStatus.fromCode(null), AttemptStatus.underReview);
        expect(AttemptStatus.fromCode(99), AttemptStatus.underReview);
        expect(AttemptStatus.fromCode(1), AttemptStatus.completed);
        expect(AttemptStatus.fromCode(2), AttemptStatus.rejected);
      },
    );
  });

  group('AttemptTally', () {
    test('counts each status bucket', () {
      final AttemptTally tally = AttemptTally.of(<Attempt>[
        const Attempt(id: '1', status: AttemptStatus.completed),
        const Attempt(id: '2', status: AttemptStatus.completed),
        const Attempt(id: '3', status: AttemptStatus.underReview),
        const Attempt(id: '4', status: AttemptStatus.rejected),
      ]);

      expect(tally.total, 4);
      expect(tally.completed, 2);
      expect(tally.underReview, 1);
      expect(tally.rejected, 1);
    });

    test('an empty list tallies to zeroes', () {
      final AttemptTally tally = AttemptTally.of(<Attempt>[]);

      expect(tally.total, 0);
      expect(tally.completed, 0);
    });
  });
}
