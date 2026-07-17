import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/exercise.dart';
import '../repositories/exercise_repository.dart';

/// How the exercise list is filtered.
///
/// A parameter object rather than two positional arguments, because
/// `(String, bool)` at a call site says nothing about which is which — and the
/// two existing cubits both pass `popular: false` unconditionally while
/// stringifying the bool by hand (`popular: '$popular'`).
final class ExerciseFilter extends Equatable {
  const ExerciseFilter({this.categoryId = '', this.popular = false});

  /// Empty means "all categories" — what the chips send when cleared.
  final String categoryId;

  final bool popular;

  /// The unfiltered list, shown on first load.
  static const ExerciseFilter all = ExerciseFilter();

  bool get hasCategory => categoryId.isNotEmpty;

  @override
  List<Object?> get props => [categoryId, popular];
}

/// Lists exercises for the current user.
///
/// SRP: one verb. It replaces `TrainingCubit.emitallExercises` **and**
/// `ScoutTrainingCubit.fetchExercises`, which are the same method twice — same
/// endpoint, same arguments, different class name. Role does not appear here,
/// because listing exercises does not vary by role.
@injectable
class GetExercises implements UseCase<List<Exercise>, ExerciseFilter> {
  const GetExercises(this._repository);

  final ExerciseRepository _repository;

  @override
  ResultFuture<List<Exercise>> call(ExerciseFilter filter) => _repository
      .getExercises(categoryId: filter.categoryId, popular: filter.popular);
}
