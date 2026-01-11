import 'package:freezed_annotation/freezed_annotation.dart';

import '../../main_screen/data/model/my_profile_model.dart';

part 'player_profile_state.freezed.dart';

@freezed
class PlayerProfileState with _$PlayerProfileState {
  const factory PlayerProfileState.initial() = _Initial;

  const factory PlayerProfileState.playerProfileloading() =
      playerProfileLoading;
  const factory PlayerProfileState.playerProfilesuccess(
    MyProfileModel playerProfileModel,
  ) = playerProfileSuccess;
  const factory PlayerProfileState.playerProfileerror({required String error}) =
      playerProfileError;
}
