import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';
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
    {'key': 'دفاع', 'title': 'الدفاع', 'icon': Icons.favorite, 'color': const Color(0xFFFF0000)},
    {'key': 'وسط', 'title': 'خط الوسط', 'icon': Icons.sync, 'color': mainColor},
    {'key': 'هجوم', 'title': 'الهجوم', 'icon': Icons.bolt, 'color': const Color(0xFFFFBF00)},
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
                children: [
                  Icon(Icons.groups, color: mainColor, size: 28.w),
                  horizontalSpace(8),
                  TextUtils(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: 'فريق النادي'.tr(),
                  ),
                ],
              ),
            ),
            verticalSpace(14),
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
            verticalSpace(12),
            // ── Filter chips ────────────────────────────────────────────────
            SizedBox(
              height: 34.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _filterChip(label: 'فلتر'.tr(), icon: Icons.filter_list),
                  horizontalSpace(8),
                  _filterChip(label: 'حسب المركز'.tr()),
                  horizontalSpace(8),
                  _filterChip(label: 'حسب العمر'.tr()),
                  horizontalSpace(8),
                  _filterChip(label: 'حسب الأداء'.tr()),
                ],
              ),
            ),
            verticalSpace(12),
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
        _buildPositionSections(isReserve: false),
        _buildPositionSections(isReserve: true),
      ],
    );
  }

  Widget _buildPositionSections({required bool isReserve}) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 100.h),
      child: Column(
        children: _positionSections.map((section) {
          return _buildPositionSection(section, isReserve: isReserve);
        }).toList(),
      ),
    );
  }

  // ── Section ───────────────────────────────────────────────────────────────
  Widget _buildPositionSection(
    Map<String, dynamic> section, {
    required bool isReserve,
  }) {
    final cubit = context.read<ClubTeamCubit>();
    final positionKey = section['key'] as String;
    final title = section['title'] as String;
    final squadPlayers = cubit.getSquadByPosition(positionKey);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon + title (in RTL this renders on the right)
              Row(
                children: [
                  _sectionIcon(section),
                  horizontalSpace(6),
                  TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: title.tr(),
                  ),
                ],
              ),
              // Add button (in RTL this renders on the left)
              GestureDetector(
                onTap: () => _showAddPlayerSheet(positionKey),
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
          // Player cards row
          if (squadPlayers.isEmpty)
            Container(
              height: 90.h,
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
                  text: 'لا يوجد لاعبين — اضغط أضف لاعب +'.tr(),
                ),
              ),
            )
          else
            SizedBox(
              height: 240.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: squadPlayers.length,
                separatorBuilder: (_, __) => horizontalSpace(12),
                itemBuilder: (_, index) =>
                    _buildPlayerCard(squadPlayers[index]),
              ),
            ),
          verticalSpace(20),
        ],
      ),
    );
  }

  // ── Section icon helper ───────────────────────────────────────────────────
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
      onTap: () {
        context.pushNamed(
          AppRoute.playerProfile,
          arguments: {
            'isMyProfile': false,
            'playerId': player.id?.toString() ?? '',
          },
        );
      },
      child: Container(
        width: 160.w,
        height: 240.h,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top info bar ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name / position / rating
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
                            Icon(Icons.star,
                                color: Colors.amber, size: 12.w),
                            horizontalSpace(2),
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
                  horizontalSpace(4),
                  // Small circle profile photo
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: ClipOval(
                      child: _buildPlayerImage(player.photo?.toString()),
                    ),
                  ),
                ],
              ),
            ),
            // ── Large photo ───────────────────────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomStart: Radius.circular(16.r),
                      bottomEnd: Radius.circular(16.r),
                    ),
                    child: _buildLargePlayerImage(player.photo?.toString()),
                  ),
                  // Gradient overlay for bottom button legibility
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomStart: Radius.circular(16.r),
                          bottomEnd: Radius.circular(16.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            secondMainColor.withOpacity(0.95),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart,
                              color: Colors.white, size: 13.w),
                          horizontalSpace(4),
                          TextUtils(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            text: 'التقارير الرقمية'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Image helpers — same pattern as rank screen ───────────────────────────
  Widget _buildPlayerImage(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        color: offWhiteClr,
        child: Image.asset(
          'assets/images/Mask group.png',
          fit: BoxFit.cover,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: photoPath,
      fit: BoxFit.cover,
      placeholder: (_, __) => Skeletonizer(
        enabled: true,
        child: Container(color: fillColor),
      ),
      errorWidget: (_, __, ___) => Container(
        color: offWhiteClr,
        child: Image.asset(
          'assets/images/Mask group.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLargePlayerImage(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        color: secondMainColor,
        child: Center(
          child: Icon(Icons.person, color: Colors.white54, size: 48.w),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: photoPath,
      fit: BoxFit.cover,
      placeholder: (_, __) => Skeletonizer(
        enabled: true,
        child: Container(color: secondMainColor),
      ),
      errorWidget: (_, __, ___) => Container(
        color: secondMainColor,
        child: Center(
          child: Icon(Icons.person, color: Colors.white54, size: 48.w),
        ),
      ),
    );
  }

  // ── Add player bottom sheet ───────────────────────────────────────────────
  void _showAddPlayerSheet(String positionKey) {
    final cubit = context.read<ClubTeamCubit>();
    final allPlayers = cubit.cachedPlayers;

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
              child: allPlayers.isEmpty
                  ? Center(
                      child: TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: greyClr,
                        text: 'لا يوجد لاعبين متاحين'.tr(),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: allPlayers.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: greyClr.withOpacity(0.2)),
                      itemBuilder: (_, index) {
                        final player = allPlayers[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: fillColor,
                            backgroundImage:
                                player.photo != null &&
                                        player.photo
                                            .toString()
                                            .isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        player.photo.toString())
                                    : null,
                            child: player.photo == null ||
                                    player.photo.toString().isEmpty
                                ? Icon(Icons.person,
                                    color: greyClr, size: 20.w)
                                : null,
                          ),
                          title: TextUtils(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            text: player.fullName,
                          ),
                          subtitle: TextUtils(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: blackclr,
                            text: player.positionName?.toString() ?? '',
                          ),
                          trailing: Icon(
                            Icons.add_circle_outline,
                            color: mainColor,
                            size: 24.w,
                          ),
                          onTap: () {
                            cubit.addPlayerToSection(positionKey, player);
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
            onPressed: () =>
                context.read<ClubTeamCubit>().emitClubPlayers(),
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
