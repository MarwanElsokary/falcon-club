import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';

part 'club_team_state.freezed.dart';

@freezed
class ClubTeamState with _$ClubTeamState {
  const factory ClubTeamState.initial() = _Initial;

  //myProfile
  const factory ClubTeamState.myProfileloading() = clubProfileLoading;
  const factory ClubTeamState.myProfilesuccess(MyProfileModel myProfileModel) =
      clubProfileSuccess;
  const factory ClubTeamState.myProfileerror({required String error}) =
      clubProfileError;

  //updateProfile
  const factory ClubTeamState.updateProfileloading() = clubUpdateProfileLoading;
  const factory ClubTeamState.updateProfilesuccess(dynamic response) =
      clubUpdateProfileSuccess;
  const factory ClubTeamState.updateProfileerror({required String error}) =
      clubUpdateProfileError;

  //clubPlayers
  const factory ClubTeamState.clubPlayersloading() = clubPlayersLoading;
  const factory ClubTeamState.clubPlayerssuccess(dynamic players) =
      clubPlayersSuccess;
  const factory ClubTeamState.clubPlayerserror({required String error}) =
      clubPlayersError;

  //favorites
  const factory ClubTeamState.favloading() = favLoading;
  const factory ClubTeamState.favsuccess(dynamic players) = favSuccess;
  const factory ClubTeamState.faverror({required String error}) = favError;
  const factory ClubTeamState.addFavsuccess() = addFavSuccess;
  const factory ClubTeamState.addFaverror({required String error}) = addFavError;
  const factory ClubTeamState.removeFavsuccess() = removeFavSuccess;
  const factory ClubTeamState.removeFaverror({required String error}) =
      removeFavError;
}
