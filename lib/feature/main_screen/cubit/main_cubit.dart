import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:flutter/material.dart';

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

  Future<void> emitSkills({required String userId}) async {
    log('🚀 جلب المهارات للمستخدم: $userId');

    emit(const MainState.playerSkillsloading());

    final response = await _repo.getSkills(userId: userId);

    response.when(
      success: (apiSkills) {
        log('🎉 المهارات الخام من API: ${apiSkills.length}');
        emit(MainState.playerSkillssuccess(apiSkills));
      },
      failure: (error) {
        log('💥 خطأ في جلب المهارات: ${error.apiErrorModel.message}');
        emit(MainState.playerSkillssuccess([]));
      },
    );
  }

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
