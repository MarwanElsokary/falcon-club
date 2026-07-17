import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../exercise/domain/usecases/get_player_attempts.dart';
import '../../../shared/domain/entities/attempt.dart';
import 'player_attempts_state.dart';

/// Drives the past-attempts screen.
///
/// ## What this replaces
///
/// The legacy cubit called `PlayerAttemptsRepo` directly and emitted a
/// data-layer `PlayerAttemptsModel`. This depends on [GetPlayerAttempts] (DIP —
/// never a repository or Dio) and emits domain [Attempt]s, with the summary
/// [AttemptTally] computed once here rather than four times inside the screen's
/// `build()`.
@injectable
class PlayerAttemptsCubit extends Cubit<PlayerAttemptsState> {
  PlayerAttemptsCubit(this._getPlayerAttempts)
    : super(const PlayerAttemptsInitial());

  final GetPlayerAttempts _getPlayerAttempts;

  Future<void> load({
    required String exerciseId,
    required String playerId,
  }) async {
    if (isClosed) return;
    emit(const PlayerAttemptsLoading());

    final result = await _getPlayerAttempts(
      PlayerAttemptsQuery(exerciseId: exerciseId, playerId: playerId),
    );
    if (isClosed) return;

    emit(
      result.match(
        (failure) => PlayerAttemptsFailure(failure.message),
        (List<Attempt> attempts) =>
            PlayerAttemptsLoaded(attempts, AttemptTally.of(attempts)),
      ),
    );
  }
}
