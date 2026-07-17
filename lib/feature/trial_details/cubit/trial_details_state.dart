import 'package:equatable/equatable.dart';

import '../../exercise/domain/entities/trial.dart';

/// State of the trial-details screen (تفاصيل التجربة).
///
/// Replaces the trial half of the old two-headed `ExperianceDetailsState`, which
/// carried a data-layer `TrialDetailsModel`. This carries the domain [Trial].
sealed class TrialDetailsState extends Equatable {
  const TrialDetailsState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class TrialDetailsInitial extends TrialDetailsState {
  const TrialDetailsInitial();
}

final class TrialDetailsLoading extends TrialDetailsState {
  const TrialDetailsLoading();
}

final class TrialDetailsLoaded extends TrialDetailsState {
  const TrialDetailsLoaded(this.trial);

  final Trial trial;

  @override
  List<Object?> get props => <Object?>[trial];
}

final class TrialDetailsFailure extends TrialDetailsState {
  const TrialDetailsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
