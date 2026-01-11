import 'package:bloc/bloc.dart';

import '../data/repo/experiance_details_repo.dart';
import 'experiance_details_state.dart';

class ExperianceDetailsCubit extends Cubit<ExperianceDetailsState> {
  final ExperianceDetailsRepo _repo;
  ExperianceDetailsCubit(this._repo) : super(ExperianceDetailsState.initial());

  // MARK: - trialsDetails
  void emittrialsDetails({required String trialId}) async {
    emit(const ExperianceDetailsState.trialsDetailsLoading());
    final response = await _repo.trialDetails(trialId: trialId);
    response.when(
      success: (trialsDetailsResponse) async {
        emit(
          ExperianceDetailsState.trialsDetailssuccess(trialsDetailsResponse),
        );
      },
      failure: (error) {
        emit(
          ExperianceDetailsState.trialsDetailserror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }
}
