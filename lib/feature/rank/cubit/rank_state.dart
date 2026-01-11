import 'package:freezed_annotation/freezed_annotation.dart';
part 'rank_state.freezed.dart';

@freezed
class RankState with _$RankState {
  const factory RankState.initial() = _Initial;

  //myProfile
  const factory RankState.rankloading() = rankLoading;
  const factory RankState.ranksuccess() = rankSuccess;
  const factory RankState.rankerror({required String error}) = rankError;
}
