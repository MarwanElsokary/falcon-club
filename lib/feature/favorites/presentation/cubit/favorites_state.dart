import 'package:equatable/equatable.dart';

import '../../domain/entities/favorite_player.dart';

/// State of the favourites grid.
///
/// [FavoritesActionError] is separate from [FavoritesFailure] on purpose: a
/// failed *toggle* must keep the grid on screen (it still carries the rolled-back
/// [players]) and only surface a transient message, whereas a failed *load* has
/// nothing to show and takes the full-screen error.
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => <Object?>[];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(this.players);

  final List<FavoritePlayer> players;

  @override
  List<Object?> get props => <Object?>[players];
}

final class FavoritesFailure extends FavoritesState {
  const FavoritesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// A toggle failed and was rolled back — [players] is the restored list to keep
/// rendering, [message] is shown once (e.g. a snackbar).
final class FavoritesActionError extends FavoritesState {
  const FavoritesActionError(this.players, this.message);

  final List<FavoritePlayer> players;
  final String message;

  @override
  List<Object?> get props => <Object?>[players, message];
}
