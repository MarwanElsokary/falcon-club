import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:falconclubapp/feature/main_screen/data/model/my_profile_model.dart';
import 'package:falconclubapp/feature/club_team/data/model/player_report_model.dart';

import '../../main_club/data/model/club_trainee_model.dart';
import '../data/model/club_player_model.dart';

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

  //clubPlayers
  const factory ClubTeamState.clubPlayersloading() = clubPlayersLoading;

  // في club_team_state.dart
  const factory ClubTeamState.clubPlayerssuccess(
    Map<String, List<ClubPlayer>> players, // ← مش dynamic
  ) = clubPlayersSuccess;

  const factory ClubTeamState.clubPlayerserror({required String error}) =
      clubPlayersError;

  const factory ClubTeamState.playerReportsLoading() =
      playerReportsLoadingState;

  const factory ClubTeamState.playerReportsSuccess(List<PlayerReport> reports) =
      playerReportsSuccessState;

  const factory ClubTeamState.playerReportsError({required String error}) =
      playerReportsErrorState;

  // Trainees
  const factory ClubTeamState.clubTraineesLoading() = _ClubTraineesLoading;

  const factory ClubTeamState.clubTraineesSuccess(List<ClubTrainee> trainees) =
      _ClubTraineesSuccess;

  const factory ClubTeamState.clubTraineesError({required String error}) =
      _ClubTraineesError;

  // Delete trainee
  const factory ClubTeamState.deleteTraineeLoading() = _DeleteTraineeLoading;

  /// [message] is the backend's own confirmation text. One endpoint
  /// (`Club/DeletePlayer`) serves both the player roster and the coaches list,
  /// so the server is the only party that knows which was removed — the client
  /// must not invent role-specific copy.
  const factory ClubTeamState.deleteTraineeSuccess({required String message}) =
      _DeleteTraineeSuccess;

  const factory ClubTeamState.deleteTraineeError({required String error}) =
      _DeleteTraineeError;
}
