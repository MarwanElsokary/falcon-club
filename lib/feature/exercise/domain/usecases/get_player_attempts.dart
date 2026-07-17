import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/attempt.dart';
import '../repositories/attempt_repository.dart';

/// Identifies one player's attempts on one exercise.
final class PlayerAttemptsQuery extends Equatable {
  const PlayerAttemptsQuery({required this.exerciseId, required this.playerId});

  final String exerciseId;
  final String playerId;

  @override
  List<Object?> get props => [exerciseId, playerId];
}

/// A player's previous attempts on an exercise, in the order the backend sends
/// them.
///
/// ## Why there is no sorting here any more
///
/// This use case used to sort "newest first". It could never have worked: the
/// backend sends no timestamp. `date` arrives as `"منذ 7 شهور"` — an already
/// formatted, localised, relative label — so every `submittedAt` parsed to
/// `null` and the comparator compared nothing.
///
/// And it was worse than merely useless. `List.sort` in Dart is **not stable**,
/// so a comparator that returns `0` for every pair is free to permute the list:
/// it could have shuffled the backend's own ordering, for no benefit, on a
/// screen where order is the whole point.
///
/// With no timestamp to sort on, the backend's order is the only ordering that
/// exists, and it is passed through untouched. If a real timestamp is ever added
/// to the response, sorting belongs here — and this is the note that says so.
@injectable
class GetPlayerAttempts implements UseCase<List<Attempt>, PlayerAttemptsQuery> {
  const GetPlayerAttempts(this._repository);

  final AttemptRepository _repository;

  @override
  ResultFuture<List<Attempt>> call(PlayerAttemptsQuery query) =>
      _repository.getPlayerAttempts(
        exerciseId: query.exerciseId,
        playerId: query.playerId,
      );
}
