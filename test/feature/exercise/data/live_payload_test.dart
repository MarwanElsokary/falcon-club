import 'package:falconclubapp/core/thems/color_code.dart';
import 'package:falconclubapp/feature/training/data/model/all_exercises_model.dart';
import 'package:flutter/material.dart';
import 'package:falconclubapp/feature/exercise/data/models/exercise_details_model.dart';
import 'package:falconclubapp/feature/exercise/data/models/exercise_model.dart';
import 'package:falconclubapp/feature/exercise/data/models/trial_model.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_details.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_player.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/trial.dart';
import 'package:falconclubapp/shared/domain/entities/exercise.dart';
import 'package:falconclubapp/shared/domain/entities/player_position.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parsers pinned against the **real** responses, captured from the live API.
///
/// Phases 1 and 2 were written without any capture, so the shapes were inferred
/// from DTOs whose fields were all `dynamic` — evidence of key names and nothing
/// else. These tests replace inference with fact, and the assertions below are
/// copied verbatim from the recorded bodies.
void main() {
  group('GET /api/Club/GetAllExercises — real row', () {
    final Map<String, dynamic> row = <String, dynamic>{
      'id': 9,
      'photoPath':
          'https://files.fteet.ai/images/exercises/bbcebb51_test1.jpeg',
      'title': 'تمرين المرونة  (يسار)',
      'description': 'تمرين المرونة 5-0-5 (يسار) هو اختبار للسرعة والرشاقة',
      'categoryId': 2,
      'isPaid': false,
      'colorCode': '5E18EB',
      'categoryName': 'اكتشاف الموهبة',
      'categoryIcon': 'https://files.fteet.ai/images/categories/e72cd40a.png',
      'bookings': 18,
      'skills': <dynamic>['الدوران', 'السرعة'],
    };

    test('every field lands where it should', () {
      final Exercise exercise = ExerciseModel.fromJson(row);

      expect(exercise.id, '9');
      expect(exercise.title, 'تمرين المرونة  (يسار)');
      expect(exercise.categoryId, '2', reason: 'int id, stringified verbatim');
      expect(exercise.categoryName, 'اكتشاف الموهبة');
      expect(exercise.bookingsCount, 18);
      expect(exercise.isPaid, isFalse);
      expect(exercise.skillNames, <String>['الدوران', 'السرعة']);
      expect(exercise.hasPhoto, isTrue);
    });

    // The field the client ignored while cycling a hard-coded palette by index.
    test('colorCode is read', () {
      expect(ExerciseModel.fromJson(row).colorCode, '5E18EB');
    });

    // The Home slider and the trial cards still run on the legacy DTO until
    // those screens are migrated, so it has to carry the colour too — otherwise
    // they keep painting every card the same hardcoded green.
    test('the legacy AllExerciseList DTO reads colorCode as well', () {
      final AllExerciseList legacy = AllExerciseList.fromJson(row);

      expect(legacy.colorCode, '5E18EB');
      expect(
        ColorCode.parse(legacy.colorCode as String?),
        const Color(0xFF5E18EB),
      );
    });

    // Exercise 37 in the live response really does come back with no skills.
    test('an exercise with an empty skills array parses', () {
      final Exercise exercise = ExerciseModel.fromJson(<String, dynamic>{
        'id': 37,
        'title': 'تمرين دقدقة اللمسة الأولى',
        'bookings': 0,
        'skills': <dynamic>[],
        'colorCode': '5E18EB',
      });

      expect(exercise.skillNames, isEmpty);
      expect(exercise.bookingsCount, 0);
    });
  });

  group('GET /api/Club/GetExercise — real body', () {
    final Map<String, dynamic> body = <String, dynamic>{
      'message': 'Success',
      'data': <String, dynamic>{
        'id': 9,
        'photoPath': 'https://files.fteet.ai/images/exercises/bbcebb51.jpeg',
        'title': 'تمرين المرونة  (يسار)',
        'description': 'تمرين المرونة 5-0-5',
        'videos': <dynamic>[
          <String, dynamic>{
            'video':
                'https://files.fteet.ai/Videos/HLS/Exercises/4f5ef268.m3u8',
            'description': 'يقوم اللاعب بالجري من القمع الأول إلى الثاني',
            'number': 1,
          },
          <String, dynamic>{
            'video':
                'https://files.fteet.ai/Videos/HLS/Exercises/73a4f763.m3u8',
            'description': 'يقوم اللاعب بالجري من القمع الأول إلى الثاني',
            'number': 505,
          },
        ],
        'skills': <dynamic>['الدوران', 'السرعة'],
        'equipments': <dynamic>[
          <String, dynamic>{
            'name': 'أقماع العدد 2',
            'image': 'https://files.fteet.ai/Images/Exercises/892a02e5.jpg',
          },
        ],
        'playerInstructions': <dynamic>[
          'المسافة بين القمعين خمسة متر',
          'الإنطلاقة من يسار الكاميرا إلى اليمين',
        ],
        'players': <dynamic>[
          <String, dynamic>{
            'id': '005d572f-4676-4b95-82e1-ed54bf5fb359',
            'photo': null,
            'age': 0,
            'name': 'عبدالله شداد الرشيدي',
            'position': null,
            'attemptCount': 2,
          },
          <String, dynamic>{
            'id': '487265b8-2369-4918-b3b8-79e91698faad',
            'photo': 'https://files.fteet.ai/Images/Users/d1a4eca6.jpg',
            'age': 10,
            'name': 'أدم عزام  الشويكي',
            'position': null,
            'attemptCount': 3,
          },
        ],
      },
    };

    late ExerciseDetails details;

    setUp(() => details = ExerciseDetailsModel.fromJson(body));

    // `equipments: [{name, image}]` was a guess in Phase 2. It was right.
    test('equipment and videos parse as guessed', () {
      expect(details.equipment.single.name, 'أقماع العدد 2');
      expect(details.equipment.single.hasImage, isTrue);
      expect(details.videos, hasLength(2));
      expect(details.videos.last.number, 505);
      expect(details.playerInstructions, hasLength(2));
    });

    // The Phase 1 call: this endpoint returns `players`, and never `attempts` /
    // `score` / `attemptsCount`. The live body confirms it — those three keys do
    // not appear at all.
    test('the response carries players and NO attempts branch', () {
      expect(body['data'], isNot(contains('attempts')));
      expect(body['data'], isNot(contains('score')));
      expect(body['data'], isNot(contains('attemptsCount')));
      expect(details.players, hasLength(2));
      expect(details.totalAttempts, 5);
    });

    // Every player in the live sample has `position: null`, and most have
    // `photo: null` and `age: 0`.
    test('null position and photo degrade instead of throwing', () {
      final ExercisePlayer withoutPhoto = details.players.first;

      expect(withoutPhoto.position, PlayerPosition.unknown);
      expect(withoutPhoto.hasPhoto, isFalse);
      expect(withoutPhoto.age, 0);
      expect(withoutPhoto.id, '005d572f-4676-4b95-82e1-ed54bf5fb359');
      expect(withoutPhoto.attemptCount, 2);
      expect(details.players.last.hasPhoto, isTrue);
    });
  });

  group('GET /api/Club/GetTrial — real body', () {
    final Map<String, dynamic> body = <String, dynamic>{
      'message': 'Success',
      'data': <String, dynamic>{
        'trialTitle': 'تجارب نادي أبطال المدينة',
        'trialPhoto': 'https://files.fteet.ai/images/trials/50db47d0.jpg',
        'minAge': 6,
        'maxAge': 10,
        'gender': 'ذكر',
        'country': 'المدينة المنورة',
        'exerciseCount': 0,
        'exercises': <dynamic>[
          <String, dynamic>{
            'id': 15,
            'photoPath':
                'https://files.fteet.ai/images/exercises/8f4c56f8.jpeg',
            'title': 'تمرين السرعة',
            'description': 'تمرين 10m Sprint',
            'colorCode': '0C5147',
            'skills': <dynamic>['السرعة', 'التسارع'],
          },
          <String, dynamic>{
            'id': 19,
            'photoPath':
                'https://files.fteet.ai/images/exercises/d9dc4f81.jpeg',
            'title': 'تمرين 7 أقماع بالقدمين',
            'description': 'يقف اللاعب أمام صف من 7 أقماع',
            'colorCode': '5E18EB',
            'skills': <dynamic>['المراوغة', 'التحكم', 'السرعة'],
          },
        ],
      },
    };

    late Trial trial;

    setUp(() => trial = TrialModel.fromJson(body));

    test('the trial parses', () {
      expect(trial.title, 'تجارب نادي أبطال المدينة');
      expect(trial.minAge, 6);
      expect(trial.maxAge, 10);
      expect(trial.hasAgeRange, isTrue);
      expect(trial.hasPhoto, isTrue);
    });

    // The live body says `exerciseCount: 0` while shipping three exercises.
    // Trusting the list over the backend's own counter was the right call.
    test('exerciseCount lies — the list is the truth', () {
      expect(body['data']['exerciseCount'], 0);
      expect(trial.exercises, hasLength(2));
      expect(trial.exerciseCount, 2);
    });

    // A trial's exercises are a THINNER row than GetAllExercises: no bookings,
    // no isPaid, no category. The tolerant defaults absorb it.
    test('a thinner exercise row parses, defaults and all', () {
      final Exercise exercise = trial.exercises.first;

      expect(exercise.id, '15');
      expect(exercise.title, 'تمرين السرعة');
      expect(exercise.colorCode, '0C5147');
      expect(exercise.skillNames, <String>['السرعة', 'التسارع']);
      expect(exercise.bookingsCount, 0, reason: 'absent from a trial row');
      expect(exercise.isPaid, isFalse, reason: 'absent from a trial row');
      expect(exercise.categoryId, isNull, reason: 'absent from a trial row');
    });
  });
}
