import 'package:falconclubapp/feature/profile/data/models/completed_exercise_model.dart';
import 'package:falconclubapp/feature/profile/domain/entities/completed_exercise.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pinned to one element of the representative `Player/GetPlayerExercises`
/// capture. Only photo/title/count are read; the rest is ignored, and there is
/// no rating.
void main() {
  Map<String, dynamic> element() => <String, dynamic>{
    'id': 9,
    'photoPath': 'https://files.fteet.ai/images/exercises/x.jpeg',
    'title': 'تمرين المرونة (يسار)',
    'description': 'x',
    'categoryId': 2,
    'colorCode': '5E18EB',
    'categoryName': 'اكتشاف الموهبة',
    'categoryIcon': 'https://files.fteet.ai/images/categories/c.png',
    'bookings': 3,
    'skills': <String>['الدوران', 'السرعة'],
  };

  test('parses a live completed-exercise element', () {
    final CompletedExercise e = CompletedExerciseModel.fromJson(element());

    expect(e.id, '9'); // numeric id → String (the attempts route wants String)
    expect(e.title, 'تمرين المرونة (يسار)');
    expect(e.photoUrl, startsWith('https://'));
    expect(e.attemptsCount, 3); // bookings
    expect(e.hasPhoto, isTrue);
  });

  test('a missing/empty element degrades to empty/zero, never throws', () {
    final CompletedExercise e = CompletedExerciseModel.fromJson(
      <String, dynamic>{},
    );

    expect(e.id, '');
    expect(e.title, '');
    expect(e.photoUrl, isNull);
    expect(e.hasPhoto, isFalse);
    expect(e.attemptsCount, 0);
  });

  test('a null photoPath is tolerated', () {
    final Map<String, dynamic> json = element();
    json['photoPath'] = null;

    final CompletedExercise e = CompletedExerciseModel.fromJson(json);

    expect(e.photoUrl, isNull);
    expect(e.hasPhoto, isFalse);
    expect(e.attemptsCount, 3);
  });
}
