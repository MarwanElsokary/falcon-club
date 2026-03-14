part of 'scout_cubit.dart';

abstract class ScoutState {}

class ScoutInitial extends ScoutState {}

class ScoutProfileLoading extends ScoutState {}

class ScoutProfileSuccess extends ScoutState {
  final dynamic profile;
  ScoutProfileSuccess(this.profile);
}

class ScoutProfileError extends ScoutState {
  final String error;
  ScoutProfileError(this.error);
}
