import 'package:bloc/bloc.dart';
import 'package:falcon/feature/reals/data/model/real_model.dart';
import '../data/repo/player_reels_repo.dart';

// ── State ─────────────────────────────────────────────────────────────────────
abstract class PlayerReelsState {}

class PlayerReelsInitial extends PlayerReelsState {}

class PlayerReelsLoading extends PlayerReelsState {}

class PlayerReelsSuccess extends PlayerReelsState {
  final List<RealsVide> reels;
  PlayerReelsSuccess(this.reels);
}

class PlayerReelsError extends PlayerReelsState {
  final String error;
  PlayerReelsError(this.error);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Cubit خفيف — instance واحد لكل PlayerCardWidget
/// بيجيب ريلز اللاعب مرة واحدة ويكاش النتيجة
class PlayerReelsCubit extends Cubit<PlayerReelsState> {
  final PlayerReelsRepo _repo;

  PlayerReelsCubit(this._repo) : super(PlayerReelsInitial());

  List<RealsVide> reels = [];

  Future<void> fetchReels(String playerId) async {
    if (reels.isNotEmpty) return; // cached
    emit(PlayerReelsLoading());
    final result = await _repo.getPlayerReels(playerId: playerId);
    result.when(
      success: (data) {
        reels = data;
        emit(PlayerReelsSuccess(data));
      },
      failure: (err) {
        emit(PlayerReelsError(err.apiErrorModel.message ?? 'خطأ'));
      },
    );
  }
}