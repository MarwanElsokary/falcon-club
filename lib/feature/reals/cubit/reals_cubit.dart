import 'package:bloc/bloc.dart';
import 'package:falcon/feature/reals/data/repo/reals_repo.dart';
import 'package:flutter/widgets.dart';

import '../data/model/real_model.dart';
import 'reals_state.dart';

class RealsCubit extends Cubit<RealsState> {
  final RealsRepo _repo;
  RealsCubit(this._repo) : super(RealsState.initial());
  List<RealsVide> realsVide = [];

  List<Comment> videoComment = [];
  ValueNotifier<bool> show = ValueNotifier(false);
  // ⭐ الـ Notifiers
  final Map<int, ValueNotifier<bool>> likeNotifiers = {};
  final Map<int, ValueNotifier<int>> likeCountNotifiers = {};

  // ⭐ Comment Notifiers (جديد)
  final Map<int, ValueNotifier<int>> commentCountNotifiers = {};
  int reelId = 0;

  Set<int> selectedFavMap = {};
  bool addComment = true;
  int currentIndex = 0;
  TextEditingController commetnController = TextEditingController();

  // MARK: - reals
   emitreals({
    required String pageNumber,
    required String pageSize,
    required String playerId,
  }) async {
    emit(const RealsState.realsloading());
    final response = await _repo.reals(
      pageNumber: pageNumber,
      pageSize: pageSize,
      playerId: playerId,
    );
    response.when(
      success: (realsResponse) async {
        realsVide.clear();
        realsVide.addAll(realsResponse.data);
        // ⭐ هنا تهيئة الـ Notifiers
        initializeNotifiers();

        emit(RealsState.realssuccess(realsResponse));
      },
      failure: (error) {
        emit(RealsState.realserror(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // MARK: - ToggleLikeReel
  void toggleLikeReel({required int reelId}) async {
    emit(const RealsState.toggleLikeReelloading());
    final response = await _repo.toggleLikeReel(reelId: reelId);
    response.when(
      success: (realsResponse) async {
        emit(RealsState.toggleLikeReelsuccess());
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

  // MARK: - ToggleLikeReel
  void addCommentReel({required int reelId}) async {
    emit(const RealsState.addCommentloading());
    final response = await _repo.addComment(
      reelId: reelId,
      comment: commetnController.text,
    );
    response.when(
      success: (realsResponse) async {
        emit(RealsState.addCommentsuccess());
      },
      failure: (error) {
        emit(
          RealsState.addCommenterror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // تهيئة الـ Notifiers بعد ما تجيب الداتا
  // تهيئة الـ Notifiers بعد ما تجيب الداتا
  void initializeNotifiers() {
    for (var reel in realsVide) {
      likeNotifiers[reel.id] = ValueNotifier(reel.isLiked);
      likeCountNotifiers[reel.id] = ValueNotifier(reel.likesCount ?? 0);

      // ⭐ تهيئة الـ Comment Count
      commentCountNotifiers[reel.id] = ValueNotifier(reel.commentsCount ?? 0);
    }
  }

  // 🆕 فانكشن إضافة Comment جديد
  void addCommentWithNotifier() {
    final commentCountNotifier = commentCountNotifiers[reelId];

    if (commentCountNotifier == null) return;

    // زود الـ count فورًا في الـ UI
    commentCountNotifier.value++;

    // أضف الكومنت للـ list

    // حدّث الـ comments في الموديل
    final index = realsVide.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {}

    // استدعاء الـ API في الخلفية (optional)
  }

  // 🆕 الفانكشن الجديدة الخاصة بالـ ValueNotifier
  void toggleLikeWithNotifier({required int reelId}) {
    final isLikedNotifier = likeNotifiers[reelId];
    final likeCountNotifier = likeCountNotifiers[reelId];

    if (isLikedNotifier == null || likeCountNotifier == null) return;

    // Toggle الحالة فورًا في الـ UI
    isLikedNotifier.value = !isLikedNotifier.value;
    likeCountNotifier.value += isLikedNotifier.value ? 1 : -1;

    // استدعاء الـ API في الخلفية (optional)
  }

  @override
  Future<void> close() {
    // 🚨 مهم: dispose الـ notifiers
    for (var notifier in likeNotifiers.values) {
      notifier.dispose();
    }
    for (var notifier in likeCountNotifiers.values) {
      notifier.dispose();
    }
    return super.close();
  }
}
