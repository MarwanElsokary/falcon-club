import 'package:equatable/equatable.dart';

import '../../../shared/domain/entities/attempt.dart';

/// State of the past-attempts screen.
///
/// Replaces the freezed `initial/loading/success(model)/error` union that
/// carried a data-layer `PlayerAttemptsModel`. This one carries domain
/// [Attempt]s and a pre-computed [AttemptTally], so the four summary counters are
/// no longer recomputed inside `build()` on every rebuild.
sealed class PlayerAttemptsState extends Equatable {
  const PlayerAttemptsState();

  @override
  List<Object?> get props => const <Object?>[];
}

final class PlayerAttemptsInitial extends PlayerAttemptsState {
  const PlayerAttemptsInitial();
}

final class PlayerAttemptsLoading extends PlayerAttemptsState {
  const PlayerAttemptsLoading();
}

final class PlayerAttemptsLoaded extends PlayerAttemptsState {
  const PlayerAttemptsLoaded(this.attempts, this.tally);

  final List<Attempt> attempts;
  final AttemptTally tally;

  bool get isEmpty => attempts.isEmpty;

  @override
  List<Object?> get props => <Object?>[attempts, tally];
}

final class PlayerAttemptsFailure extends PlayerAttemptsState {
  const PlayerAttemptsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
