import 'package:bloc/bloc.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_state.dart';
import 'package:falconclubapp/feature/rank/data/model/rank_model.dart';

import '../data/repo/rank_repo.dart';

class RankCubit extends Cubit<RankState> {
  final RankRepo _repo;

  RankCubit(this._repo) : super(RankState.initial());

  List<RankList> rankList = [];

  // ✅ بيتحفظ من الـ API عبر emitRank — مش من الـ cache محلياً
  bool isSubscribed = false;

  void emitRank({bool isUserSubscribed = false}) async {
    isSubscribed = isUserSubscribed;
    emit(const RankState.rankloading());

    final response = await _repo.rank();
    response.when(
      success: (rankResponse) {
        rankList
          ..clear()
          ..addAll(rankResponse.data);
        emit(RankState.ranksuccess());
      },
      failure: (error) {
        emit(RankState.rankerror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}