import 'package:falconclubapp/feature/profile/data/models/profile_model.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pinned to the live `Club/GetProfile` response (captured with a Scout token —
/// the lean own-account shape). Gender is an Arabic string and there is no
/// `remainingSubscriptionDays`; both are the load-bearing facts here.
void main() {
  Map<String, dynamic> live() => <String, dynamic>{
    'message': 'Success',
    'data': <String, dynamic>{
      'id': '3ddbcc01-364a-4d7c-8445-fff371deb1d8',
      'isSubscribed': false,
      'accountNumber': '1833',
      'firstName': 'marwan',
      'lastName': 'yasser',
      'email': 'marwan@gmail.com',
      'phoneNumber': '503249234',
      'photo': null,
      'gender': 'ذكر',
    },
  };

  test('parses the live own-profile shape', () {
    final Profile p = ProfileModel.fromJson(live(), role: UserRole.scout);

    expect(p.id, '3ddbcc01-364a-4d7c-8445-fff371deb1d8');
    expect(p.firstName, 'marwan');
    expect(p.lastName, 'yasser');
    expect(p.fullName, 'marwan yasser');
    expect(p.email, 'marwan@gmail.com');
    expect(p.phone, '503249234');
    expect(p.accountNumber, '1833');
    expect(p.photoUrl, isNull);
    expect(p.gender, Gender.male);
    // clubName is absent from the lean Scout-token capture → null (tolerant).
    expect(p.clubName, isNull);
    // positionName is likewise absent from this capture → null (tolerant).
    expect(p.positionName, isNull);
    // Role is not in the payload — it comes from the session.
    expect(p.role, UserRole.scout);
  });

  test('a present positionName is carried through (drawer subtitle)', () {
    final Map<String, dynamic> json = live();
    (json['data'] as Map)['positionName'] = 'مدرب';

    final Profile p = ProfileModel.fromJson(json, role: UserRole.club);

    expect(p.positionName, 'مدرب');
  });

  test('no remainingSubscriptionDays → remainingDays null, isActive==isSubscribed', () {
    final Profile p = ProfileModel.fromJson(live(), role: UserRole.scout);

    expect(p.subscription.isPurchased, isFalse);
    expect(p.subscription.remainingDays, isNull);
    expect(p.subscription.isActive, isFalse);
  });

  test('a subscribed account with no days field is active (days-check is null)', () {
    final Map<String, dynamic> json = live();
    (json['data'] as Map)['isSubscribed'] = true;

    final Profile p = ProfileModel.fromJson(json, role: UserRole.scout);

    expect(p.subscription.remainingDays, isNull);
    expect(p.subscription.isActive, isTrue);
  });

  test('an unrecognised gender degrades to null, never male', () {
    final Map<String, dynamic> json = live();
    (json['data'] as Map)['gender'] = 'مجهول';

    final Profile p = ProfileModel.fromJson(json, role: UserRole.scout);

    expect(p.gender, isNull);
  });

  test('a present-but-empty data object degrades to empty/null, never throws', () {
    // `data` present with no fields is the tolerant case. (A response with NO
    // `data` is a contract violation `Json.asObject` throws on, which the
    // repository turns into a Failure — deliberately not silently degraded.)
    final Profile p = ProfileModel.fromJson(
      <String, dynamic>{'data': <String, dynamic>{}},
      role: UserRole.club,
    );

    expect(p.id, '');
    expect(p.firstName, '');
    expect(p.gender, isNull);
    expect(p.subscription.isPurchased, isFalse);
    expect(p.isProfileCompleted, isTrue);
  });
}
