import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/model/player_attempts_model.dart';

part 'player_attempts_state.freezed.dart';

@freezed
class PlayerAttemptsState with _$PlayerAttemptsState {
  const factory PlayerAttemptsState.initial() = _Initial;
  const factory PlayerAttemptsState.loading() = _Loading;
  const factory PlayerAttemptsState.success(PlayerAttemptsModel model) = _Success;
  const factory PlayerAttemptsState.error({required String error}) = _Error;
}