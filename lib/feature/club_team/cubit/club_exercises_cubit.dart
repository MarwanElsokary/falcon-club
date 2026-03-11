import 'package:bloc/bloc.dart';
import '../data/repo/club_exercises_repo.dart';
import 'club_exercises_state.dart';

class ClubExercisesCubit extends Cubit<ClubExercisesState> {
  final ClubExercisesRepo _repo;

  ClubExercisesCubit(this._repo) : super(const ClubExercisesState.initial());

  Future<void> fetchExercises() async {
    if (state is ClubExercisesState && state.maybeWhen(success: (_) => true, orElse: () => false)) return; // cached
    emit(const ClubExercisesState.loading());
    final result = await _repo.getAllExercises();
    result.when(
      success: (model) => emit(ClubExercisesState.success(model)),
      failure: (err)   => emit(ClubExercisesState.error(
        error: err.apiErrorModel.message ?? 'حدث خطأ ما',
      )),
    );
  }
}