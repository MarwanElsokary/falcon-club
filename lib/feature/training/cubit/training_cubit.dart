import 'package:bloc/bloc.dart';
import 'package:falcon/feature/training/cubit/training_state.dart';

import '../../../core/cache/cach_Helper.dart';
import '../data/repo/training_repo.dart';

class TrainingCubit extends Cubit<TrainingState> {
  final TrainingRepo _repo;
  TrainingCubit(this._repo) : super(TrainingState.initial());


  // في TrainingCubit.dart أضف هذا
  bool get isSubscribed {
    final myProfile = CacheHelper.getmyProfile();
    return myProfile?.data.isSubscribed == true;
  }
  // MARK: - allExercises
  void emitallExercises({
    required String categoryId,
    required bool popular,
  }) async {
    emit(const TrainingState.allExercisesLoading());
    final response = await _repo.allExercises(
      categoryId: categoryId,
      popular: '$popular',
    );
    response.when(
      success: (allExercisesResponse) async {
        emit(TrainingState.allExercisessuccess(allExercisesResponse));
      },
      failure: (error) {
        emit(
          TrainingState.allExerciseserror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }
}
