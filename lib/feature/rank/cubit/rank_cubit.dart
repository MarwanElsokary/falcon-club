import 'package:bloc/bloc.dart';
import 'package:falcon/feature/rank/cubit/rank_state.dart';
import 'package:falcon/feature/rank/data/model/rank_model.dart';

import '../data/repo/rank_repo.dart';

class RankCubit extends Cubit<RankState> {
  final RankRepo _repo;

  RankCubit(this._repo) : super(RankState.initial());

  List<RankList> rankList = [];

  void emitRank({bool isUserSubscribed = false}) async {
    emit(const RankState.rankloading());
    final response = await _repo.rank();
    response.when(
      success: (rankResponse) async {
        rankList.clear();
        rankList.addAll(rankResponse.data);
        emit(RankState.ranksuccess());
      },
      failure: (error) {
        emit(RankState.rankerror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // Always show full list — no subscription restriction
  int get displayedItemsCount => rankList.length;
}