import 'package:bloc/bloc.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_state.dart';
import 'package:falconclubapp/feature/rank/data/model/rank_model.dart';

import '../../../../core/cache/cach_Helper.dart';
import '../data/repo/rank_repo.dart';

class RankCubit extends Cubit<RankState> {
  final RankRepo _repo;

  RankCubit(this._repo) : super(RankState.initial());

  List<RankList> rankList = [];

  bool isSubscribed = false;

  void emitRank() async {
    if (isClosed) return;
    emit(const RankState.rankloading());

    final response = await _repo.rank();

    if (isClosed) return;

    // ✅ بنقرأ isSubscribed من الـ cache بعد ما الـ API رجع
    // في الوقت ده GetProfile يكون خلص وحدّث الـ cache
    isSubscribed = CacheHelper.getmyProfile()?.data.isSubscribed ?? false;

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