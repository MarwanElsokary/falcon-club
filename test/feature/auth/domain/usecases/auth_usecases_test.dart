import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/entities/auth_session.dart';
import 'package:falconclubapp/feature/auth/domain/entities/city.dart';
import 'package:falconclubapp/feature/auth/domain/entities/club_option.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/club_directory_repository.dart';
import 'package:falconclubapp/feature/auth/domain/repositories/session_repository.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_cities.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_clubs_in_city.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/log_out.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/read_session.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockClubDirectoryRepository extends Mock
    implements ClubDirectoryRepository {}

class _MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  group('GetCities', () {
    late _MockClubDirectoryRepository repository;
    late GetCities useCase;

    setUp(() {
      repository = _MockClubDirectoryRepository();
      useCase = GetCities(repository);
    });

    test('returns the cities from the repository', () async {
      const List<City> cities = <City>[City(id: '1', name: 'الرياض')];
      when(() => repository.getCities())
          .thenAnswer((_) async => const Right<Failure, List<City>>(cities));

      final result = await useCase();

      expect(result.getRight().toNullable(), cities);
      verify(() => repository.getCities()).called(1);
    });

    test('propagates a failure unchanged', () async {
      when(() => repository.getCities()).thenAnswer(
        (_) async => const Left<Failure, List<City>>(NetworkFailure()),
      );

      final result = await useCase();

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('GetClubsInCity', () {
    late _MockClubDirectoryRepository repository;
    late GetClubsInCity useCase;

    setUp(() {
      repository = _MockClubDirectoryRepository();
      useCase = GetClubsInCity(repository);
    });

    test('passes the city id through and returns its clubs', () async {
      const List<ClubOption> clubs = <ClubOption>[
        ClubOption(id: 'guid-1', name: 'نادي الهلال'),
      ];
      when(() => repository.getClubsInCity('7')).thenAnswer(
        (_) async => const Right<Failure, List<ClubOption>>(clubs),
      );

      final result = await useCase('7');

      expect(result.getRight().toNullable(), clubs);
      verify(() => repository.getClubsInCity('7')).called(1);
    });

    test('propagates a failure unchanged', () async {
      when(() => repository.getClubsInCity(any())).thenAnswer(
        (_) async => const Left<Failure, List<ClubOption>>(ServerFailure()),
      );

      final result = await useCase('7');

      expect(result.getLeft().toNullable(), isA<ServerFailure>());
    });
  });

  group('ReadSession', () {
    late _MockSessionRepository repository;
    late ReadSession useCase;

    setUp(() {
      repository = _MockSessionRepository();
      useCase = ReadSession(repository);
    });

    test('returns the stored session', () async {
      const AuthSession session = AuthSession(
        token: 'jwt',
        userId: 'guid',
        role: UserRole.mainClub,
      );
      when(() => repository.readSession()).thenAnswer(
        (_) async => const Right<Failure, AuthSession?>(session),
      );

      final result = await useCase();

      expect(result.getRight().toNullable(), session);
    });

    test('returns null when nobody is signed in', () async {
      when(() => repository.readSession()).thenAnswer(
        (_) async => const Right<Failure, AuthSession?>(null),
      );

      final result = await useCase();

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable(), isNull);
    });
  });

  group('LogOut', () {
    late _MockSessionRepository repository;
    late LogOut useCase;

    setUp(() {
      repository = _MockSessionRepository();
      useCase = LogOut(repository);
    });

    test('clears the session', () async {
      when(() => repository.clearSession())
          .thenAnswer((_) async => const Right<Failure, void>(null));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      verify(() => repository.clearSession()).called(1);
    });

    test('surfaces a failure rather than swallowing it', () async {
      when(() => repository.clearSession()).thenAnswer(
        (_) async => const Left<Failure, void>(CacheFailure()),
      );

      final result = await useCase();

      expect(result.getLeft().toNullable(), isA<CacheFailure>());
    });
  });

  group('AuthSession', () {
    test('is unusable without a token or a user id', () {
      expect(
        const AuthSession(token: '', userId: 'g', role: UserRole.club).isUsable,
        isFalse,
      );
      expect(
        const AuthSession(token: 't', userId: '', role: UserRole.club).isUsable,
        isFalse,
      );
      expect(
        const AuthSession(token: 't', userId: 'g', role: UserRole.club).isUsable,
        isTrue,
      );
    });

    test('never leaks the bearer token through toString', () {
      const AuthSession session = AuthSession(
        token: 'super-secret-jwt',
        userId: 'guid',
        role: UserRole.scout,
      );

      expect(session.toString(), isNot(contains('super-secret-jwt')));
    });
  });

}
