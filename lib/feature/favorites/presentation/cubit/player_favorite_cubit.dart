import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/favorite_player.dart';
import '../../domain/favorites_sync.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'player_favorite_state.dart';

/// Tracks and toggles one viewed player's favourite status for the heart on the
/// player-profile screen. Shares [ToggleFavorite] (`Club/ToggleFavPlayer`) with
/// the favourites grid.
///
/// There is no per-player "is favourited" endpoint, so [load] resolves it from
/// membership in `GetFavPlayers`. [toggle] flips optimistically (the heart reacts
/// instantly) and rolls back on failure — the same pattern the grid uses.
@injectable
class PlayerFavoriteCubit extends Cubit<PlayerFavoriteState> {
  PlayerFavoriteCubit(this._getFavorites, this._toggleFavorite, this._sync)
    : super(const PlayerFavoriteUnknown());

  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;
  final FavoritesSync _sync;

  Future<void> load(String playerId) async {
    final result = await _getFavorites();
    if (isClosed) return;
    result.match(
      // Can't determine membership → assume not favourited; the heart stays
      // usable and a toggle still reconciles server-side.
      (_) => emit(const PlayerFavoriteReady(false)),
      (players) => emit(
        PlayerFavoriteReady(
          players.any((FavoritePlayer p) => p.id == playerId),
        ),
      ),
    );
  }

  Future<void> toggle(String playerId) async {
    if (!state.isResolved) return; // wait until we know the true state
    final bool was = state.isFavorited;

    emit(PlayerFavoriteReady(!was)); // optimistic flip

    final result = await _toggleFavorite(playerId);
    if (isClosed) return;
    result.match(
      (failure) => emit(PlayerFavoriteActionError(was, failure.message)),
      // Confirmed → tell any open favourites grid so it updates live.
      (_) => _sync.notifyChanged(playerId),
    );
  }
}
