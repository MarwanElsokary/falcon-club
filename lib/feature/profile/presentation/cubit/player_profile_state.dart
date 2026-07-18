import 'package:equatable/equatable.dart';

import '../../domain/entities/player_profile.dart';

/// State of a viewed player's profile (`Player/GetProfileById`).
///
/// The display half only — skills (radar chart) and the favourite toggle stay on
/// `MainCubit` for now (their own endpoints); this models just the profile fetch
/// the player screen renders.
sealed class PlayerProfileState extends Equatable {
  const PlayerProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

final class PlayerProfileInitial extends PlayerProfileState {
  const PlayerProfileInitial();
}

final class PlayerProfileLoading extends PlayerProfileState {
  const PlayerProfileLoading();
}

final class PlayerProfileLoaded extends PlayerProfileState {
  const PlayerProfileLoaded(this.profile);

  final PlayerProfile profile;

  @override
  List<Object?> get props => <Object?>[profile];
}

final class PlayerProfileFailure extends PlayerProfileState {
  const PlayerProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
