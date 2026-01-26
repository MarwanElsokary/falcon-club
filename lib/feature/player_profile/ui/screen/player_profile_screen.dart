import 'dart:developer';

import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/main_screen/cubit/main_state.dart';
import 'package:falcon/feature/player_profile/ui/widget/player_more_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/routing/routes.dart';
import '../../../main_screen/data/model/my_profile_model.dart';
import '../../../player_profile/ui/widget/player_about_me_widget.dart';
import '../../../player_profile/ui/widget/player_chart_widget.dart';
import '../../../player_profile/ui/widget/player_experiance_widget.dart';
import '../../../player_profile/ui/widget/player_image_widget.dart';
import '../../../player_profile/ui/widget/player_profile_app_bar_widget.dart';
import '../../../training_details/data/model/exercise_details_model.dart';
import '../widget/player_measurements_widget.dart'; // تأكد من الاستيراد
import '../widget/player_videos_widget.dart';
import '../widget/simple_radar_chart.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({
    super.key,
    required this.ismyProfile,
    required this.playerId,
  });

  final bool ismyProfile;
  final String playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _skillsLoaded = false;

  @override
  void initState() {
    super.initState();
    log('🎬 PlayerProfileScreen initialized for playerId: ${widget.playerId}');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(context.displayWidth / 1, 30.h),
          child: Container(
            color: mainColor,
            child: SafeArea(child: PlayerProfileAppBarWidget()),
          ),
        ),
        body: Container(
          width: context.displayWidth / 1,
          height: context.displayHeight / 1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Frame 1011 1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<MainCubit, MainState>(
      buildWhen: (previous, current) =>
          current is playerProfileLoading ||
          current is playerProfileSuccess ||
          current is playerProfileError,
      builder: (context, state) {
        log('🎯 Main Content State: ${state.runtimeType}');

        return state.maybeWhen(
          playerProfileloading: () =>
              _buildFullScreenLoading('جاري تحميل البروفايل...'),
          playerProfileerror: (error) => _buildFullScreenError(error),
          playerProfilesuccess: (playerProfile) {
            return _buildProfileWithSkills(playerProfile);
          },
          orElse: () => _buildFullScreenLoading('جاري التحميل...'),
        );
      },
    );
  }

  Widget _buildProfileWithSkills(MyProfileModel playerProfile) {
    if (!_skillsLoaded) {
      _skillsLoaded = true;
      Future.microtask(() {
        log('📄 Fetching skills for player: ${widget.playerId}');
        context.read<MainCubit>().emitSkills(userId: widget.playerId);
      });
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(20),
                //user Image
                PlayerImageWidget(playerProfile: playerProfile),
                verticalSpace(5),
                //player chart
                _buildSkillsChartSection(),
                // player more info
                SlideEnimationWidget(
                  index: 0,
                  child: PlayerMoreInfoWidget(playerProfile: playerProfile),
                ),
                //about me
                verticalSpace(10),
                PlayerAboutMeWidget(playerProfile: playerProfile),
                verticalSpace(10),
                // 🆕 Measurements - مباشر من البيانات
                PlayerMeasurementsWidget(playerProfile: playerProfile), // هنا!
                verticalSpace(10),
                //player Videos
                PlayerVideosWidget(),
                verticalSpace(10),
                PlayerExperianceWidget(playerProfile: playerProfile),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsChartSection() {
    return BlocBuilder<MainCubit, MainState>(
      buildWhen: (previous, current) =>
          current is playerSkillsLoading ||
          current is playerSkillsSuccess ||
          current is playerSkillsError,
      builder: (context, state) {
        log('📊 Skills Section State: ${state.runtimeType}');

        return state.maybeWhen(
          playerSkillsloading: () => _buildChartLoading(),
          playerSkillserror: (error) => _buildChartError(error),
          playerSkillssuccess: (skills) {
            log('📊 Skills loaded: ${skills.length} items');
            return _buildRadarChartWithData(skills);
          },
          orElse: () {
            return _buildChartWaiting();
          },
        );
      },
    );
  }

  Widget _buildRadarChartWithData(List<Skill> skills) {
    log('📊 عدد المهارات المستلمة: ${skills.length}');

    // خريطة المهارات القادمة من الباك إند
    Map<String, double> incomingSkills = {};
    for (var skill in skills) {
      incomingSkills[skill.skillName] = skill.score;
    }

    log('🎯 المهارات القادمة: $incomingSkills');

    // تحديد حالة الاشتراك (بناءً على عدد المهارات)
    bool isSubscribed = skills.length >= 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // تغيير إلى center
      children: [
        verticalSpace(10),
        // الرادار في النصف
        Center(
          child: SizedBox(
            width: 220.w, // حجم مناسب للنصف
            height: 220.w,
            child: CustomRadarChart(
              incomingSkills: incomingSkills,
              isSubscribed: isSubscribed,
            ),
          ),
        ),
        verticalSpace(10),
        // رسالة الترقي مبسطة

        
      ],
    );
  }

  // Widget _buildSimpleSubscribeMessage(BuildContext context, int skillsCount) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 40.w),
  //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.08),
  //       borderRadius: BorderRadius.circular(20.r),
  //       border: Border.all(color: Colors.white.withOpacity(0.3)),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(Icons.lock_outline, color: Colors.white, size: 16.w),
  //         horizontalSpace(8),
  //         Flexible(
  //           child: Text(
  //             '${skillsCount}/5 مهارات متاحة - اشترك الآن',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 12.sp,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         horizontalSpace(8),
  //         GestureDetector(
  //           onTap: () {
  //             context.pushNamed(AppRoute.packageScreen);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
  //             decoration: BoxDecoration(
  //               color: mainColor,
  //               borderRadius: BorderRadius.circular(8.r),
  //             ),
  //             child: Text(
  //               'اشترك',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 11.sp,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: mainColor, size: 18.w),
          horizontalSpace(10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLoading() {
    return Container(
      height: 350.w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(color: Colors.white, radius: 15.w),
            verticalSpace(10),
            Text(
              'جاري تحميل المهارات...',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartWaiting() {
    return Container(
      height: 350.w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              color: Colors.white.withOpacity(0.5),
              size: 40.w,
            ),
            verticalSpace(10),
            Text(
              'انتظار تحميل المهارات...',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartError(String error) {
    return Container(
      height: 350.w,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40.w),
            verticalSpace(10),
            Text(
              'خطأ في تحميل المهارات',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            verticalSpace(5),
            Text(
              'سيتم استخدام بيانات افتراضية',
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenLoading(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 20.w, color: Colors.white),
          verticalSpace(20),
          Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenError(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 60.w),
            verticalSpace(20),
            Text(
              'حدث خطأ في تحميل البروفايل',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(10),
            Text(
              error,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            verticalSpace(20),
            ElevatedButton(
              onPressed: () {
                _skillsLoaded = false;
                context.read<MainCubit>().emitProfileById(
                  userId: widget.playerId,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
