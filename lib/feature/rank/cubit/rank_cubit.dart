import 'package:bloc/bloc.dart';
import 'package:falcon/feature/rank/cubit/rank_state.dart';
import 'package:falcon/feature/rank/data/model/rank_model.dart';

import '../data/repo/rank_repo.dart';

class RankCubit extends Cubit<RankState> {
  final RankRepo _repo;

  RankCubit(this._repo) : super(RankState.initial());
  bool isSubscribed = false; // ✅ إضافة متغير الاشتراك
  List<RankList> rankList = [];

  void emitRank({bool isUserSubscribed = false}) async {
    // ✅ استقبال حالة الاشتراك
    isSubscribed = isUserSubscribed; // ✅ تخزين الحالة

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

  // ✅ دالة جديدة ترجع عدد العناصر المسموح عرضها
  int get displayedItemsCount {
    if (isSubscribed) {
      return rankList.length; // عرض كل الداتا
    } else {
      return rankList.length > 3 ? 3 : rankList.length; // عرض 3 فقط
    }
  }

  // MARK: - rank
}
