import 'package:falconclubapp/feature/profile/data/models/player_profile_model.dart';
import 'package:falconclubapp/feature/profile/domain/entities/player_profile.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pinned to the live `Player/GetProfileById` response. The bio measurements
/// arrive null (no scan yet) and birthDate is a preformatted label — both are
/// facts this parser must preserve rather than crash on or reinterpret.
void main() {
  Map<String, dynamic> live() => <String, dynamic>{
    'message': 'Success',
    'data': <String, dynamic>{
      'userId': '279cbea7-d628-4b6c-8c3d-4a251b87a64f',
      'accountNumber': '23338627',
      'firstName': 'جسار جهاد',
      'lastName': 'الجابري',
      'email': 'a.sowied1@gmail.com',
      'phoneNumber': '0506666668',
      'birthDate': '04/02/2016',
      'direction': 'يمين',
      'height': 120,
      'weight': 40,
      'photo': 'https://files.fteet.ai/Images/Users/abc.png',
      'gender': 'ذكر',
      'branchName': 'لا يوجد',
      'branchId': null,
      'clubId': 'c6aec7ff-92c1-449b-b47a-66beadb351ae',
      'clubName': 'العلا',
      'clubImage': 'https://files.fteet.ai/images/clubs/def.png',
      'positionId': 12,
      'positionName': 'راس حربة',
      'clubJoinDate': null,
      'joinDate': '04/26/2025',
      'tps': 19.4,
      'bioArmLength': null,
      'bioShoulderWidth': null,
      'bioAvgLegAngle': null,
      'bioHeight': null,
      'bioDate': null,
      'bioImage': null,
      'isCompleted': true,
    },
  };

  test('parses the live player-profile shape', () {
    final PlayerProfile p = PlayerProfileModel.fromJson(live());

    expect(p.id, '279cbea7-d628-4b6c-8c3d-4a251b87a64f');
    expect(p.fullName, 'جسار جهاد الجابري');
    expect(p.gender, Gender.male);
    expect(p.preferredFoot, 'يمين');
    expect(p.positionName, 'راس حربة');
    expect(p.birthDateLabel, '04/02/2016');
    expect(p.height, 120);
    expect(p.weight, 40);
    expect(p.clubName, 'العلا');
    expect(p.clubImageUrl, startsWith('https://'));
    expect(p.tps, closeTo(19.4, 0.001));
    expect(p.hasPhoto, isTrue);
    expect(p.hasClub, isTrue);
  });

  test('bio measurements arrive null → hasAny false, no image', () {
    final PlayerProfile p = PlayerProfileModel.fromJson(live());

    expect(p.measurements.hasAny, isFalse);
    expect(p.measurementsImageUrl, isNull);
    expect(p.hasMeasurementsImage, isFalse);
  });

  test('stringified height/tps still parse (tolerant)', () {
    final Map<String, dynamic> json = live();
    (json['data'] as Map)['height'] = '120';
    (json['data'] as Map)['tps'] = '19.4';

    final PlayerProfile p = PlayerProfileModel.fromJson(json);

    expect(p.height, 120);
    expect(p.tps, closeTo(19.4, 0.001));
  });

  test('id falls back to "id" when "userId" is absent', () {
    final Map<String, dynamic> json = live();
    (json['data'] as Map).remove('userId');
    (json['data'] as Map)['id'] = 'fallback-id';

    final PlayerProfile p = PlayerProfileModel.fromJson(json);

    expect(p.id, 'fallback-id');
  });

  test('a present-but-empty data object degrades to empty/null, never throws', () {
    // A response with NO `data` is a contract violation caught upstream as a
    // Failure; `data` present-but-empty is the tolerant case tested here.
    final PlayerProfile p = PlayerProfileModel.fromJson(
      <String, dynamic>{'data': <String, dynamic>{}},
    );

    expect(p.id, '');
    expect(p.fullName, '');
    expect(p.gender, isNull);
    expect(p.measurements.hasAny, isFalse);
    expect(p.hasClub, isFalse);
  });
}
