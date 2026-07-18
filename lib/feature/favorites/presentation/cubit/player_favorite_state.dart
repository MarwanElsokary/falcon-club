import 'package:equatable/equatable.dart';

/// Whether a single viewed player is on the coach's favourites — for the heart
/// on the player-profile screen.
///
/// [PlayerFavoriteUnknown] is the pre-resolution state (membership is read from
/// `GetFavPlayers`); the heart shows but is not tappable until it resolves, so a
/// tap can't desync against a state we haven't learned yet.
/// [PlayerFavoriteActionError] carries the rolled-back flag plus a message to
/// surface once.
sealed class PlayerFavoriteState extends Equatable {
  const PlayerFavoriteState();

  /// The flag the heart renders; unknown reads as not-favourited (outline).
  bool get isFavorited => switch (this) {
    PlayerFavoriteReady(:final bool isFavorited) => isFavorited,
    PlayerFavoriteActionError(:final bool isFavorited) => isFavorited,
    PlayerFavoriteUnknown() => false,
  };

  /// Tappable only once the true state is known.
  bool get isResolved => this is! PlayerFavoriteUnknown;

  @override
  List<Object?> get props => <Object?>[];
}

final class PlayerFavoriteUnknown extends PlayerFavoriteState {
  const PlayerFavoriteUnknown();
}

final class PlayerFavoriteReady extends PlayerFavoriteState {
  const PlayerFavoriteReady(this.isFavorited);

  @override
  final bool isFavorited;

  @override
  List<Object?> get props => <Object?>[isFavorited];
}

final class PlayerFavoriteActionError extends PlayerFavoriteState {
  const PlayerFavoriteActionError(this.isFavorited, this.message);

  @override
  final bool isFavorited;
  final String message;

  @override
  List<Object?> get props => <Object?>[isFavorited, message];
}
