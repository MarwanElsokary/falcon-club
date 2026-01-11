import 'package:falcon/feature/experiance_details_screen/data/model/trial_details_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'experiance_details_state.freezed.dart';

@freezed
class ExperianceDetailsState with _$ExperianceDetailsState {
  const factory ExperianceDetailsState.initial() = _Initial;

  const factory ExperianceDetailsState.trialsDetailsLoading() =
      trialsDetailsLoading;
  const factory ExperianceDetailsState.trialsDetailssuccess(
    TrialDetailsModel trialDetailsModel,
  ) = trialsDetailsSuccess;
  const factory ExperianceDetailsState.trialsDetailserror({
    required String error,
  }) = trialsDetailsError;
}
