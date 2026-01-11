import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/model/all_trials_model.dart';
part 'experiments_state.freezed.dart';

@freezed
class ExperimentsState with _$ExperimentsState {
  const factory ExperimentsState.initial() = _Initial;

  const factory ExperimentsState.allTrialsLoading() = allTrialsLoading;
  const factory ExperimentsState.allTrialssuccess(
    AllTrialsModel allTrialsModel,
  ) = allTrialsSuccess;
  const factory ExperimentsState.allTrialserror({required String error}) =
      allTrialsError;

  //best
  const factory ExperimentsState.bestTrialsLoading() = bestTrialsLoading;
  const factory ExperimentsState.bestTrialssuccess(
    AllTrialsModel bestTrialsModel,
  ) = bestTrialsSuccess;
  const factory ExperimentsState.bestTrialserror({required String error}) =
      bestTrialsError;
}
