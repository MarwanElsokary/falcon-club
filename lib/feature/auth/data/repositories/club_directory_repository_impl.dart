import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/club_option.dart';
import '../../domain/repositories/club_directory_repository.dart';
import '../datasources/club_directory_remote_data_source.dart';
import '../models/city_model.dart';
import '../models/club_option_model.dart';

/// [ClubDirectoryRepository] over the remote API.
///
/// This is the layer that turns DTOs into entities and exceptions into
/// [Failure]s. Callers above it see only `Either<Failure, List<City>>` — no
/// `DioException`, no `ApiResult<dynamic>`, no raw map indexing.
///
/// Contrast with the current `LoginRepo`, where 9 of 11 methods return an
/// untyped `ApiResult` and the cubit reaches into `data['status']` by hand.
@LazySingleton(as: ClubDirectoryRepository)
class ClubDirectoryRepositoryImpl implements ClubDirectoryRepository {
  const ClubDirectoryRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final ClubDirectoryRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<List<City>> getCities() async {
    try {
      final List<CityModel> cities = await _remoteDataSource.fetchCities();
      return Right<Failure, List<City>>(_toEntities(cities));
    } catch (error) {
      return Left<Failure, List<City>>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<List<ClubOption>> getClubsInCity(String cityId) async {
    try {
      final List<ClubOptionModel> clubs = await _remoteDataSource
          .fetchClubsInCity(cityId);
      return Right<Failure, List<ClubOption>>(_toClubEntities(clubs));
    } catch (error) {
      return Left<Failure, List<ClubOption>>(_errorMapper.map(error));
    }
  }

  List<City> _toEntities(List<CityModel> models) =>
      models.map((CityModel model) => model.toEntity()).toList(growable: false);

  List<ClubOption> _toClubEntities(List<ClubOptionModel> models) => models
      .map((ClubOptionModel model) => model.toEntity())
      .toList(growable: false);
}
