import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/exercise.dart';
import '../../domain/usecases/get_exercises.dart';
import 'exercise_list_state.dart';

/// Drives the exercise list, for every role.
///
/// ## One cubit, not two
///
/// This replaces `TrainingCubit.emitallExercises` **and**
/// `ScoutTrainingCubit.fetchExercises` — the same method twice, calling the same
/// endpoint with the same arguments, differing only in class name and state
/// names. Listing exercises does not vary by role, so nothing here does either:
/// there is no `UserRole` in this file, and no `ExerciseCapability`. The
/// capability model earns its keep in Phase 4, on the players section, where a
/// real role difference exists.
///
/// ## What moved in from the widgets
///
/// The category selection lived in **two** `setState` fields on two copies of
/// the same `StatefulWidget` (`selectedFilter`, `iconSelected`), each of which
/// also called `context.read<...Cubit>()` to re-fetch. So the widget owned the
/// filter state while the cubit owned the data it filtered — and clearing the
/// pill reset one field but not the other. Both now live here, in one place,
/// where they can be tested without pumping a widget.
///
/// DIP: depends on [GetExercises], never on a repository or an HTTP client.
@injectable
class ExerciseListCubit extends Cubit<ExerciseListState> {
  ExerciseListCubit(this._getExercises) : super(const ExerciseListState());

  final GetExercises _getExercises;

  /// The unfiltered list, shown on first open.
  Future<void> loadAll() => _load(ExerciseFilter.all, selection: null);

  /// Tapping the chip that is already selected clears it — the behaviour both
  /// old widgets implemented, each in its own `if (isSelected)` branch.
  Future<void> toggleCategory(SelectedCategory category) =>
      state.isSelected(category.id) ? loadAll() : _select(category);

  /// The pill's ✕, and the pill itself, both clear the filter.
  Future<void> clearCategory() => loadAll();

  Future<void> _select(SelectedCategory category) =>
      _load(ExerciseFilter(categoryId: category.id), selection: category);

  /// The selection is applied to the state *before* the fetch, so the chip
  /// highlights immediately rather than after the round-trip.
  Future<void> _load(
    ExerciseFilter filter, {
    required SelectedCategory? selection,
  }) async {
    emit(
      state.copyWith(
        status: const ExerciseListLoading(),
        selectedCategory: selection,
        clearSelection: selection == null,
      ),
    );

    final result = await _getExercises(filter);
    if (isClosed) return;

    emit(
      state.copyWith(
        status: result.match(
          (Failure failure) => ExerciseListFailed(failure.message),
          (List<Exercise> exercises) => ExerciseListLoaded(exercises),
        ),
      ),
    );
  }
}
