import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/exercise.dart';

/// The category chip the user has picked, if any.
///
/// It carries the icon and the label as well as the id, because the filter bar
/// echoes the selection back as a pill with its icon. The two widgets this
/// replaces held `selectedFilter` (a *name*) and `iconSelected` (a URL) as two
/// separate `setState` fields, which could drift apart — and did: clicking the
/// pill's ✕ reset `selectedFilter` but left `iconSelected` set.
final class SelectedCategory extends Equatable {
  const SelectedCategory({required this.id, required this.name, this.iconUrl});

  final String id;
  final String name;
  final String? iconUrl;

  @override
  List<Object?> get props => [id, name, iconUrl];
}

/// Where the exercise list currently is.
sealed class ExerciseListStatus extends Equatable {
  const ExerciseListStatus();

  @override
  List<Object?> get props => const <Object?>[];
}

final class ExerciseListInitial extends ExerciseListStatus {
  const ExerciseListInitial();
}

final class ExerciseListLoading extends ExerciseListStatus {
  const ExerciseListLoading();
}

final class ExerciseListLoaded extends ExerciseListStatus {
  const ExerciseListLoaded(this.exercises);

  final List<Exercise> exercises;

  bool get isEmpty => exercises.isEmpty;

  @override
  List<Object?> get props => [exercises];
}

final class ExerciseListFailed extends ExerciseListStatus {
  const ExerciseListFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The screen's whole state: what is on screen, and what is selected.
///
/// Composed rather than a flat union, because the selected category must survive
/// the load it triggers. As a union it would be wiped by `Loading` and the chip
/// would visibly deselect itself mid-fetch — which is why the old widgets kept
/// the selection *outside* the cubit, in `setState`, and thereby ended up owning
/// state the cubit was supposed to own.
final class ExerciseListState extends Equatable {
  const ExerciseListState({
    this.status = const ExerciseListInitial(),
    this.selectedCategory,
  });

  final ExerciseListStatus status;
  final SelectedCategory? selectedCategory;

  bool get hasSelection => selectedCategory != null;

  bool isSelected(String categoryId) => selectedCategory?.id == categoryId;

  ExerciseListState copyWith({
    ExerciseListStatus? status,
    SelectedCategory? selectedCategory,
    bool clearSelection = false,
  }) => ExerciseListState(
    status: status ?? this.status,
    selectedCategory: clearSelection
        ? null
        : (selectedCategory ?? this.selectedCategory),
  );

  @override
  List<Object?> get props => [status, selectedCategory];
}
