import 'package:equatable/equatable.dart';

import '../../domain/entities/completed_exercise.dart';

/// State of the "التمارين المنجزة" section on the player profile.
sealed class CompletedExercisesState extends Equatable {
  const CompletedExercisesState();

  @override
  List<Object?> get props => <Object?>[];
}

final class CompletedExercisesInitial extends CompletedExercisesState {
  const CompletedExercisesInitial();
}

final class CompletedExercisesLoading extends CompletedExercisesState {
  const CompletedExercisesLoading();
}

final class CompletedExercisesLoaded extends CompletedExercisesState {
  const CompletedExercisesLoaded(this.exercises);

  final List<CompletedExercise> exercises;

  @override
  List<Object?> get props => <Object?>[exercises];
}

final class CompletedExercisesFailure extends CompletedExercisesState {
  const CompletedExercisesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
