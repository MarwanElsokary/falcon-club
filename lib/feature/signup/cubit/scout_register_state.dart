part of 'scout_register_cubit.dart';

abstract class ScoutRegisterState {}

class ScoutRegisterInitial extends ScoutRegisterState {}

class ScoutRegisterLoading extends ScoutRegisterState {}

class ScoutRegisterSuccess extends ScoutRegisterState {
  final dynamic data;
  ScoutRegisterSuccess(this.data);
}

class ScoutRegisterError extends ScoutRegisterState {
  final String error;
  ScoutRegisterError({required this.error});
}
