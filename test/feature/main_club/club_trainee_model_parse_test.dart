import 'package:falconclubapp/feature/main_club/data/model/club_trainee_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the hardening of `ClubTrainee.fromJson`: `json['id'] as String` threw
/// when the backend sent a numeric `id` (as it does on sibling endpoints that
/// `ClubPlayer` already coerces), dropping the whole trainees list to a generic
/// error. It must now coerce instead of cast.
void main() {
  test('coerces a numeric id to String', () {
    final ClubTrainee trainee = ClubTrainee.fromJson(<String, dynamic>{
      'id': 42,
      'name': 'متدرب',
    });

    expect(trainee.id, '42');
    expect(trainee.name, 'متدرب');
  });

  test('accepts a string id unchanged', () {
    final ClubTrainee trainee = ClubTrainee.fromJson(<String, dynamic>{
      'id': 'abc',
      'name': 'متدرب',
    });

    expect(trainee.id, 'abc');
  });

  test('a missing id becomes empty, not a thrown cast', () {
    final ClubTrainee trainee =
        ClubTrainee.fromJson(<String, dynamic>{'name': 'بلا معرف'});

    expect(trainee.id, '');
    expect(trainee.name, 'بلا معرف');
  });

  test('optional fields tolerate absence', () {
    final ClubTrainee trainee =
        ClubTrainee.fromJson(<String, dynamic>{'id': 1, 'name': 'x'});

    expect(trainee.phone, isNull);
    expect(trainee.gender, isNull);
  });
}
