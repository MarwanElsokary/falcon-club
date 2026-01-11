import 'package:falcon/feature/reals/data/model/real_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'reals_state.freezed.dart';

@freezed
class RealsState with _$RealsState {
  const factory RealsState.initial() = _Initial;

  //reals
  const factory RealsState.realsloading() = realsLoading;
  const factory RealsState.realssuccess(RealModel realsModel) = realsSuccess;
  const factory RealsState.realserror({required String error}) = realsError;

  //toggleLikeReel
  const factory RealsState.toggleLikeReelloading() = toggleLikeReelLoading;
  const factory RealsState.toggleLikeReelsuccess() = toggleLikeReelSuccess;
  const factory RealsState.toggleLikeReelerror({required String error}) =
      toggleLikeReelError;

  const factory RealsState.addCommentloading() = addCommentLoading;
  const factory RealsState.addCommentsuccess() = addCommentSuccess;
  const factory RealsState.addCommenterror({required String error}) =
      addCommentError;
}
