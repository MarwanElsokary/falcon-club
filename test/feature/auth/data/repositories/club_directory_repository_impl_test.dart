import 'package:dio/dio.dart';
import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/error/exceptions.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/data/datasources/club_directory_remote_data_source.dart';
import 'package:falconclubapp/feature/auth/data/models/city_model.dart';
import 'package:falconclubapp/feature/auth/data/models/club_option_model.dart';
import 'package:falconclubapp/feature/auth/data/repositories/club_directory_repository_impl.dart';
import 'package:falconclubapp/feature/auth/domain/entities/city.dart';
import 'package:falconclubapp/feature/auth/domain/entities/club_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteDataSource extends Mock
    implements ClubDirectoryRemoteDataSource {}

void main() {
  late _MockRemoteDataSource remoteDataSource;
  late ClubDirectoryRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockRemoteDataSource();
    repository = ClubDirectoryRepositoryImpl(
      remoteDataSource,
      const ErrorMapper(),
    );
  });

  group('getCities', () {
    test('maps DTO models to City entities', () async {
      when(() => remoteDataSource.fetchCities()).thenAnswer(
        (_) async => const <CityModel>[
          CityModel(id: '1', name: 'الرياض'),
          CityModel(id: '2', name: 'جدة'),
        ],
      );

      final result = await repository.getCities();

      expect(result.getRight().toNullable(), const <City>[
        City(id: '1', name: 'الرياض'),
        City(id: '2', name: 'جدة'),
      ]);
    });

    test('maps a ServerException to a ServerFailure', () async {
      when(() => remoteDataSource.fetchCities())
          .thenThrow(const ServerException(message: 'boom', statusCode: 500));

      final result = await repository.getCities();

      expect(result.getLeft().toNullable(), isA<ServerFailure>());
    });

    test('maps a 401 to an UnauthorizedFailure', () async {
      when(() => remoteDataSource.fetchCities()).thenThrow(
        const UnauthorizedException(message: 'nope', statusCode: 401),
      );

      final result = await repository.getCities();

      expect(result.getLeft().toNullable(), isA<UnauthorizedFailure>());
    });

    // A DioException that escapes the data source unwrapped must still become a
    // Failure — never surface to a cubit as a raw transport error.
    test('maps a Dio connection error to a NetworkFailure', () async {
      when(() => remoteDataSource.fetchCities()).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.getCities();

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });

  group('getClubsInCity', () {
    test('maps DTO models to ClubOption entities, preserving the GUID', () async {
      const String clubGuid = '6bc273f8-17e2-45c4-a281-be27a1464273';
      when(() => remoteDataSource.fetchClubsInCity('1')).thenAnswer(
        (_) async => const <ClubOptionModel>[
          ClubOptionModel(id: clubGuid, name: 'نادي الهلال'),
        ],
      );

      final result = await repository.getClubsInCity('1');

      // This GUID is what RegisterClub needs as ClubId (bug B1). It must
      // survive the mapping byte-for-byte.
      expect(result.getRight().toNullable(), const <ClubOption>[
        ClubOption(id: clubGuid, name: 'نادي الهلال'),
      ]);
    });

    test('maps a failure from the data source', () async {
      when(() => remoteDataSource.fetchClubsInCity(any()))
          .thenThrow(const ServerException(message: 'boom'));

      final result = await repository.getClubsInCity('1');

      expect(result.getLeft().toNullable(), isA<ServerFailure>());
    });
  });
}
