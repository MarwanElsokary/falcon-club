import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/shared/domain/subscription_reader.dart';
import 'dart:developer';

import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_state.dart';
import 'package:falconclubapp/feature/player_profile/ui/widget/player_more_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/domain/entities/player_profile.dart';
import '../../../profile/presentation/cubit/player_profile_cubit.dart';
import '../../../profile/presentation/cubit/player_profile_state.dart';
import '../../../player_profile/ui/widget/player_about_me_widget.dart';
import '../../../player_profile/ui/widget/player_experiance_widget.dart';
import '../../../player_profile/ui/widget/player_profile_app_bar_widget.dart';
import 'package:falconclubapp/feature/main_screen/data/model/skills_response_model.dart';
import '../widget/player_chart_widget.dart';
import '../widget/player_image_widget.dart';
import '../widget/player_measurements_image_widget.dart';
import '../widget/player_measurements_widget.dart';
import '../widget/player_videos_widget.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({
    super.key,
    required this.ismyProfile,
    required this.playerId,
    this.showFavoriteButton = true,
  });

  final bool ismyProfile;
  final String playerId;

  /// true لما يكون المستخدم مدرب أو كشاف
  final bool showFavoriteButton;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _skillsLoaded = false;
  bool _isFavorited = false;
  bool _isFavLoading = false;

  @override
  void initState() {
    super.initState();
    log('🎬 PlayerProfileScreen initialized for playerId: ${widget.playerId}');
    _isFavorited = context.read<MainCubit>().isFavorited(widget.playerId);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavLoading) return;
    await context.read<MainCubit>().emitToggleFavorite(
      playerId: widget.playerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainCubit, MainState>(
      listenWhen: (_, current) =>
          current is toggleFavoriteLoading ||
          current is toggleFavoriteSuccess ||
          current is toggleFavoriteError,
      listener: (context, state) {
        state.maybeWhen(
          toggleFavoriteLoading: () {
            setState(() => _isFavLoading = true);
          },
          toggleFavoriteSuccess: (playerId, isFavorited, message) {
            setState(() {
              _isFavorited = isFavorited;
              _isFavLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: _isFavorited
                    ? const Color(0xFF1A6B3C)
                    : const Color(0xFF8B1A1A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          toggleFavoriteError: (error) {
            setState(() => _isFavLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
            );
          },
          orElse: () {},
        );
      },
      child: PopScope(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(context.displayWidth, 30.h),
            child: Container(
              color: mainColor,
              child: SafeArea(
                // ✅ AppBar نظيف — بس زرار الرجوع والعنوان
                child: PlayerProfileAppBarWidget(),
              ),
            ),
          ),
          body: Container(
            width: context.displayWidth,
            height: context.displayHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Frame 1011 1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _buildMainContent(),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // MAIN CONTENT
  // ════════════════════════════════════════════════════════════════

  Widget _buildMainContent() {
    // Display is driven by the domain PlayerProfileCubit (Phase 4). Skills (the
    // radar chart) and the favourite toggle stay on MainCubit for now.
    return BlocBuilder<PlayerProfileCubit, PlayerProfileState>(
      builder: (context, state) {
        log('🎯 Main Content State: ${state.runtimeType}');
        return switch (state) {
          PlayerProfileLoaded(:final PlayerProfile profile) =>
            _buildProfileContent(profile),
          PlayerProfileFailure(:final String message) =>
            _buildFullScreenError(message),
          _ => _buildFullScreenLoading('جاري تحميل البروفايل...'),
        };
      },
    );
  }

  Widget _buildProfileContent(PlayerProfile playerProfile) {
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
                _buildSkillsChartSection(),
                SlideEnimationWidget(
                  index: 0,
                  child: PlayerMoreInfoWidget(playerProfile: playerProfile),
                ),
                verticalSpace(10),
                PlayerAboutMeWidget(playerProfile: playerProfile),
                verticalSpace(10),
                PlayerMeasurementsWidget(playerProfile: playerProfile),
                verticalSpace(10),
                PlayerBioImageWidget(playerProfile: playerProfile),
                verticalSpace(10),
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

  // ════════════════════════════════════════════════════════════════
  // SKILLS CHART
  // ════════════════════════════════════════════════════════════════

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
          playerSkillserror: (error) => _buildChartError(),
          playerSkillssuccess: (skills) {
            log('📊 Skills loaded: ${skills.length} items');
            return _buildRadarChart(skills);
          },
          orElse: () => _buildChartWaiting(),
        );
      },
    );
  }

  Widget _buildRadarChart(List<Skill> skills) {
    final Map<String, double> incomingSkills = {
      for (final skill in skills) skill.skillName: skill.score,
    };

    // Entitlement comes from the subscription, not from the shape of the data.
    //
    // This used to be `skills.length >= 5` — inferring whether the user had paid
    // from how many skills the AI happened to score. The backend does send 2
    // skills to an unsubscribed user and 5 to a subscribed one, so it *looked*
    // right; but it was reading a side effect, and it was wrong in both
    // directions. A SUBSCRIBED player whose AI had only rated three skills so far
    // was shown padlocks on skills they had paid for, and any unsubscribed player
    // who happened to come back with five got the full chart free.
    //
    // `SubscriptionReader` is the single entitlement rule shared with the rank
    // screen, the exercise paywall, the drawer and the package screen. Note it
    // counts an *expired* plan as unentitled, which the old check could not see
    // at all.
    //
    // The chart already draws all five skill slots and padlocks any the backend
    // did not send (`player_chart_widget.dart:29`), so the "2 real + 3 locked"
    // behaviour needs no UI change — only the correct flag.
    final bool isSubscribed = getIt<SubscriptionReader>().current().isActive;

    return Column(
      children: [
        verticalSpace(10),
        Center(
          child: SizedBox(
            width: 220.w,
            height: 220.w,
            child: CustomRadarChart(
              incomingSkills: incomingSkills,
              isSubscribed: isSubscribed,
            ),
          ),
        ),
        verticalSpace(10),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // LOADING / ERROR STATES
  // ════════════════════════════════════════════════════════════════

  Widget _buildChartLoading() {
    return SizedBox(
      height: 240.w,
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
    return SizedBox(
      height: 240.w,
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

  Widget _buildChartError() {
    return SizedBox(
      height: 240.w,
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
                context.read<PlayerProfileCubit>().load(widget.playerId);
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
