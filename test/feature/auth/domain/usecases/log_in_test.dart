import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/auth_session.dart';
import 'package:falconclubapp/feature/auth/domain/entities/login_credentials.dart';
import 'package:falconclubapp/feature/auth/domain/entities/sign_in_response.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/auth_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/session_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/log_in.dart';
import 'package:falconclubapp/shared/domain/entities/account_status.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late _MockAuthRepository authRepository;
  late _MockSessionRepository sessionRepository;
  late LogIn logIn;

  final LoginCredentials credentials = LoginCredentials(
    phone: PhoneNumber.permissive('500000005').getRight().toNullable()!,
    password: Password.trusted('secret'),
  );

  SignInResponse acceptedResponse({
    UserRole? role = UserRole.scout,
    String? token = 'jwt',
    String? userId = 'guid',
  }) => SignInResponse(
    status: AccountStatus.accepted,
    message: 'تم تسجيل الدخول بنجاح',
    role: role,
    token: token,
    userId: userId,
  );

  setUpAll(() {
    registerFallbackValue(
      const AuthSession(token: 't', userId: 'u', role: UserRole.club),
    );
    // LoginCredentials is `final`, so it cannot be subclassed by a Fake — the
    // sealing is deliberate. Register a real instance instead.
    registerFallbackValue(
      LoginCredentials(
        phone: PhoneNumber.permissive('500000005').getRight().toNullable()!,
        password: Password.trusted('secret'),
      ),
    );
  });

  setUp(() {
    authRepository = _MockAuthRepository();
    sessionRepository = _MockSessionRepository();
    logIn = LogIn(authRepository, sessionRepository);

    when(() => sessionRepository.saveSession(any()))
        .thenAnswer((_) async => const Right<Failure, void>(null));
  });

  void stubSignIn(SignInResponse response) {
    when(() => authRepository.signIn(any())).thenAnswer(
      (_) async => Right<Failure, SignInResponse>(response),
    );
  }

  group('a permitted sign-in', () {
    test('returns the session and persists it', () async {
      stubSignIn(acceptedResponse());

      final result = await logIn(credentials);

      expect(
        result.getRight().toNullable(),
        const AuthSession(token: 'jwt', userId: 'guid', role: UserRole.scout),
      );
      verify(() => sessionRepository.saveSession(any())).called(1);
    });
  });

  group('admission rules', () {
    // The live pending-approval response: a 200 with status "Warning" and NO
    // token — a successful request whose answer is "not yet". It must not
    // produce a session, and the user must see the server's own wording.
    test('refuses a pending-approval account and surfaces the server message',
        () async {
      stubSignIn(
        const SignInResponse(
          status: AccountStatus.pendingApproval,
          message: 'طلب انضمامك للتطبيق قيد الانتظار',
          role: UserRole.club,
        ),
      );

      final result = await logIn(credentials);

      expect(
        result.getLeft().toNullable()?.message,
        'طلب انضمامك للتطبيق قيد الانتظار',
      );
      verifyNever(() => sessionRepository.saveSession(any()));
    });

    // The critical one. The backend also issues the role "Player", and players
    // are not users of this app. UserRole.fromApiValue would map an unknown
    // role to `club` — which would drop a player into the Club shell.
    test('refuses a role this app does not host, and saves nothing', () async {
      stubSignIn(acceptedResponse(role: null));

      final result = await logIn(credentials);

      expect(
        result.getLeft().toNullable()?.message,
        LogIn.unsupportedRoleMessage,
      );
      verifyNever(() => sessionRepository.saveSession(any()));
    });

    test('refuses an accepted response that carries no token', () async {
      stubSignIn(acceptedResponse(token: null));

      final result = await logIn(credentials);

      expect(result.getLeft().toNullable(), isA<ServerFailure>());
      verifyNever(() => sessionRepository.saveSession(any()));
    });

    test('refuses an accepted response that carries no user id', () async {
      stubSignIn(acceptedResponse(userId: ''));

      final result = await logIn(credentials);

      expect(result.getLeft().toNullable(), isA<ServerFailure>());
      verifyNever(() => sessionRepository.saveSession(any()));
    });

    test('refuses an unknown status — fail closed', () async {
      stubSignIn(
        const SignInResponse(
          status: AccountStatus.unknown,
          message: 'something unexpected',
          role: UserRole.club,
          token: 'jwt',
          userId: 'guid',
        ),
      );

      final result = await logIn(credentials);

      expect(result.isLeft(), isTrue);
      verifyNever(() => sessionRepository.saveSession(any()));
    });
  });

  group('failures', () {
    test('propagates a transport failure without touching storage', () async {
      when(() => authRepository.signIn(any())).thenAnswer(
        (_) async => const Left<Failure, SignInResponse>(NetworkFailure()),
      );

      final result = await logIn(credentials);

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
      verifyNever(() => sessionRepository.saveSession(any()));
    });

    // If we cannot remember the session, we are not logged in. Reporting
    // success here would leave the app "signed in" with an empty keystore —
    // and the next cold start would bounce the user back to onboarding.
    test('fails the sign-in when the session cannot be persisted', () async {
      stubSignIn(acceptedResponse());
      when(() => sessionRepository.saveSession(any())).thenAnswer(
        (_) async => const Left<Failure, void>(CacheFailure()),
      );

      final result = await logIn(credentials);

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });
}
