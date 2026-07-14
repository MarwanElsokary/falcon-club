import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/feature/club_team/ui/widget/position_section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/utils/colors.dart';
import '../../../club_team/cubit/club_exercises_cubit.dart';
import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../data/model/club_trainee_model.dart';
import '../widget/traineeCardWidget.dart';

class ClubMainMyTeamScreen extends StatefulWidget {
  const ClubMainMyTeamScreen({super.key});

  @override
  State<ClubMainMyTeamScreen> createState() => _ClubMyTeamScreenState();
}

class _ClubMyTeamScreenState extends State<ClubMainMyTeamScreen> {
  int _activeTab = 0; // 0 = لاعبين | 1 = مدربين

  static const List<String> _sectionOrder = [
    'الحارس',
    'الدفاع',
    'خط الوسط',
    'الهجوم',
  ];

  static const Map<String, String> _sectionIcon = {
    'الحارس': '',
    'الدفاع': '️',
    'خط الوسط': '️',
    'الهجوم': '',
  };

  static final _fakeSections = [('الدفاع', '🛡️', 3), ('خط الوسط', '⚙️', 2)];

  void _onTabChanged(int index) {
    if (_activeTab == index) return;
    setState(() => _activeTab = index);
    if (index == 1) {
      context.read<ClubTeamCubit>().fetchClubTrainees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ClubExercisesCubit>(),
      child: BlocListener<ClubTeamCubit, ClubTeamState>(
        listener: (context, state) {
          state.maybeWhen(
            deleteTraineeSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم حذف المدرب بنجاح'),
                  backgroundColor: mainColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            deleteTraineeError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            orElse: () {},
          );
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F4FB),
          body: Stack(
            children: [
              PositionedDirectional(
                start: 0,
                top: 0,
                child: SvgPicture.asset(
                  'assets/svgs/Group 386.svg',
                  width: 120.w,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    _buildHeader(),
                    SizedBox(height: 12.h),
                    _buildTabSelector(),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: _activeTab == 0
                          ? _buildPlayersBody()
                          : _buildTraineesBody(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.groups_rounded, color: kPrimaryColor, size: 24.w),
          SizedBox(width: 8.w),
          Text(
            'فريق النادي'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Selector — نفس شكل RequestsTabSelector ──────────────────────────────

  Widget _buildTabSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'اللاعبين'.tr(),
            icon: Icons.sports_soccer_rounded,
            isActive: _activeTab == 0,
            onTap: () => _onTabChanged(0),
          ),
          _TabItem(
            label: 'المدربين'.tr(),
            icon: Icons.person_outline_rounded,
            isActive: _activeTab == 1,
            onTap: () => _onTabChanged(1),
          ),
        ],
      ),
    );
  }

  // ── Players Body (الكود القديم بالظبط) ──────────────────────────────────────

  Widget _buildPlayersBody() {
    return BlocBuilder<ClubTeamCubit, ClubTeamState>(
      buildWhen: (_, current) => current.maybeWhen(
        clubPlayersloading: () => true,
        clubPlayerssuccess: (_) => true,
        clubPlayerserror: (_) => true,
        orElse: () => false,
      ),
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          clubPlayersloading: () => true,
          orElse: () => false,
        );
        final isError = state.maybeWhen(
          clubPlayerserror: (_) => true,
          orElse: () => false,
        );
        final errorMsg = state.maybeWhen(
          clubPlayerserror: (e) => e,
          orElse: () => '',
        );

        if (isError) return _buildPlayersError(errorMsg, context);
        return _buildPlayersScrollView(context, isLoading: isLoading);
      },
    );
  }

  Widget _buildPlayersScrollView(
      BuildContext context, {
        required bool isLoading,
      }) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            context.read<ClubTeamCubit>().fetchClubPlayers();
            await Future.delayed(const Duration(milliseconds: 800));
          },
          builder: (_, __, ___, ____, _____) => Container(
            alignment: Alignment.center,
            child: CupertinoActivityIndicator(radius: 12.w),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
          sliver: isLoading
              ? _buildPlayersSkeleton()
              : _buildPlayersRealSliver(context),
        ),
      ],
    );
  }

  Widget _buildPlayersSkeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((_, index) {
        final section = _fakeSections[index % _fakeSections.length];
        return Skeletonizer(
          enabled: true,
          effect: ShimmerEffect(
            baseColor: const Color(0xFFE8DCF5),
            highlightColor: const Color(0xFFF3ECF9),
          ),
          child: _SkeletonSection(
            title: section.$1,
            icon: section.$2,
            cardCount: section.$3,
            showDividerAbove: index != 0,
          ),
        );
      }, childCount: _fakeSections.length),
    );
  }

  Widget _buildPlayersRealSliver(BuildContext context) {
    final grouped = context.read<ClubTeamCubit>().groupedPlayers;
    final visibleSections = _sectionOrder
        .where((key) => grouped[key]?.isNotEmpty ?? false)
        .toList();

    if (visibleSections.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'لا يوجد لاعبون في هذا النادي'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: kTextGrey,
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((_, index) {
        final key = visibleSections[index];
        return PositionSectionWidget(
          title: key,
          icon: _sectionIcon[key] ?? '',
          players: grouped[key]!,
          showDividerAbove: index != 0,
        );
      }, childCount: visibleSections.length),
    );
  }

  Widget _buildPlayersError(String error, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40.w),
          SizedBox(height: 10.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ClubTeamCubit>().fetchClubPlayers(),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'إعادة المحاولة'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Trainees Body ────────────────────────────────────────────────────────────

  Widget _buildTraineesBody() {
    return BlocBuilder<ClubTeamCubit, ClubTeamState>(
      buildWhen: (_, current) => current.maybeWhen(
        clubTraineesLoading: () => true,
        clubTraineesSuccess: (_) => true,
        clubTraineesError: (_) => true,
        orElse: () => false,
      ),
      builder: (context, state) {
        return state.maybeWhen(
          clubTraineesLoading: () => _buildTraineesSkeleton(),
          clubTraineesSuccess: (trainees) => trainees.isEmpty
              ? _buildTraineesEmpty()
              : _buildTraineesList(context, trainees),
          clubTraineesError: (error) => _buildTraineesError(error, context),
          orElse: () => _buildTraineesSkeleton(),
        );
      },
    );
  }

  Widget _buildTraineesList(
      BuildContext context,
      List<ClubTrainee> trainees,
      ) {
    return RefreshIndicator(
      color: mainColor,
      onRefresh: () async {
        context.read<ClubTeamCubit>().fetchClubTrainees();
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: ListView.builder(
        padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
        itemCount: trainees.length,
        itemBuilder: (_, i) => TraineeCardWidget(trainee: trainees[i]),
      ),
    );
  }

  Widget _buildTraineesSkeleton() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: const Color(0xFFE8DCF5),
        highlightColor: const Color(0xFFF3ECF9),
      ),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 4.h, bottom: 100.h),
        itemCount: 4,
        itemBuilder: (_, __) => TraineeCardWidget(
          trainee: ClubTrainee(
            id: 'x',
            name: 'اسم المدرب هنا',
            phone: '0501234567',
            email: 'example@email.com',
            gender: 'ذكر',
            accountNumber: '1234',
          ),
        ),
      ),
    );
  }

  Widget _buildTraineesEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: fillColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline, size: 48.w, color: mainColor),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا يوجد مدربون في هذا النادي'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraineesError(String error, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40.w),
          SizedBox(height: 10.h),
          Text(
            error,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<ClubTeamCubit>().fetchClubTrainees(),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'إعادة المحاولة'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab Item widget ───────────────────────────────────────────────────────────

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? mainColor : Colors.transparent,
            borderRadius: BorderRadius.circular(11.r),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: mainColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.w,
                color: isActive ? Colors.white : mainColor.withOpacity(0.6),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.white : mainColor.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Skeleton widgets (نفس الكود القديم بالظبط) ───────────────────────────────

class _SkeletonSection extends StatelessWidget {
  final String title;
  final String icon;
  final int cardCount;
  final bool showDividerAbove;

  const _SkeletonSection({
    required this.title,
    required this.icon,
    required this.cardCount,
    required this.showDividerAbove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDividerAbove) _buildDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
          child: Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 14.sp)),
              SizedBox(width: 8.w),
              Container(
                width: 60.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 24.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.42,          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: cardCount,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, __) => const _SkeletonCard(),
          ),
        ),
        SizedBox(height: 6.h),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.5.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF761CBC).withOpacity(0.25),
                  ],
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _diamond(5.w, const Color(0xFF9B3DD4).withOpacity(0.45)),
          SizedBox(width: 5.w),
          _diamond(7.w, const Color(0xFF761CBC).withOpacity(0.65)),
          SizedBox(width: 5.w),
          _diamond(5.w, const Color(0xFF9B3DD4).withOpacity(0.45)),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 1.5.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF761CBC).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _diamond(double size, Color color) {
    return Transform.rotate(
      angle: 0.785398,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1.r),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFF0EAF8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 110.h,
            color: const Color(0xFF9B3DD4).withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  margin: EdgeInsets.only(bottom: 18.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.5),
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(11.w, 22.h, 11.w, 11.h),
            child: Column(
              children: [
                Container(
                  width: 90.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 60.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECF9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 40.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(height: 1.h, color: const Color(0xFFF3ECF9)),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECF9),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  width: double.infinity,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF761CBC).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}