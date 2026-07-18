import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/player_profile.dart';
import '../../domain/usecases/get_player_profile.dart';
import 'player_profile_state.dart';

/// Drives the player-profile screen's display over the domain.
///
/// Replaces the display half of `MainCubit.emitProfileById`, which fetched a
/// viewed player through the untyped `MyProfileModel`. Depends only on
/// [GetPlayerProfile] (DIP) and emits the domain [PlayerProfile]. Skills and the
/// favourite toggle remain on `MainCubit` (separate endpoints) — deliberately
/// out of scope here.
@injectable
class PlayerProfileCubit extends Cubit<PlayerProfileState> {
  PlayerProfileCubit(this._getPlayerProfile)
    : super(const PlayerProfileInitial());

  final GetPlayerProfile _getPlayerProfile;

  Future<void> load(String playerId) async {
    if (isClosed) return;
    emit(const PlayerProfileLoading());

    final result = await _getPlayerProfile(playerId);
    if (isClosed) return;

    emit(
      result.match(
        (failure) => PlayerProfileFailure(failure.message),
        (PlayerProfile profile) => PlayerProfileLoaded(profile),
      ),
    );
  }
}
