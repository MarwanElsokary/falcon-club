import 'package:falconclubapp/feature/exercise/data/models/attempt_model.dart';
import 'package:falconclubapp/feature/exercise/data/models/exercise_details_model.dart';
import 'package:falconclubapp/feature/exercise/data/models/exercise_model.dart';
import 'package:falconclubapp/feature/exercise/data/models/trial_model.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_details.dart';
import 'package:falconclubapp/shared/domain/entities/attempt.dart';
import 'package:falconclubapp/shared/domain/entities/exercise.dart';
import 'package:falconclubapp/shared/domain/entities/player_position.dart';
import 'package:falconclubapp/shared/domain/entities/skill.dart';
import 'package:flutter_test/flutter_test.dart';

/// These payloads are **inferred**, not captured — there is no Postman sample for
/// any of these four endpoints. The parsers are therefore tolerant, and these
/// tests pin that tolerance: each ambiguous field is asserted in every form it
/// could plausibly arrive in, so whichever one the backend actually sends, the
/// app does not crash.
void main() {
  group('ExerciseModel', () {
    test('reads a full row', () {
      final Exercise exercise = ExerciseModel.fromJson(<String, dynamic>{
        'id': 7,
        'title': 'الجري السريع',
        'description': 'وصف',
        'photoPath': 'https://x/p.png',
        'categoryId': 3,
        'categoryName': 'تحمل',
        'categoryIcon': 'https://x/i.png',
        'skills': <dynamic>['سرعة', 'تحمل'],
        'bookings': 12,
        'isPaid': true,
      });

      expect(exercise.id, '7');
      expect(exercise.title, 'الجري السريع');
      expect(exercise.skillNames, <String>['سرعة', 'تحمل']);
      expect(exercise.bookingsCount, 12);
      expect(exercise.isPaid, isTrue);
      expect(exercise.hasPhoto, isTrue);
    });

    // The id is handed straight back as a route argument and as `ExerciseId`.
    // The screens this replaces do `int.tryParse(exerciseId) ?? 0` — silently
    // turning an unparseable id into exercise ZERO.
    test('stringifies the id verbatim, whether it arrives as int or string', () {
      expect(ExerciseModel.fromJson(<String, dynamic>{'id': 42}).id, '42');
      expect(ExerciseModel.fromJson(<String, dynamic>{'id': 'abc'}).id, 'abc');
    });

    // `bookings` is typed `dynamic` in the DTO and we have no capture.
    test('reads bookings whether it is a number, a string, or a double', () {
      int bookingsOf(Object? raw) =>
          ExerciseModel.fromJson(<String, dynamic>{'bookings': raw}).bookingsCount;

      expect(bookingsOf(12), 12);
      expect(bookingsOf('12'), 12);
      expect(bookingsOf(12.0), 12);
      expect(bookingsOf(null), 0, reason: 'absent means none, not a crash');
      expect(bookingsOf('nonsense'), 0);
    });

    // The old `AllExercisesModel.fromJson` calls `json["skills"].map(...)` with
    // no null guard, so a row without skills throws and takes down the list.
    test('a row missing every optional field still parses', () {
      final Exercise exercise = ExerciseModel.fromJson(<String, dynamic>{
        'id': 1,
      });

      expect(exercise.title, isEmpty);
      expect(exercise.skillNames, isEmpty);
      expect(exercise.bookingsCount, 0);
      expect(exercise.isPaid, isFalse);
      expect(exercise.hasPhoto, isFalse);
    });

    test('a stringified isPaid flag is read, not dropped', () {
      expect(
        ExerciseModel.fromJson(<String, dynamic>{'isPaid': 'true'}).isPaid,
        isTrue,
      );
    });
  });

  group('ExerciseDetailsModel', () {
    Map<String, dynamic> envelope(Map<String, dynamic> data) =>
        <String, dynamic>{'message': 'ok', 'data': data};

    test('reads the roster', () {
      final ExerciseDetails details = ExerciseDetailsModel.fromJson(
        envelope(<String, dynamic>{
          'id': 7,
          'title': 'تمرين',
          'photoPath': 'https://x/p.png',
          'skills': <dynamic>['سرعة'],
          'equipments': <dynamic>[
            <String, dynamic>{'name': 'كرة', 'image': 'https://x/b.png'},
          ],
          'playerInstructions': <dynamic>['تعليمة'],
          'videos': <dynamic>[
            <String, dynamic>{'video': 'https://x/v.mp4', 'number': 1},
          ],
          'players': <dynamic>[
            <String, dynamic>{
              'id': 'p1',
              'name': 'أحمد',
              'position': 'مهاجم',
              'attemptCount': 3,
              'photo': 'https://x/a.png',
              'age': 14,
            },
          ],
        }),
      );

      expect(details.id, '7');
      expect(details.equipment.single.name, 'كرة');
      expect(details.videos.single.url, 'https://x/v.mp4');
      expect(details.players.single.name, 'أحمد');
      expect(details.players.single.position, PlayerPosition.striker);
      expect(details.players.single.attemptCount, 3);
      expect(details.players.single.age, 14);
      expect(details.totalAttempts, 3);
    });

    // `players[].age` is the least-evidenced field in the whole payload.
    test('reads age in any numeric form, and survives its absence', () {
      int? ageOf(Object? raw) => ExerciseDetailsModel.fromJson(
        envelope(<String, dynamic>{
          'players': <dynamic>[
            <String, dynamic>{'age': raw},
          ],
        }),
      ).players.single.age;

      expect(ageOf(14), 14);
      expect(ageOf('14'), 14);
      expect(ageOf(14.0), 14);
      expect(ageOf(null), isNull);
      expect(ageOf('unknown'), isNull, reason: 'degrades, never throws');
    });

    test('an exercise with no roster is empty, not an error', () {
      final ExerciseDetails details = ExerciseDetailsModel.fromJson(
        envelope(<String, dynamic>{'id': 7, 'title': 'تمرين'}),
      );

      expect(details.players, isEmpty);
      expect(details.hasPlayers, isFalse);
      expect(details.equipment, isEmpty);
      expect(details.videos, isEmpty);
      expect(details.totalAttempts, 0);
    });

    test('an unknown position degrades instead of throwing', () {
      final ExerciseDetails details = ExerciseDetailsModel.fromJson(
        envelope(<String, dynamic>{
          'players': <dynamic>[
            <String, dynamic>{'name': 'x', 'position': 'شيء غريب'},
          ],
        }),
      );

      expect(details.players.single.position, PlayerPosition.unknown);
    });

    test('a video row with no url is dropped, not rendered broken', () {
      final ExerciseDetails details = ExerciseDetailsModel.fromJson(
        envelope(<String, dynamic>{
          'videos': <dynamic>[
            <String, dynamic>{'description': 'no url here'},
            <String, dynamic>{'video': 'https://x/v.mp4'},
          ],
        }),
      );

      expect(details.videos, hasLength(1));
    });
  });

  group('AttemptModel', () {
    Map<String, dynamic> attempts(List<dynamic> rows) =>
        <String, dynamic>{'message': 'ok', 'data': rows};

    test('maps isProcessed onto the status enum', () {
      final List<Attempt> parsed = AttemptModel.listFromJson(
        attempts(<dynamic>[
          <String, dynamic>{'id': 1, 'isProcessed': 0},
          <String, dynamic>{'id': 2, 'isProcessed': 1},
          <String, dynamic>{'id': 3, 'isProcessed': 2},
        ]),
      );

      expect(parsed.map((Attempt a) => a.status), <AttemptStatus>[
        AttemptStatus.underReview,
        AttemptStatus.completed,
        AttemptStatus.rejected,
      ]);
    });

    // A score of 8.7 must not truncate to 8 — that is a point of a player's
    // rating, silently lost.
    test('keeps a fractional score', () {
      final Attempt attempt = AttemptModel.fromJson(<String, dynamic>{
        'id': 1,
        'isProcessed': 1,
        'skills': <dynamic>[
          <String, dynamic>{'skill': 'سرعة', 'score': 8.7},
        ],
      });

      expect(attempt.skills.single.score, 8.7);
    });

    test('clamps an out-of-range score rather than letting it off the axis', () {
      final Attempt attempt = AttemptModel.fromJson(<String, dynamic>{
        'id': 1,
        'isProcessed': 1,
        'skills': <dynamic>[
          <String, dynamic>{'skill': 'سرعة', 'score': 140},
        ],
      });

      expect(attempt.skills.single.score, Skill.maxScore);
    });

    test('reads the analysis videos and the rejection reason', () {
      final Attempt attempt = AttemptModel.fromJson(<String, dynamic>{
        'id': 9,
        'isProcessed': 1,
        'video': 'https://x/raw.mp4',
        'aiVideo': 'https://x/ai.mp4',
        'visualizeVideo': 'https://x/vis.mp4',
      });

      expect(attempt.id, '9');
      expect(attempt.isPlayable, isTrue);
      expect(attempt.hasAnalysis, isTrue);
      expect(attempt.visualizedVideoUrl, 'https://x/vis.mp4');
    });

    // The backend sends a formatted relative label, not a timestamp. Parsing it
    // as a date (which is what this model originally did) yielded null every
    // single time.
    test('keeps the relative date label verbatim', () {
      final Attempt attempt = AttemptModel.fromJson(<String, dynamic>{
        'id': 1,
        'isProcessed': 0,
        'date': 'منذ 7 شهور',
      });

      expect(attempt.submittedLabel, 'منذ 7 شهور');
    });

    test('an empty attempts list parses to empty', () {
      expect(AttemptModel.listFromJson(attempts(<dynamic>[])), isEmpty);
    });
  });

  // Straight from the live GET /api/Club/GetPlayerAttempts response. This is the
  // shape that corrected three wrong guesses in this file; pinning it stops them
  // creeping back.
  group('the REAL GetPlayerAttempts payload', () {
    final Map<String, dynamic> live = <String, dynamic>{
      'message': 'Success',
      'data': <dynamic>[
        <String, dynamic>{
          'id': 3833,
          'video': 'https://files.fteet.ai/Videos/HLS/Attempts/f6ed3617.m3u8',
          'date': 'منذ 7 شهور',
          'isProcessed': 1,
          'rejectedReason': null,
          'aiVideo': 'Videos/HLS/AI/ed5e9d6f.m3u8',
          'visualizeVideo': null,
          'skills': <dynamic>[
            <String, dynamic>{'skill': 'Turn', 'score': 0.9794159627901327},
            <String, dynamic>{'skill': 'Speed', 'score': 2.3170328472187123},
            <String, dynamic>{'skill': 'Turn', 'score': 1.0833621481270177},
            <String, dynamic>{'skill': 'Speed', 'score': 2.3600480893210154},
          ],
        },
        <String, dynamic>{
          'id': 3882,
          'video': 'https://files.fteet.ai/exercises/5_0_5_left/3882/clip.mp4',
          'date': 'منذ 3 شهور',
          'isProcessed': 2,
          'rejectedReason': 'لا يوجد ما يكفي من الأقماع في الفيديو',
          'aiVideo': null,
          'visualizeVideo': null,
          'skills': <dynamic>[],
        },
      ],
    };

    late List<Attempt> parsed;

    setUp(() => parsed = AttemptModel.listFromJson(live));

    test('parses both attempts', () => expect(parsed, hasLength(2)));

    test('scores are on a 0-10 scale and survive as fractions', () {
      final Attempt processed = parsed.first;

      expect(processed.status, AttemptStatus.completed);
      expect(processed.skills.first.score, closeTo(0.979, 0.001));
      // Would have been 0.0098 of the axis under the old maxScore of 100.
      expect(processed.skills.first.ratio, closeTo(0.0979, 0.001));
    });

    // One attempt lists the SAME skill twice — one entry per run of the drill.
    test('the same skill can appear more than once in one attempt', () {
      final List<String> names = parsed.first.skills
          .map((Skill s) => s.name)
          .toList();

      expect(names, <String>['Turn', 'Speed', 'Turn', 'Speed']);
      // Averaged across runs, matching what the existing card already does.
      expect(parsed.first.overallScore, closeTo(1.685, 0.001));
    });

    test('a rejected attempt carries its reason and no score', () {
      final Attempt rejected = parsed.last;

      expect(rejected.status, AttemptStatus.rejected);
      expect(rejected.rejectionReason, isNotNull);
      expect(rejected.skills, isEmpty);
      expect(rejected.overallScore, 0);
      expect(rejected.hasAnalysis, isFalse);
    });

    // aiVideo is RELATIVE while video is absolute. Stored as sent; resolving the
    // host is a Phase 6 decision, not something to guess here.
    test('the relative aiVideo path is preserved, not mangled', () {
      expect(parsed.first.aiVideoUrl, 'Videos/HLS/AI/ed5e9d6f.m3u8');
      expect(parsed.first.videoUrl, startsWith('https://'));
    });
  });

  group('TrialModel', () {
    test('reads the trial and its exercises', () {
      final trial = TrialModel.fromJson(<String, dynamic>{
        'data': <String, dynamic>{
          'trialTitle': 'تجربة',
          'trialPhoto': 'https://x/t.png',
          'minAge': 10,
          'maxAge': 14,
          'exercises': <dynamic>[
            <String, dynamic>{'id': 1, 'title': 'تمرين'},
          ],
        },
      });

      expect(trial.title, 'تجربة');
      expect(trial.hasAgeRange, isTrue);
      expect(trial.exerciseCount, 1);
      expect(trial.exercises.single.title, 'تمرين');
    });

    // The live screen interpolates minAge/maxAge with no null check and renders
    // the literal text "من null إلى null سنة".
    test('a trial with no ages reports no age range', () {
      final trial = TrialModel.fromJson(<String, dynamic>{
        'data': <String, dynamic>{'trialTitle': 'تجربة'},
      });

      expect(trial.hasAgeRange, isFalse);
      expect(trial.exercises, isEmpty);
    });

    test('reads stringified ages', () {
      final trial = TrialModel.fromJson(<String, dynamic>{
        'data': <String, dynamic>{
          'trialTitle': 'x',
          'minAge': '10',
          'maxAge': '14',
        },
      });

      expect(trial.minAge, 10);
      expect(trial.maxAge, 14);
    });
  });
}
