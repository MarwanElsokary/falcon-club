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
  int _currentTab = 0;

  final List<Map<String, String>> _positionSections = [
    {'key': 'حارس', 'title': 'الحارس'},
    {'key': 'دفاع', 'title': 'الدفاع'},
    {'key': 'وسط', 'title': 'خط الوسط'},
    {'key': 'هجوم', 'title': 'الهجوم'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _currentTab = _tabController.index);
    });
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
            verticalSpace(10),
            // header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Icon(Icons.groups, color: mainColor, size: 28.w),
                  horizontalSpace(10),
                  TextUtils(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: 'فريق النادي'.tr(),
                  ),
                ],
              ),
            ),
            verticalSpace(16),
            // tabs
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
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
            verticalSpace(16),
            // content
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
                    clubPlayerserror: (error) => _buildPlayersError(error),
                    clubPlayerssuccess: (players) => _buildPlayersList(),
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

  Widget _buildPlayersList() {
    final cubit = context.read<ClubTeamCubit>();

    return TabBarView(
      controller: _tabController,
      children: [
        // main squad
        _buildPositionSections(cubit),
        // reserves - same layout, could filter differently
        _buildPositionSections(cubit, isReserve: true),
      ],
    );
  }

  Widget _buildPositionSections(ClubTeamCubit cubit, {bool isReserve = false}) {
    return SingleChildScrollView(
      child: Column(
        children: _positionSections.map((section) {
          final players = cubit.getPlayersByPosition(section['key']!);
          return _buildPositionSection(
            title: section['title']!,
            positionKey: section['key']!,
            players: isReserve ? [] : players,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPositionSection({
    required String title,
    required String positionKey,
    required List<ClubPlayer> players,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: title,
              ),
              InkWell(
                onTap: () => _showAddPlayerSheet(positionKey),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
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
          if (players.isEmpty)
            Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: greyClr,
                  text: 'لا يوجد لاعبين'.tr(),
                ),
              ),
            )
          else
            SizedBox(
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: players.length,
                separatorBuilder: (_, __) => horizontalSpace(12),
                itemBuilder: (context, index) {
                  return _buildPlayerCard(players[index]);
                },
              ),
            ),
          verticalSpace(20),
        ],
      ),
    );
  }

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // player image with profile photo overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: CachedNetworkImage(
                    width: 160.w,
                    height: 120.h,
                    imageUrl: player.photo ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Skeletonizer(
                      enabled: true,
                      child: Container(
                        width: 160.w,
                        height: 120.h,
                        color: fillColor,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 160.w,
                      height: 120.h,
                      color: fillColor,
                      child: Icon(
                        Icons.person,
                        color: greyClr,
                        size: 40.w,
                      ),
                    ),
                  ),
                ),
                // small profile photo
                PositionedDirectional(
                  top: 8.h,
                  end: 8.w,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: player.photo ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: fillColor,
                          child: Icon(
                            Icons.person,
                            size: 16.w,
                            color: greyClr,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // player info
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: player.fullName,
                    maxlines: 1,
                  ),
                  verticalSpace(2),
                  TextUtils(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: blackclr,
                    text: '${player.positionName ?? ''}',
                    maxlines: 1,
                  ),
                  verticalSpace(4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.w),
                      horizontalSpace(4),
                      TextUtils(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        text: '${player.tps ?? 0}',
                      ),
                    ],
                  ),
                  verticalSpace(6),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Center(
                      child: TextUtils(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: mainColor,
                        text: 'التقارير الرقمية'.tr(),
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

  void _showAddPlayerSheet(String positionKey) {
    final cubit = context.read<ClubTeamCubit>();
    final allPlayers = cubit.cachedPlayers;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
            verticalSpace(16),
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
                      separatorBuilder: (_, __) => Divider(
                        color: greyClr.withOpacity(0.2),
                      ),
                      itemBuilder: (context, index) {
                        final player = allPlayers[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: fillColor,
                            backgroundImage: player.photo != null &&
                                    player.photo.toString().isNotEmpty
                                ? CachedNetworkImageProvider(player.photo)
                                : null,
                            child: player.photo == null ||
                                    player.photo.toString().isEmpty
                                ? Icon(
                                    Icons.person,
                                    color: greyClr,
                                    size: 20.w,
                                  )
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
                            text: '${player.positionName ?? ''}',
                          ),
                          trailing: Icon(
                            Icons.add_circle_outline,
                            color: mainColor,
                            size: 24.w,
                          ),
                          onTap: () {
                            Navigator.pop(context);
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

  Widget _buildPlayersError(String error) {
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
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
