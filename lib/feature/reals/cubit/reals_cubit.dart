import 'package:bloc/bloc.dart';
import 'package:falconclubapp/feature/reals/data/repo/reals_repo.dart';
import 'package:flutter/widgets.dart';

import '../data/model/real_model.dart';
import 'reals_state.dart';

class RealsCubit extends Cubit<RealsState> {
  final RealsRepo _repo;
  RealsCubit(this._repo) : super(RealsState.initial());

  List<RealsVide> realsVide = [];
  List<Comment> videoComment = [];
  ValueNotifier<bool> show = ValueNotifier(false);

  // Notifiers للـ like
  final Map<int, ValueNotifier<bool>> likeNotifiers = {};
  final Map<int, ValueNotifier<int>> likeCountNotifiers = {};

  // Notifiers للـ comments
  final Map<int, ValueNotifier<int>> commentCountNotifiers = {};

  int reelId = 0;
  Set<int> selectedFavMap = {};
  bool addComment = true;
  int currentIndex = 0;
  TextEditingController commetnController = TextEditingController();

  // للـ Pagination
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  final int pageSize = 10; // تحميل 10 فيديوهات في كل مرة بدلاً من كلهم

  // MARK: - Initial Load
  Future<void> emitreals({
    required String playerId,
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage = 1;
      hasMoreData = true;
      realsVide.clear();
      disposeAllNotifiers(); // تنضيف الـ notifiers القديمة
    }

    emit(const RealsState.realsloading());
    final response = await _repo.reals(
      pageNumber: currentPage.toString(),
      pageSize: pageSize.toString(),
      playerId: playerId,
    );

    response.when(
      success: (realsResponse) async {
        if (refresh) {
          realsVide.clear();
        }

        realsVide.addAll(realsResponse.data);

        // تحديث hasMoreData
        hasMoreData = realsResponse.data.length >= pageSize;

        // تهيئة الـ Notifiers للبيانات الجديدة فقط
        initializeNotifiers(startIndex: realsVide.length - realsResponse.data.length);

        emit(RealsState.realssuccess(realsResponse));
      },
      failure: (error) {
        emit(RealsState.realserror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // MARK: - Load More (Pagination)
  Future<void> loadMoreReals({required String playerId}) async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    currentPage++;

    final response = await _repo.reals(
      pageNumber: currentPage.toString(),
      pageSize: pageSize.toString(),
      playerId: playerId,
    );

    response.when(
      success: (realsResponse) async {
        final oldLength = realsVide.length;
        realsVide.addAll(realsResponse.data);

        // تحديث hasMoreData
        hasMoreData = realsResponse.data.length >= pageSize;

        // تهيئة الـ Notifiers للبيانات الجديدة فقط
        initializeNotifiers(startIndex: oldLength);

        isLoadingMore = false;
        emit(RealsState.realssuccess(realsResponse));
      },
      failure: (error) {
        currentPage--; // إرجاع الصفحة في حالة الفشل
        isLoadingMore = false;
        emit(RealsState.realserror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // MARK: - Refresh
  Future<void> refreshReals({required String playerId}) async {
    await emitreals(playerId: playerId, refresh: true);
  }

  // MARK: - ToggleLikeReel
  void toggleLikeReel({required int reelId}) async {
    emit(const RealsState.toggleLikeReelloading());
    final response = await _repo.toggleLikeReel(reelId: reelId);
    response.when(
      success: (realsResponse) async {
        emit(const RealsState.toggleLikeReelsuccess());
      },
      failure: (error) {
        emit(
          RealsState.toggleLikeReelerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // MARK: - Add Comment
  void addCommentReel({required int reelId}) async {
    if (commetnController.text.trim().isEmpty) return;

    emit(const RealsState.addCommentloading());
    final response = await _repo.addComment(
      reelId: reelId,
      comment: commetnController.text.trim(),
    );
    response.when(
      success: (realsResponse) async {
        commetnController.clear();
        emit(const RealsState.addCommentsuccess());
      },
      failure: (error) {
        emit(
          RealsState.addCommenterror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // تهيئة الـ Notifiers (محسّنة)
  void initializeNotifiers({int startIndex = 0}) {
    for (int i = startIndex; i < realsVide.length; i++) {
      final reel = realsVide[i];

      // تجنب إعادة إنشاء notifiers موجودة
      if (!likeNotifiers.containsKey(reel.id)) {
        likeNotifiers[reel.id] = ValueNotifier(reel.isLiked);
        likeCountNotifiers[reel.id] = ValueNotifier(reel.likesCount ?? 0);
        commentCountNotifiers[reel.id] = ValueNotifier(reel.commentsCount ?? 0);
      }
    }
  }

  // إضافة Comment مع تحديث الـ UI
  void addCommentWithNotifier() {
    final commentCountNotifier = commentCountNotifiers[reelId];

    if (commentCountNotifier == null) return;

    // زيادة الـ count فوراً في الـ UI
    commentCountNotifier.value++;

    // تحديث الـ comments في الموديل
    final index = realsVide.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      realsVide[index].commentsCount = commentCountNotifier.value;
    }
  }

  // Toggle Like مع تحديث فوري
  void toggleLikeWithNotifier({required int reelId}) {
    final isLikedNotifier = likeNotifiers[reelId];
    final likeCountNotifier = likeCountNotifiers[reelId];

    if (isLikedNotifier == null || likeCountNotifier == null) return;

    // Toggle الحالة فوراً في الـ UI
    isLikedNotifier.value = !isLikedNotifier.value;
    likeCountNotifier.value += isLikedNotifier.value ? 1 : -1;

    // تحديث الموديل
    final index = realsVide.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      realsVide[index].isLiked = isLikedNotifier.value;
      realsVide[index].likesCount = likeCountNotifier.value;
    }
  }

  // تنظيف كل الـ notifiers
  void disposeAllNotifiers() {
    for (var notifier in likeNotifiers.values) {
      notifier.dispose();
    }
    for (var notifier in likeCountNotifiers.values) {
      notifier.dispose();
    }
    for (var notifier in commentCountNotifiers.values) {
      notifier.dispose();
    }

    likeNotifiers.clear();
    likeCountNotifiers.clear();
    commentCountNotifiers.clear();
  }

  @override
  Future<void> close() {
    disposeAllNotifiers();
    commetnController.dispose();
    show.dispose();
    return super.close();
  }
}