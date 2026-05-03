import 'package:bloc/bloc.dart';
import '../data/repo/scout_training_repo.dart';
import 'scout_training_state.dart';

class ScoutTrainingCubit extends Cubit<ScoutTrainingState> {
  final ScoutTrainingRepo _repo;

  ScoutTrainingCubit(this._repo) : super(const ScoutTrainingState.initial());

  void fetchExercises({
    required String categoryId,
    required bool popular,
  }) async {
    emit(const ScoutTrainingState.loading());

    final response = await _repo.allExercises(
      categoryId: categoryId,
      popular: '$popular',
    );

    response.when(
      success: (data) => emit(ScoutTrainingState.success(data)),
      failure: (error) => emit(
        ScoutTrainingState.error(
          error: error.apiErrorModel.message ?? '',
        ),
      ),
    );
  }
}