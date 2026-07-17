import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../exercise/domain/entities/trial.dart';
import '../../exercise/domain/usecases/get_trial_details.dart';
import 'trial_details_state.dart';

/// Drives the trial-details screen.
///
/// ## What this replaces
///
/// The old `ExperianceDetailsCubit` was two-headed — it held trial details *and*
/// the exercise roster in one class, one state union, one repo. This is the
/// trial half, extracted: it depends only on [GetTrialDetails] (DIP) and emits a
/// domain [Trial]. The roster half stayed behind as `ExerciseRosterCubit`.
@injectable
class TrialDetailsCubit extends Cubit<TrialDetailsState> {
  TrialDetailsCubit(this._getTrialDetails)
    : super(const TrialDetailsInitial());

  final GetTrialDetails _getTrialDetails;

  Future<void> load(String trialId) async {
    if (isClosed) return;
    emit(const TrialDetailsLoading());

    final result = await _getTrialDetails(trialId);
    if (isClosed) return;

    emit(
      result.match(
        (failure) => TrialDetailsFailure(failure.message),
        (Trial trial) => TrialDetailsLoaded(trial),
      ),
    );
  }
}
