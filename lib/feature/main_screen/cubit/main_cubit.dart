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
    log('🚀 emitSkills called');

    // إذا كنا بالفعل في حالة نجاح، لا نحتاج لإعادة جلب البيانات
    if (state is playerSkillsSuccess) {
      log('⚠️ Skills already loaded, skipping');
      return;
    }

    emit(const MainState.playerSkillsloading());

    final response = await _repo.getSkills(userId: userId);

    response.when(
      success: (apiSkills) {
        log('🎉 Raw skills from API: ${apiSkills.length}');

        // تحويل مهارات API إلى المهارات المطلوبة للرادار تشارت
        final skillsForChart = _convertApiSkillsToChartSkills(apiSkills);

        log('🎉 Converted skills for chart: ${skillsForChart.length}');
        for (var skill in skillsForChart) {
          log('   - ${skill.skillName}: ${skill.score}');
        }

        emit(MainState.playerSkillssuccess(skillsForChart));
      },
      failure: (error) {
        log('💥 Skills error: ${error.apiErrorModel.message}');

        // في حالة الخطأ، استخدم مهارات افتراضية
        final defaultSkills = _getDefaultSkills();
        log('🔄 Using default skills due to error');
        emit(MainState.playerSkillssuccess(defaultSkills));
      },
    );
  }

  // دالة لتحويل مهارات API إلى المهارات المطلوبة
  List<Skill> _convertApiSkillsToChartSkills(List<Skill> apiSkills) {
    // قيم افتراضية لجميع المهارات (ليست صفراً لتظهر بشكل أفضل)
    final skillsMap = {
      'السرعة': 0.0,
      'القوة': 0.0,
      'المرونه': 0.0,
      'التحكم': 0.0,
      'الالتحام': 0.0,
    };

    // تحديث القيم من API
    for (var apiSkill in apiSkills) {
      if (apiSkill.skillName == 'القوة') {
        skillsMap['القوة'] = apiSkill.score;
        log('🎯 Found القوة: ${apiSkill.score}');
      } else if (apiSkill.skillName == 'المرونة') {
        skillsMap['المراوغة'] = apiSkill.score;
        log('🎯 Found المرونة : ${apiSkill.score}');
      } else if (skillsMap.containsKey(apiSkill.skillName)) {
        skillsMap[apiSkill.skillName] = apiSkill.score;
        log('🎯 Updated ${apiSkill.skillName}: ${apiSkill.score}');
      }
    }

    final skillsList = skillsMap.entries.map((entry) {
      return Skill(skillName: entry.key, score: entry.value);
    }).toList();

    for (var skill in skillsList) {
      log('   - ${skill.skillName}: ${skill.score}');
    }

    return skillsList;
  }

  // دالة للحصول على مهارات افتراضية
  List<Skill> _getDefaultSkills() {
    return [
      Skill(skillName: 'السرعة', score: 0.0),
      Skill(skillName: 'القوة', score: 0.0),
      Skill(skillName: 'المرونه', score: 0.0),
      Skill(skillName: 'التحكم', score: 0.0),
      Skill(skillName: 'الالتحام', score: 0.0),
    ];
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
