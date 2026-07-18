import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/favorite_player.dart';
import '../../domain/favorites_sync.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'favorites_state.dart';

/// Drives the favourites tab over the domain.
///
/// Replaces the favourites branch of the `ClubTeamCubit` god-cubit. Reads via
/// [GetFavorites] and un-favourites via [ToggleFavorite] — optimistically
/// (the card vanishes at once), then re-reads the list as the source of truth,
/// because `ToggleFavPlayer` returns no resulting state. A failed toggle rolls
/// back and surfaces the error without tearing down the grid.
@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._getFavorites, this._toggleFavorite, this._sync)
    : super(const FavoritesInitial()) {
    // Stay in sync with toggles made elsewhere (e.g. the player-profile heart)
    // while this grid is mounted under the shell.
    _syncSub = _sync.changes.listen(_onExternalChange);
  }

  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;
  final FavoritesSync _sync;
  late final StreamSubscription<String> _syncSub;

  /// A favourite changed somewhere else. If this player is in our list they were
  /// just un-favourited → drop the card live; otherwise they were favourited →
  /// re-read to pick the new card up (we only have the id here, not the record).
  void _onExternalChange(String playerId) {
    final List<FavoritePlayer>? displayed = state.displayedPlayers;
    if (displayed != null &&
        displayed.any((FavoritePlayer p) => p.id == playerId)) {
      emit(
        FavoritesLoaded(
          displayed.where((FavoritePlayer p) => p.id != playerId).toList(),
        ),
      );
    } else {
      _refreshSilently();
    }
  }

  Future<void> load() async {
    if (isClosed) return;
    emit(const FavoritesLoading());

    final result = await _getFavorites();
    if (isClosed) return;

    emit(
      result.match(
        (failure) => FavoritesFailure(failure.message),
        (players) => FavoritesLoaded(players),
      ),
    );
  }

  /// Un-favourites [playerId] (everything in this tab is favourited, so a tap is
  /// always a removal). Optimistic: the card disappears immediately.
  Future<void> unfavorite(String playerId) async {
    // Accepts FavoritesActionError too, not just FavoritesLoaded: a failed
    // toggle leaves the grid on screen in the error state, so requiring
    // Loaded here meant every later tap returned silently — one dropped
    // request permanently disabled un-favouriting until a manual refresh.
    final List<FavoritePlayer>? original = state.displayedPlayers;
    if (original == null) return;
    emit(
      FavoritesLoaded(
        original.where((FavoritePlayer p) => p.id != playerId).toList(),
      ),
    );

    final result = await _toggleFavorite(playerId);
    if (isClosed) return;

    await result.match(
      (failure) async => emit(FavoritesActionError(original, failure.message)),
      (_) => _refreshSilently(),
    );
  }

  /// Re-reads the list without a loading flash (the optimistic list is already
  /// on screen). A refresh failure keeps the optimistic list — the toggle itself
  /// succeeded, so the card should stay gone rather than error the whole grid.
  Future<void> _refreshSilently() async {
    final result = await _getFavorites();
    if (isClosed) return;
    result.match((_) {}, (players) => emit(FavoritesLoaded(players)));
  }

  /// Manual pull-to-refresh. Re-reads without a loading flash (the grid stays
  /// under the RefreshIndicator's own spinner). On failure it keeps the list on
  /// screen and surfaces a message, rather than replacing the grid with an
  /// error; only a refresh with nothing to show falls back to the error state.
  Future<void> refresh() async {
    final result = await _getFavorites();
    if (isClosed) return;
    result.match(
      (failure) {
        // Same reasoning: a refresh that fails while the grid is already in the
        // error state must keep the grid, not collapse to a full-screen error.
        final List<FavoritePlayer>? displayed = state.displayedPlayers;
        if (displayed != null) {
          emit(FavoritesActionError(displayed, failure.message));
        } else {
          emit(FavoritesFailure(failure.message));
        }
      },
      (players) => emit(FavoritesLoaded(players)),
    );
  }

  @override
  Future<void> close() {
    _syncSub.cancel();
    return super.close();
  }
}
