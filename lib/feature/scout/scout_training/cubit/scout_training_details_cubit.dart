import 'package:bloc/bloc.dart';
import '../data/repo/scout_training_details_repo.dart';
import 'scout_training_details_state.dart';

/// Cubit تفاصيل التمرين للكشاف — view only
/// مفيش أي logic خاصة بـ addAttempt أو رفع فيديو
class ScoutTrainingDetailsCubit extends Cubit<ScoutTrainingDetailsState> {
  final ScoutTrainingDetailsRepo _repo;

  ScoutTrainingDetailsCubit(this._repo)
      : super(const ScoutTrainingDetailsState.initial());

  /// الـ exerciseId الحالي — بيستخدمه الـ screen
  String? currentExerciseId;

  void fetchExerciseDetails({required String exerciseId}) async {
    currentExerciseId = exerciseId;
    emit(const ScoutTrainingDetailsState.loading());

    final response = await _repo.exerciseDetails(exerciseId: exerciseId);

    response.when(
      success: (data) => emit(ScoutTrainingDetailsState.success(data)),
      failure: (error) => emit(
        ScoutTrainingDetailsState.error(
          error: error.apiErrorModel.message ?? '',
        ),
      ),
    );
  }
}