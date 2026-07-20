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

  final Map<int, ValueNotifier<bool>> likeNotifiers = {};
  final Map<int, ValueNotifier<int>> likeCountNotifiers = {};
  ValueNotifier<int> refreshTrigger = ValueNotifier(0);
  final Map<int, ValueNotifier<int>> commentCountNotifiers = {};

  int reelId = 0;
  Set<int> selectedFavMap = {};
  bool addComment = true;
  int currentIndex = 0;
  TextEditingController commetnController = TextEditingController();

  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  final int pageSize = 10;

  /// Whose feed is loaded: '' for the global feed, or a player id when opened
  /// from a player profile.
  ///
  /// The screen used to hardcode `playerId: ''` when paginating and refreshing,
  /// so scrolling past page 1 on a player's reels appended the *global* feed and
  /// pull-to-refresh replaced their reels with it entirely. Recording it here
  /// keeps every later request on the same feed the first one asked for.
  String activePlayerId = '';

  Future<void> emitreals({
    required String playerId,
    bool refresh = false,
  }) async {
    activePlayerId = playerId;
    if (refresh) {
      currentPage = 1;
      hasMoreData = true;
      realsVide.clear();
      disposeAllNotifiers();
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

        hasMoreData = realsResponse.data.length >= pageSize;

        initializeNotifiers(
          startIndex: realsVide.length - realsResponse.data.length,
        );

        emit(RealsState.realssuccess(realsResponse));
      },
      failure: (error) {
        emit(RealsState.realserror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // MARK: - Update Reel (Description only)
  Future<void> updateReel({
    required int reelId,
    required String description,
  }) async {
    emit(const RealsState.updateReelloading());

    final response = await _repo.updateReel(
      reelId: reelId,
      description: description,
    );

    response.when(
      success: (_) {
        final index = realsVide.indexWhere((reel) => reel.id == reelId);
        if (index != -1) {
          realsVide[index].description = description;
        }
        emit(const RealsState.updateReelsuccess());
      },
      failure: (error) {
        emit(
          RealsState.updateReelerror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // MARK: - Add Comment (محليًا) - بترتبط بالـ reel.comments الأصلية كمان
  // عشان لما نرجع نفتح الكومنتات تاني، الكومنت الجديد يفضل موجود
  void addCommentLocally(Comment comment) {
    videoComment.insert(0, comment);

    final index = realsVide.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      realsVide[index].comments.insert(0, comment);
    }
  }

  // MARK: - Update Comment
  Future<void> updateComment({
    required int commentId,
    required String comment,
  }) async {
    emit(const RealsState.updateCommentloading());

    final response = await _repo.updateComment(
      commentId: commentId,
      comment: comment,
    );

    response.when(
      success: (_) {
        // تحديث في videoComment (المعروضة دلوقتي في الشاشة)
        final commentIndex = videoComment.indexWhere((c) => c.id == commentId);
        if (commentIndex != -1) {
          videoComment[commentIndex].description = comment;
        }

        // تحديث في reel.comments الأصلية (عشان تفضل متزامنة بعد الرجوع)
        final reelIndex = realsVide.indexWhere((reel) => reel.id == reelId);
        if (reelIndex != -1) {
          final reelCommentIndex = realsVide[reelIndex].comments.indexWhere(
            (c) => c.id == commentId,
          );
          if (reelCommentIndex != -1) {
            realsVide[reelIndex].comments[reelCommentIndex].description =
                comment;
          }
        }

        emit(const RealsState.updateCommentsuccess());

        // تحديث الواجهة فورًا - بنستخدم نفس الـ notifier المستخدم
        // أصلاً في AddCommentWidget، بدل أي rebuild أثقل
        show.value = !show.value;
      },
      failure: (error) {
        emit(
          RealsState.updateCommenterror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // MARK: - Delete Comment
  Future<void> deleteComment({required int commentId}) async {
    emit(const RealsState.deleteCommentloading());

    final response = await _repo.deleteComment(commentId: commentId);

    response.when(
      success: (_) {
        // حذف من videoComment (المعروضة دلوقتي في الشاشة)
        videoComment.removeWhere((c) => c.id == commentId);

        // حذف من reel.comments الأصلية + تحديث العداد
        final reelIndex = realsVide.indexWhere((reel) => reel.id == reelId);
        if (reelIndex != -1) {
          realsVide[reelIndex].comments.removeWhere((c) => c.id == commentId);

          final commentCountNotifier = commentCountNotifiers[reelId];
          if (commentCountNotifier != null && commentCountNotifier.value > 0) {
            commentCountNotifier.value--;
            realsVide[reelIndex].commentsCount = commentCountNotifier.value;
          }
        }

        emit(const RealsState.deleteCommentsuccess());

        // تحديث الواجهة فورًا
        show.value = !show.value;
      },
      failure: (error) {
        emit(
          RealsState.deleteCommenterror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // MARK: - Delete Reel
  Future<void> deleteReel({required int reelId}) async {
    emit(const RealsState.deleteReelloading());

    final response = await _repo.deleteReel(reelId: reelId);

    response.when(
      success: (_) {
        realsVide.removeWhere((reel) => reel.id == reelId);

        likeNotifiers[reelId]?.dispose();
        likeCountNotifiers[reelId]?.dispose();
        commentCountNotifiers[reelId]?.dispose();

        likeNotifiers.remove(reelId);
        likeCountNotifiers.remove(reelId);
        commentCountNotifiers.remove(reelId);

        emit(const RealsState.deleteReelsuccess());
      },
      failure: (error) {
        emit(
          RealsState.deleteReelerror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  /// Defaults to [activePlayerId] so pagination stays on the feed that was
  /// originally loaded.
  Future<void> loadMoreReals({String? playerId}) async {
    if (isLoadingMore || !hasMoreData) return;

    isLoadingMore = true;
    currentPage++;

    final response = await _repo.reals(
      pageNumber: currentPage.toString(),
      pageSize: pageSize.toString(),
      playerId: playerId ?? activePlayerId,
    );

    response.when(
      success: (realsResponse) async {
        final oldLength = realsVide.length;
        realsVide.addAll(realsResponse.data);

        hasMoreData = realsResponse.data.length >= pageSize;

        initializeNotifiers(startIndex: oldLength);

        isLoadingMore = false;
        emit(RealsState.realssuccess(realsResponse));
      },
      failure: (error) {
        currentPage--;
        isLoadingMore = false;
        emit(RealsState.realserror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // MARK: - Refresh
  /// Defaults to [activePlayerId] — refreshing a player's reels must not
  /// replace them with the global feed.
  Future<void> refreshReals({String? playerId}) async {
    await emitreals(playerId: playerId ?? activePlayerId, refresh: true);
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
  // MARK: - Add Comment
  Future<void> addCommentReel({required int reelId}) async {
    if (commetnController.text.trim().isEmpty) return;

    emit(const RealsState.addCommentloading());
    final response = await _repo.addComment(
      reelId: reelId,
      comment: commetnController.text.trim(),
    );
    response.when(
      success: (realsResponse) async {
        // 🔥 لو الباك إند ضاف commentId في الرد، بنمسكه هنا
        // ونستخدمه عشان نستبدل الـ id المؤقت (0) بتاع الكومنت المحلي
        // اللي ضفناه فورًا في addCommentLocally
        try {
          final dynamic data = realsResponse;
          final dynamic realCommentId = data is Map
              ? data['commentId']
              : (data?.commentId);

          if (realCommentId != null) {
            // أول كومنت بـ id == 0 في القايمة (المؤقت اللي لسه منتظر التأكيد)
            final placeholderIndex = videoComment.indexWhere((c) => c.id == 0);
            if (placeholderIndex != -1) {
              videoComment[placeholderIndex].id = realCommentId;
            }

            final reelIndex = realsVide.indexWhere((r) => r.id == reelId);
            if (reelIndex != -1) {
              final reelPlaceholderIndex = realsVide[reelIndex].comments
                  .indexWhere((c) => c.id == 0);
              if (reelPlaceholderIndex != -1) {
                realsVide[reelIndex].comments[reelPlaceholderIndex].id =
                    realCommentId;
              }
            }
          }
        } catch (_) {
          // لو الرد لسه من غير commentId (الباك إند لسه ماضافهوش)
          // بنسيب الكومنت بـ id=0 وممكن تتظبط لاحقًا برفريش
        }

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

  void initializeNotifiers({int startIndex = 0}) {
    for (int i = startIndex; i < realsVide.length; i++) {
      final reel = realsVide[i];

      if (!likeNotifiers.containsKey(reel.id)) {
        likeNotifiers[reel.id] = ValueNotifier(reel.isLiked);
        likeCountNotifiers[reel.id] = ValueNotifier(reel.likesCount ?? 0);
        commentCountNotifiers[reel.id] = ValueNotifier(reel.commentsCount ?? 0);
      }
    }
  }

  void addCommentWithNotifier() {
    final commentCountNotifier = commentCountNotifiers[reelId];

    if (commentCountNotifier == null) return;

    commentCountNotifier.value++;

    final index = realsVide.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      realsVide[index].commentsCount = commentCountNotifier.value;
    }
  }

  Future<void> toggleLikeWithNotifier({required int reelId}) async {
    final index = realsVide.indexWhere((reel) => reel.id == reelId);
    if (index == -1) return;

    final reel = realsVide[index];
    final isLikedNotifier = likeNotifiers[reelId];
    final likeCountNotifier = likeCountNotifiers[reelId];

    if (isLikedNotifier == null || likeCountNotifier == null) return;

    final oldIsLiked = reel.isLiked == true;
    final oldLikesCount = (reel.likesCount ?? 0) as int;

    final newIsLiked = !oldIsLiked;
    final newLikesCount = newIsLiked ? oldLikesCount + 1 : oldLikesCount - 1;

    reel.isLiked = newIsLiked;
    reel.likesCount = newLikesCount;

    isLikedNotifier.value = newIsLiked;
    likeCountNotifier.value = newLikesCount;

    emit(const RealsState.toggleLikeReelloading());

    final response = await _repo.toggleLikeReel(reelId: reelId);

    response.when(
      success: (_) {
        emit(const RealsState.toggleLikeReelsuccess());
      },
      failure: (error) {
        // rollback
        reel.isLiked = oldIsLiked;
        reel.likesCount = oldLikesCount;

        isLikedNotifier.value = oldIsLiked;
        likeCountNotifier.value = oldLikesCount;

        emit(
          RealsState.toggleLikeReelerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

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
