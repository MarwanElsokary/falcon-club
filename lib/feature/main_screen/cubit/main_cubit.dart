import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../training_details/data/model/exercise_details_model.dart';
import '../data/model/categories_model.dart';
import '../data/repo/main_repo.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final MainRepo _repo;

  MainCubit(this._repo) : super(const MainState.initial());
  bool update = false;
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  bool plyVideo = false;
  final GlobalKey<ScaffoldState> sliderDrawerKey = GlobalKey<ScaffoldState>();
  List<CategoriesList> categoriesList = [];
  ValueNotifier<bool> show = ValueNotifier(true);
  bool openProfile = false;

  // MARK: - myProfile
  void emitMyProfile() async {
    emit(const MainState.myProfileloading());
    final response = await _repo.myProfile();
    response.when(
      success: (myProfileResponse) async {
        CacheHelper.savemyProfile(myProfileResponse);
        emit(MainState.myProfilesuccess(myProfileResponse));
      },
      failure: (error) {
        emit(
          MainState.myProfileerror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // MARK: - profileById
  void emitProfileById({required String userId}) async {
    emit(const MainState.playerProfileloading());
    final response = await _repo.profileById(userId: userId);
    response.when(
      success: (profileByIdResponse) async {
        log('succces');
        emit(MainState.playerProfilesuccess(profileByIdResponse));

        // جلب المهارات بعد نجاح جلب البروفايل
        await emitSkills(userId: userId);
      },
      failure: (error) {
        emit(
          MainState.playerProfileerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  Future<void> emitSkills({required String userId}) async {
    log('🚀 جلب المهارات للمستخدم: $userId');

    emit(const MainState.playerSkillsloading());

    final response = await _repo.getSkills(userId: userId);

    response.when(
      success: (apiSkills) {
        log('🎉 المهارات الخام من API: ${apiSkills.length}');

        // فقط استخدم البيانات كما هي بدون أي تحويل
        emit(MainState.playerSkillssuccess(apiSkills));
      },
      failure: (error) {
        log('💥 خطأ في جلب المهارات: ${error.apiErrorModel.message}');

        // في حالة الخطأ، استخدم قائمة فارغة
        emit(MainState.playerSkillssuccess([]));
      },
    );
  }

// احذف الدوال التالية تماماً:
// 1. _convertApiSkillsToChartSkills
// 2. _getDefaultSkills
// 3. أي كود آخر يضيف مهارات إضافية

  // MARK: - categories
  void emitCategories() async {
    emit(const MainState.categoriesloading());
    final response = await _repo.categories();
    response.when(
      success: (myProfileResponse) async {
        categoriesList.clear();
        categoriesList.addAll(myProfileResponse.data);
        emit(MainState.categoriessuccess(myProfileResponse));
      },
      failure: (error) {
        emit(
          MainState.categorieserror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  playVideo() {
    emit(const MainState.playVideosuccess());
    plyVideo = !plyVideo;
    emit(const MainState.playVideosuccess());
  }
}
