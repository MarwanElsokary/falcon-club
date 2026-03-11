import 'package:bloc/bloc.dart';
import '../data/repo/player_attempts_repo.dart';
import 'player_attempts_state.dart';

class PlayerAttemptsCubit extends Cubit<PlayerAttemptsState> {
  final PlayerAttemptsRepo _repo;

  PlayerAttemptsCubit(this._repo) : super(const PlayerAttemptsState.initial());

  Future<void> fetchPlayerAttempts({
    required int exerciseId,
    required String playerId,
  }) async {
    emit(const PlayerAttemptsState.loading());
    final result = await _repo.getPlayerAttempts(
      exerciseId: exerciseId,
      playerId: playerId,
    );
    result.when(
      success: (model) => emit(PlayerAttemptsState.success(model)),
      failure: (error) => emit(
        PlayerAttemptsState.error(
          error: error.apiErrorModel.message ?? 'حدث خطأ ما',
        ),
      ),
    );
  }
}