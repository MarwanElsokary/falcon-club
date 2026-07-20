import 'package:falconclubapp/feature/reals/data/model/real_model.dart';
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

  //updateReel
  const factory RealsState.updateReelloading() = updateReelLoading;

  const factory RealsState.updateReelsuccess() = updateReelSuccess;

  const factory RealsState.updateReelerror({required String error}) =
      updateReelError;

  //deleteReel
  const factory RealsState.deleteReelloading() = deleteReelLoading;

  const factory RealsState.deleteReelsuccess() = deleteReelSuccess;

  const factory RealsState.deleteReelerror({required String error}) =
      deleteReelError;

  //updateComment
  const factory RealsState.updateCommentloading() = updateCommentLoading;

  const factory RealsState.updateCommentsuccess() = updateCommentSuccess;

  const factory RealsState.updateCommenterror({required String error}) =
      updateCommentError;

  //deleteComment
  const factory RealsState.deleteCommentloading() = deleteCommentLoading;

  const factory RealsState.deleteCommentsuccess() = deleteCommentSuccess;

  const factory RealsState.deleteCommenterror({required String error}) =
      deleteCommentError;
}
