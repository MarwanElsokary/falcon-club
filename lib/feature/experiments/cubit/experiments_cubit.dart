import 'package:bloc/bloc.dart';

import '../data/model/all_trials_model.dart';
import '../data/repo/experiments_repo.dart';
import 'experiments_state.dart';

class ExperimentsCubit extends Cubit<ExperimentsState> {
  final ExperimentsRepo _repo;
  ExperimentsCubit(this._repo) : super(ExperimentsState.initial());

  List<AllTrialsList> allTrialsList = [];

  // MARK: - allTrials
  void emitallTrials({required String categoryId}) async {
    emit(const ExperimentsState.allTrialsLoading());
    final response = await _repo.allTrials(
      categoryId: categoryId,
      popular: 'false',
    );
    response.when(
      success: (allTrialsResponse) async {
        emit(ExperimentsState.allTrialssuccess(allTrialsResponse));
      },
      failure: (error) {
        emit(
          ExperimentsState.allTrialserror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // MARK: - bestTrials
  void emitbestTrials({required String categoryId}) async {
    emit(const ExperimentsState.bestTrialsLoading());
    final response = await _repo.allTrials(
      categoryId: categoryId,
      popular: 'true',
    );
    response.when(
      success: (bestTrialsResponse) async {
        allTrialsList.clear();
        allTrialsList.addAll(bestTrialsResponse.data);

        emit(ExperimentsState.bestTrialssuccess(bestTrialsResponse));
      },
      failure: (error) {
        emit(
          ExperimentsState.bestTrialserror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }
}
