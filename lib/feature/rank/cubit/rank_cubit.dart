import 'package:bloc/bloc.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_state.dart';
import 'package:falconclubapp/feature/rank/data/model/rank_model.dart';

import '../../../../core/helpers/subscription_helper.dart';
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

    // ✅ بنقرأ حالة الاشتراك بعد ما الـ API رجع وحدّث الـ cache
    //
    // This read `CacheHelper.getmyProfile()?.data.isSubscribed ?? false`, which
    // checks only that a plan was *bought at some point* — it ignores
    // `remainingSubscriptionDays`, so an EXPIRED subscription still unlocked the
    // full ranking. `Subscription.isActive` checks both.
    isSubscribed = isActiveSubscription();

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