import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/profile.dart';

/// State of a self-profile screen (Coach / MainClub).
///
/// Replaces the trial-and-roster-laden `ClubTeamState.myProfile*` cases that
/// carried a data-layer `MyProfileModel`. This carries the domain [Profile].
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);

  final Profile profile;

  @override
  List<Object?> get props => <Object?>[profile];
}

final class ProfileFailure extends ProfileState {
  const ProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
