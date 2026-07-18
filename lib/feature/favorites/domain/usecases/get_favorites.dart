import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/favorite_player.dart';
import '../repositories/favorites_repository.dart';

/// Loads the coach's favourite players (`Club/GetFavPlayers`).
@injectable
class GetFavorites implements UseCaseWithoutInput<List<FavoritePlayer>> {
  const GetFavorites(this._repository);

  final FavoritesRepository _repository;

  @override
  ResultFuture<List<FavoritePlayer>> call() => _repository.getFavorites();
}
