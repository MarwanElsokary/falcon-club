import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/favorites_repository.dart';

/// Adds or removes a player from favourites (`Club/ToggleFavPlayer`).
///
/// Success carries no value — the server returns only a message, so callers
/// re-read `GetFavorites` to learn the resulting list.
@injectable
class ToggleFavorite implements UseCase<Unit, String> {
  const ToggleFavorite(this._repository);

  final FavoritesRepository _repository;

  @override
  ResultFuture<Unit> call(String playerId) =>
      _repository.toggleFavorite(playerId);
}
