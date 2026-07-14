import 'package:falconclubapp/feature/auth/data/models/login_response_model.dart';
import 'package:falconclubapp/feature/auth/domain/entities/sign_in_response.dart';
import 'package:falconclubapp/shared/domain/entities/account_status.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The captured LoginPlayer 200. LoginClub's real shape is still unverified;
  // this model is built to tolerate a mismatch rather than throw on one.
  Map<String, dynamic> capturedBody({String role = 'Club'}) =>
      <String, dynamic>{
        'message': 'تم تسجيل الدخول بنجاح',
        'status': 'Accepted',
        'token': '<JWT>',
        'role': role,
        'userId': 'a-guid',
        'isConfirmed': true,
        'emailConfirmed': true,
        'phoneNumberConfirmed': true,
        'isSubscribed': true,
        'isCompleted': true,
        'name': 'Mohamed  salah',
      };

  group('parses the captured response shape', () {
    test('maps every field, including the ones the app ignores today', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(capturedBody()).toEntity();

      expect(response.status, AccountStatus.accepted);
      expect(response.role, UserRole.club);
      expect(response.token, '<JWT>');
      expect(response.userId, 'a-guid');
      expect(response.message, 'تم تسجيل الدخول بنجاح');
      expect(response.displayName, 'Mohamed  salah');
      expect(response.isSubscribed, isTrue);
      expect(response.isProfileCompleted, isTrue);
      expect(response.isPhoneConfirmed, isTrue);
      expect(response.hasCredentials, isTrue);
    });

    test('maps each supported role', () {
      expect(
        LoginResponseModel.fromJson(capturedBody(role: 'Scout')).toEntity().role,
        UserRole.scout,
      );
      expect(
        LoginResponseModel.fromJson(
          capturedBody(role: 'MainClub'),
        ).toEntity().role,
        UserRole.mainClub,
      );
    });

    // A Player must not be admitted. A lenient parse would default the unknown
    // role to `club` and let them into the Club shell.
    test('yields a null role for Player, so LogIn can refuse it', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(capturedBody(role: 'Player')).toEntity();

      expect(response.role, isNull);
    });
  });

  // The third account state, captured live: a 200 that is NOT a successful
  // login. Phone confirmed, admin approval outstanding.
  group('the pending-approval response', () {
    Map<String, dynamic> pendingBody() => <String, dynamic>{
      'message': 'طلب انضمامك للتطبيق قيد الانتظار',
      'role': 'Club',
      'status': 'Warning',
    };

    test('is recognised as pendingApproval, not unknown', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(pendingBody()).toEntity();

      expect(response.status, AccountStatus.pendingApproval);
      expect(response.status.canSignIn, isFalse);
    });

    test('carries no credentials — there is no token to sign in with', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(pendingBody()).toEntity();

      expect(response.hasCredentials, isFalse);
      expect(response.token, isNull);
    });

    test('keeps the server message, so the user is told why', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(pendingBody()).toEntity();

      expect(response.message, 'طلب انضمامك للتطبيق قيد الانتظار');
    });
  });

  group('tolerates a LoginClub body that differs from the guess', () {
    test('an empty body parses without throwing, and refuses entry', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(<String, dynamic>{}).toEntity();

      expect(response.status, AccountStatus.unknown);
      expect(response.status.canSignIn, isFalse);
      expect(response.role, isNull);
      expect(response.hasCredentials, isFalse);
      expect(response.message, isNotEmpty);
    });

    test('missing optional flags default to false rather than throwing', () {
      final SignInResponse response = LoginResponseModel.fromJson(
        <String, dynamic>{
          'status': 'Accepted',
          'role': 'Club',
          'token': 't',
          'userId': 'u',
        },
      ).toEntity();

      expect(response.isSubscribed, isFalse);
      expect(response.isProfileCompleted, isFalse);
      expect(response.hasCredentials, isTrue);
    });

    test('a stringified boolean is read, not dropped', () {
      final SignInResponse response = LoginResponseModel.fromJson(
        <String, dynamic>{'isSubscribed': 'true'},
      ).toEntity();

      expect(response.isSubscribed, isTrue);
    });

    test('an unexpected type in a field does not throw', () {
      final SignInResponse response = LoginResponseModel.fromJson(
        <String, dynamic>{'token': 12345, 'isSubscribed': <String>[]},
      ).toEntity();

      expect(response.token, '12345');
      expect(response.isSubscribed, isFalse);
    });

    test('never leaks the token through toString', () {
      final SignInResponse response =
          LoginResponseModel.fromJson(capturedBody()).toEntity();

      expect(response.toString(), isNot(contains('<JWT>')));
    });
  });
}
