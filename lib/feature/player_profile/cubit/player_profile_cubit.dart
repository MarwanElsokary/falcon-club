import 'package:bloc/bloc.dart';
import 'package:falcon/feature/player_profile/cubit/player_profile_state.dart';
import 'package:falcon/feature/player_profile/data/repo/player_profile_repo.dart';

import '../data/repo/skills_repo.dart';

class PlayerProfileCubit extends Cubit<PlayerProfileState> {
  final PlayerProfileRepo _repo;
  PlayerProfileCubit(this._repo) : super(PlayerProfileState.initial());

  // MARK: - profileById
  void emitProfileById({required String userId}) async {
    emit(const PlayerProfileState.playerProfileloading());
    final response = await _repo.profileById(userId: userId);
    response.when(
      success: (profileByIdResponse) async {
        emit(PlayerProfileState.playerProfilesuccess(profileByIdResponse));
      },
      failure: (error) {
        emit(
          PlayerProfileState.playerProfileerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }
  
}
