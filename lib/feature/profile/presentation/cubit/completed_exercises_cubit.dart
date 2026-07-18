import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/completed_exercise.dart';
import '../../domain/usecases/get_player_exercises.dart';
import 'completed_exercises_state.dart';

/// Drives the "التمارين المنجزة" section (and its full-list screen) over the
/// domain [GetPlayerExercises].
@injectable
class CompletedExercisesCubit extends Cubit<CompletedExercisesState> {
  CompletedExercisesCubit(this._getPlayerExercises)
    : super(const CompletedExercisesInitial());

  final GetPlayerExercises _getPlayerExercises;

  Future<void> load(String playerId) async {
    if (isClosed) return;
    emit(const CompletedExercisesLoading());

    final result = await _getPlayerExercises(playerId);
    if (isClosed) return;

    emit(
      result.match(
        (failure) => CompletedExercisesFailure(failure.message),
        (List<CompletedExercise> exercises) =>
            CompletedExercisesLoaded(exercises),
      ),
    );
  }
}
