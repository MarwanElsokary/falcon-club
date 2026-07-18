import 'package:fpdart/fpdart.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/favorite_player.dart';

/// The coach's favourites list.
///
/// [getFavorites] reads `Club/GetFavPlayers` (a **bare array**, not the usual
/// `{message, data}` envelope). [toggleFavorite] hits `Club/ToggleFavPlayer`,
/// whose response carries only a message + id — no new state — so callers
/// re-read [getFavorites] as the source of truth after toggling.
abstract interface class FavoritesRepository {
  ResultFuture<List<FavoritePlayer>> getFavorites();

  ResultFuture<Unit> toggleFavorite(String playerId);
}
