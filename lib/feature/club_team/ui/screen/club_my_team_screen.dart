import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/di/dependency_injection.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/player_profile/ui/widget/player_all_videos_item_widget.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cubit/club_team_cubit.dart';
import '../../cubit/club_team_state.dart';
import '../../data/model/club_player_model.dart';

class ClubMyTeamScreen extends StatefulWidget {
  const ClubMyTeamScreen({super.key});

  @override
  State<ClubMyTeamScreen> createState() => _ClubMyTeamScreenState();
}

class _ClubMyTeamScreenState extends State<ClubMyTeamScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _positionSections = [
    {'key': 'حارس', 'title': 'الحارس', 'emoji': '🧤'},
    {
      'key': 'دفاع',
      'title': 'الدفاع',
      'icon': Icons.favorite,
      'color': const Color(0xFFFF0000),
    },
    {
      'key': 'وسط',
      'title': 'خط الوسط',
      'icon': Icons.sync,
      'color': mainColor,
    },
    {
      'key': 'هجوم',
      'title': 'الهجوم',
      'icon': Icons.bolt,
      'color': const Color(0xFFFFBF00),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ClubTeamCubit>().emitClubPlayers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteclr,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(12),

            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "الرجوع" — left side in RTL
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_ios,
                            color: mainColor, size: 14.w),
                        horizontalSpace(4),
                        TextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: mainColor,
                          text: 'الرجوع'.tr(),
                        ),
                      ],
                    ),
                  ),
                  // Title — right side in RTL
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.groups, color: mainColor, size: 26.w),
                      horizontalSpace(6),
                      TextUtils(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: 'فريق النادي'.tr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpace(12),

            // ── Tabs ────────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: blackclr,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: 'الفرقة الأساسية'.tr()),
                    Tab(text: 'الاحتياطي'.tr()),
                  ],
                ),
              ),
            ),
            verticalSpace(10),

            // ── Filter chips ────────────────────────────────────────────────
            SizedBox(
              height: 34.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _filterChip(label: 'فلتر'.tr(), icon: Icons.filter_list),
                  horizontalSpace(8),
                  _filterChip(label: 'حسب الأداء'.tr()),
                  horizontalSpace(8),
                  _filterChip(label: 'حسب العمر'.tr()),
                  horizontalSpace(8),
                  _filterChip(label: 'حسب المركز'.tr()),
                ],
              ),
            ),
            verticalSpace(10),

            // ── Content ─────────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<ClubTeamCubit, ClubTeamState>(
                buildWhen: (prev, curr) =>
                    curr is clubPlayersLoading ||
                    curr is clubPlayersSuccess ||
                    curr is clubPlayersError,
                builder: (context, state) {
                  return state.maybeWhen(
                    clubPlayersloading: () => Center(
                      child: CupertinoActivityIndicator(radius: 15.w),
                    ),
                    clubPlayerserror: (error) => _buildError(error),
                    clubPlayerssuccess: (_) => _buildTabView(),
                    orElse: () => Center(
                      child: CupertinoActivityIndicator(radius: 15.w),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter chip ───────────────────────────────────────────────────────────
  Widget _filterChip({required String label, IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.w, color: mainColor),
            horizontalSpace(4),
          ],
          TextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: mainColor,
            text: label,
          ),
        ],
      ),
    );
  }

  // ── Tab view ──────────────────────────────────────────────────────────────
  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPositionSections(tabIndex: 0),
        _buildPositionSections(tabIndex: 1),
      ],
    );
  }

  Widget _buildPositionSections({required int tabIndex}) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 100.h),
      child: Column(
        children: _positionSections
            .map((s) => _buildPositionSection(s, tabIndex: tabIndex))
            .toList(),
      ),
    );
  }

  // ── Section ───────────────────────────────────────────────────────────────
  Widget _buildPositionSection(
    Map<String, dynamic> section, {
    required int tabIndex,
  }) {
    final cubit = context.read<ClubTeamCubit>();
    final positionKey = section['key'] as String;
    final title = section['title'] as String;
    final squad = cubit.getSquadByPosition(positionKey, tabIndex: tabIndex);
    final maxPlayers = cubit.maxPlayersForPosition(positionKey);
    final isFull = squad.length >= maxPlayers;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon + title + count (right in RTL)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sectionIcon(section),
                  horizontalSpace(6),
                  TextUtils(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: title.tr(),
                  ),
                  horizontalSpace(6),
                  Text(
                    '(${squad.length}/$maxPlayers)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isFull ? mainColor : greyClr,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Add button — hidden when full (left in RTL)
              if (!isFull)
                GestureDetector(
                  onTap: () => _showAddPlayerSheet(positionKey, tabIndex),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextUtils(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                      text: 'أضف لاعب +'.tr(),
                    ),
                  ),
                ),
            ],
          ),
          verticalSpace(12),

          // Empty or player cards
          if (squad.isEmpty)
            Container(
              height: 80.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: TextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: greyClr,
                  text: 'اضغط "أضف لاعب +" لإضافة لاعب'.tr(),
                ),
              ),
            )
          else
            SizedBox(
              height: 230.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: squad.length,
                separatorBuilder: (_, __) => horizontalSpace(12),
                itemBuilder: (_, i) => _buildPlayerCard(squad[i]),
              ),
            ),
          verticalSpace(20),
        ],
      ),
    );
  }

  // ── Section icon ──────────────────────────────────────────────────────────
  Widget _sectionIcon(Map<String, dynamic> section) {
    if (section.containsKey('emoji')) {
      return Text(
        section['emoji'] as String,
        style: TextStyle(fontSize: 18.sp),
      );
    }
    return Icon(
      section['icon'] as IconData,
      color: section['color'] as Color,
      size: 20.w,
    );
  }

  // ── Player card ───────────────────────────────────────────────────────────
  Widget _buildPlayerCard(ClubPlayer player) {
    return GestureDetector(
      onTap: () => _showPlayerDetailSheet(player),
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: name/position/TPS + circle photo
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 6.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: player.fullName,
                          maxlines: 1,
                        ),
                        verticalSpace(2),
                        TextUtils(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          text: player.positionName?.toString() ?? '',
                          maxlines: 1,
                        ),
                        verticalSpace(4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 12.w),
                            horizontalSpace(3),
                            TextUtils(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              text: '${player.tps ?? 0}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  horizontalSpace(6),
                  // Small circular profile photo — top right
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: ClipOval(child: _buildPhoto(player.photo?.toString())),
                  ),
                ],
              ),
            ),

            // Two video thumbnail placeholders — middle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Expanded(child: _videoThumb()),
                  horizontalSpace(6),
                  Expanded(child: _videoThumb()),
                ],
              ),
            ),
            verticalSpace(8),

            // "التقارير الرقمية" white button — bottom
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, color: mainColor, size: 14.w),
                    horizontalSpace(4),
                    TextUtils(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                      text: 'التقارير الرقمية'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoThumb() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: secondMainColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(Icons.play_circle_outline,
            color: Colors.white54, size: 26.w),
      ),
    );
  }

  // ── Photo loader (same pattern as rank screen) ────────────────────────────
  Widget _buildPhoto(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        color: offWhiteClr,
        child: Image.asset('assets/images/Mask group.png', fit: BoxFit.cover),
      );
    }
    return CachedNetworkImage(
      imageUrl: photoPath,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          Skeletonizer(enabled: true, child: Container(color: fillColor)),
      errorWidget: (_, __, ___) => Container(
        color: offWhiteClr,
        child: Image.asset('assets/images/Mask group.png', fit: BoxFit.cover),
      ),
    );
  }

  // ── FIX 3: Card tap → player detail bottom sheet ──────────────────────────
  void _showPlayerDetailSheet(ClubPlayer player) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<MainCubit>()),
          BlocProvider(
            create: (_) => getIt<RealsCubit>()
              ..emitreals(playerId: player.id?.toString() ?? ''),
          ),
        ],
        child: _PlayerDetailSheet(player: player),
      ),
    );
  }

  // ── Add player bottom sheet ───────────────────────────────────────────────
  void _showAddPlayerSheet(String positionKey, int tabIndex) {
    final cubit = context.read<ClubTeamCubit>();
    final available = cubit.cachedPlayers
        .where((p) => !cubit.isPlayerInTab(tabIndex, p))
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        height: context.displayHeight * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            verticalSpace(12),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: greyClr,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            verticalSpace(16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'إضافة لاعب'.tr(),
              ),
            ),
            verticalSpace(12),
            Expanded(
              child: available.isEmpty
                  ? Center(
                      child: TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: greyClr,
                        text: 'لا يوجد لاعبون متاحون'.tr(),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: available.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: greyClr.withOpacity(0.2)),
                      itemBuilder: (_, i) {
                        final p = available[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: fillColor,
                            backgroundImage: p.photo != null &&
                                    p.photo.toString().isNotEmpty
                                ? CachedNetworkImageProvider(
                                    p.photo.toString())
                                : null,
                            child: p.photo == null ||
                                    p.photo.toString().isEmpty
                                ? Icon(Icons.person,
                                    color: greyClr, size: 20.w)
                                : null,
                          ),
                          title: TextUtils(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            text: p.fullName,
                          ),
                          subtitle: TextUtils(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: blackclr,
                            text: p.positionName?.toString() ?? '',
                          ),
                          trailing: Icon(Icons.add_circle_outline,
                              color: mainColor, size: 24.w),
                          onTap: () {
                            cubit.addPlayerToSection(
                              positionKey,
                              p,
                              tabIndex: tabIndex,
                            );
                            Navigator.pop(sheetCtx);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: redClr, size: 40.w),
          verticalSpace(10),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            text: error,
          ),
          verticalSpace(16),
          ElevatedButton(
            onPressed: () => context.read<ClubTeamCubit>().emitClubPlayers(),
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
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

// ── Player detail bottom sheet ─────────────────────────────────────────────
class _PlayerDetailSheet extends StatelessWidget {
  final ClubPlayer player;
  const _PlayerDetailSheet({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: greyClr,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),

            // Player info card (purple, full-width)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: ClipOval(child: _buildPhoto(player.photo?.toString())),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtils(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            text: player.fullName,
                            maxlines: 1,
                          ),
                          SizedBox(height: 2.h),
                          TextUtils(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                            text: player.positionName?.toString() ?? '',
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14.w),
                              SizedBox(width: 4.w),
                              TextUtils(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                text: '${player.tps ?? 0}',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Section title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'اللقطات',
              ),
            ),
            SizedBox(height: 10.h),

            // Reels grid — reuses PlayerAllVideosItemWidget (reads RealsCubit)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const PlayerAllVideosItemWidget(),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        color: offWhiteClr,
        child: Image.asset('assets/images/Mask group.png', fit: BoxFit.cover),
      );
    }
    return CachedNetworkImage(
      imageUrl: photoPath,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          Skeletonizer(enabled: true, child: Container(color: fillColor)),
      errorWidget: (_, __, ___) => Container(
        color: offWhiteClr,
        child: Image.asset('assets/images/Mask group.png', fit: BoxFit.cover),
      ),
    );
  }
}
