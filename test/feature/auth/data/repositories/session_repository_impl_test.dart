import 'dart:convert';

import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/error/exceptions.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/data/datasources/session_local_data_source.dart';
import 'package:falconclubapp/feature/auth/data/repositories/session_repository_impl.dart';
import 'package:falconclubapp/feature/auth/domain/entities/auth_session.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSessionLocalDataSource extends Mock
    implements SessionLocalDataSource {}

void main() {
  late _MockSessionLocalDataSource localDataSource;
  late SessionRepositoryImpl repository;

  /// A JWT whose `exp` claim is [expiry]. Only the payload segment matters —
  /// the client never verifies the signature (only the server can).
  String tokenExpiringAt(DateTime expiry) {
    final String payload = base64Url.encode(
      utf8.encode(
        jsonEncode(<String, dynamic>{
          'exp': expiry.millisecondsSinceEpoch ~/
              Duration.millisecondsPerSecond,
        }),
      ),
    );
    return 'header.$payload.signature';
  }

  final String liveToken = tokenExpiringAt(
    DateTime.now().toUtc().add(const Duration(days: 1)),
  );
  final String expiredToken = tokenExpiringAt(
    DateTime.now().toUtc().subtract(const Duration(days: 1)),
  );

  final AuthSession session = AuthSession(
    token: liveToken,
    userId: 'a-guid',
    role: UserRole.scout,
  );

  setUp(() {
    localDataSource = _MockSessionLocalDataSource();
    repository = SessionRepositoryImpl(localDataSource, const ErrorMapper());
  });

  group('readSession', () {
    test('returns a session when a LIVE token and user id are stored', () async {
      when(() => localDataSource.readToken())
          .thenAnswer((_) async => liveToken);
      when(() => localDataSource.readUserId()).thenAnswer((_) async => 'a-guid');
      when(() => localDataSource.readRole()).thenAnswer((_) async => 'Scout');

      final result = await repository.readSession();

      expect(result.getRight().toNullable()?.userId, 'a-guid');
      expect(result.getRight().toNullable()?.role, UserRole.scout);
    });

    // THE regression test for the reported security bug: a leftover token in
    // storage sent the user straight into a role shell on launch, having never
    // signed in.
    test('refuses an EXPIRED token — no session, and it is wiped', () async {
      when(() => localDataSource.readToken())
          .thenAnswer((_) async => expiredToken);
      when(() => localDataSource.readUserId()).thenAnswer((_) async => 'a-guid');
      when(() => localDataSource.readRole()).thenAnswer((_) async => 'Scout');
      when(() => localDataSource.clear()).thenAnswer((_) async {});

      final result = await repository.readSession();

      expect(result.getRight().toNullable(), isNull);
      // Self-heals: the stale token is removed rather than left to 401 forever.
      verify(() => localDataSource.clear()).called(1);
    });

    // Fails closed. An opaque/garbage token must not be treated as valid.
    test('refuses an unparseable token', () async {
      when(() => localDataSource.readToken())
          .thenAnswer((_) async => 'not-a-jwt');
      when(() => localDataSource.readUserId()).thenAnswer((_) async => 'a-guid');
      when(() => localDataSource.readRole()).thenAnswer((_) async => 'Club');
      when(() => localDataSource.clear()).thenAnswer((_) async {});

      final result = await repository.readSession();

      expect(result.getRight().toNullable(), isNull);
    });

    test('returns null — not a failure — when nothing is stored', () async {
      when(() => localDataSource.readToken()).thenAnswer((_) async => null);
      when(() => localDataSource.readUserId()).thenAnswer((_) async => null);
      when(() => localDataSource.readRole()).thenAnswer((_) async => null);

      final result = await repository.readSession();

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable(), isNull);
    });

    // A token with no user id is not a usable session. The current
    // _saveAuthData() happily persists a role with no token and logs a warning.
    test('treats a blank token as no session', () async {
      when(() => localDataSource.readToken()).thenAnswer((_) async => '');
      when(() => localDataSource.readUserId()).thenAnswer((_) async => 'a-guid');
      when(() => localDataSource.readRole()).thenAnswer((_) async => 'Club');

      final result = await repository.readSession();

      expect(result.getRight().toNullable(), isNull);
    });

    test('defaults an unknown stored role to club', () async {
      when(() => localDataSource.readToken())
          .thenAnswer((_) async => liveToken);
      when(() => localDataSource.readUserId()).thenAnswer((_) async => 'a-guid');
      when(() => localDataSource.readRole())
          .thenAnswer((_) async => 'Something');

      final result = await repository.readSession();

      expect(result.getRight().toNullable()?.role, UserRole.club);
    });

    test('maps a storage exception to a CacheFailure', () async {
      when(() => localDataSource.readToken())
          .thenThrow(const CacheException(message: 'keystore unavailable'));

      final result = await repository.readSession();

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('saveSession', () {
    test('writes the role using its API spelling, not the enum name', () async {
      when(() => localDataSource.write(
            token: any(named: 'token'),
            userId: any(named: 'userId'),
            role: any(named: 'role'),
          )).thenAnswer((_) async {});

      await repository.saveSession(session);

      // 'MainClub'/'Scout'/'Club' — what the backend and the legacy readers
      // expect. Persisting `role.name` would write 'scout' and break them.
      verify(() => localDataSource.write(
            token: liveToken,
            userId: 'a-guid',
            role: 'Scout',
          )).called(1);
    });

    test('maps a write exception to a CacheFailure', () async {
      when(() => localDataSource.write(
            token: any(named: 'token'),
            userId: any(named: 'userId'),
            role: any(named: 'role'),
          )).thenThrow(const CacheException(message: 'disk full'));

      final result = await repository.saveSession(session);

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('clearSession', () {
    test('delegates to the data source and succeeds', () async {
      when(() => localDataSource.clear()).thenAnswer((_) async {});

      final result = await repository.clearSession();

      expect(result.isRight(), isTrue);
      verify(() => localDataSource.clear()).called(1);
    });

    test('maps a clear exception to a CacheFailure', () async {
      when(() => localDataSource.clear())
          .thenThrow(const CacheException(message: 'nope'));

      final result = await repository.clearSession();

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });
}
