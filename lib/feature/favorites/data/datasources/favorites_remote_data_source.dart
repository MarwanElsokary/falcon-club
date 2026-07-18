import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';

/// The one place the favourites feature talks to the network.
///
/// Returns decoded bodies (not entities). `Club/GetFavPlayers` is a **bare
/// array**, so [fetchFavorites] runs it through `Json.asObjectList` (which
/// expects a top-level list) rather than looking for a `data` envelope — the
/// same shape-mismatch that bit the rank screen.
abstract interface class FavoritesRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchFavorites();

  Future<void> toggleFavorite(String playerId);
}

@LazySingleton(as: FavoritesRemoteDataSource)
class RetrofitFavoritesRemoteDataSource implements FavoritesRemoteDataSource {
  const RetrofitFavoritesRemoteDataSource(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<Map<String, dynamic>>> fetchFavorites() async =>
      Json.asObjectList(await _apiService.getFav());

  @override
  Future<void> toggleFavorite(String playerId) async {
    // A blank id would toggle "nobody". Refuse before it reaches the wire.
    if (playerId.isEmpty) {
      throw const ServerException(message: FailureMessages.resourceNotFound);
    }
    // Response is only { message, playerId }; the caller re-reads the list.
    await _apiService.toggleFavPlayer(playerId);
  }
}
