import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/favorite_player.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_data_source.dart';
import '../models/favorite_player_model.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final FavoritesRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<List<FavoritePlayer>> getFavorites() async {
    try {
      final List<Map<String, dynamic>> raw = await _remoteDataSource
          .fetchFavorites();
      return Right<Failure, List<FavoritePlayer>>(
        raw.map(FavoritePlayerModel.fromJson).toList(growable: false),
      );
    } catch (error) {
      return Left<Failure, List<FavoritePlayer>>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<Unit> toggleFavorite(String playerId) async {
    try {
      await _remoteDataSource.toggleFavorite(playerId);
      return const Right<Failure, Unit>(unit);
    } catch (error) {
      return Left<Failure, Unit>(_errorMapper.map(error));
    }
  }
}
