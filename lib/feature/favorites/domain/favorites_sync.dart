import 'dart:async';

import 'package:injectable/injectable.dart';

/// A tiny broadcast hub so a favourite toggled in one place reaches an
/// already-open favourites grid live.
///
/// The player-profile heart and the grid run on **separate** cubit instances
/// (the grid stays mounted under the shell's `IndexedStack` while a profile is
/// pushed on top), so removing a favourite from the profile must reach the grid
/// without a revisit. The codebase has no general event bus, so this is
/// deliberately scoped to favourites: publishers call [notifyChanged] after the
/// server confirms a toggle; `FavoritesCubit` listens on [changes].
@lazySingleton
class FavoritesSync {
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  /// Emits the id of a player whose favourite status just changed (server
  /// already confirmed the toggle).
  Stream<String> get changes => _controller.stream;

  void notifyChanged(String playerId) {
    if (!_controller.isClosed) _controller.add(playerId);
  }

  void dispose() => _controller.close();
}
