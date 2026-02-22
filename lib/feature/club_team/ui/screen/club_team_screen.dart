import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../players_list/ui/widget/filter_chips_widget.dart';

class ClubTeamScreen extends StatefulWidget {
  const ClubTeamScreen({super.key});

  @override
  State<ClubTeamScreen> createState() => _ClubTeamScreenState();
}

class _ClubTeamScreenState extends State<ClubTeamScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> filters = [
    'فيديو',
    'حسب المركز',
    'حسب العمر',
    'حسب الأداء',
  ];

  // Position sections for team management
  final List<Map<String, dynamic>> positionSections = [
    {'title': 'الحارس', 'icon': Icons.sports_handball, 'players': []},
    {'title': 'الدفاع', 'icon': Icons.shield, 'players': []},
    {'title': 'خط الوسط', 'icon': Icons.swap_horiz, 'players': []},
    {'title': 'خط الهجوم', 'icon': Icons.sports_soccer, 'players': []},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF4FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Icon(Icons.groups, color: mainColor, size: 28.w),
                  horizontalSpace(10),
                  Expanded(
                    child: TextUtils(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'فريق النادي'.tr(),
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            FilterChipsWidget(
              filters: filters,
              onFilterSelected: (filter) {
                // Handle filter
              },
            ),
            verticalSpace(12),

            // Tab bar: Main Squad / Reserves
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'الفرقة الأساسية'.tr()),
                  Tab(text: 'الاحتياطي'.tr()),
                ],
              ),
            ),

            verticalSpace(16),

            // Position sections
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTeamPositions(),
                  _buildTeamPositions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamPositions() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: positionSections.length,
      itemBuilder: (context, index) {
        final section = positionSections[index];
        return _buildPositionSection(
          title: section['title'],
          icon: section['icon'],
          players: section['players'],
        );
      },
    );
  }

  Widget _buildPositionSection({
    required String title,
    required IconData icon,
    required List players,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Icon(icon, color: mainColor, size: 20.w),
              horizontalSpace(8),
              TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: title.tr(),
              ),
              const Spacer(),
              // Add player button
              GestureDetector(
                onTap: () {
                  // Navigate to add player
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: mainColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: mainColor, size: 16.w),
                      horizontalSpace(4),
                      Text(
                        'اضف لاعب'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          verticalSpace(12),

          // Players horizontal list or empty state
          players.isEmpty
              ? Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          color: Colors.grey[400],
                          size: 32.w,
                        ),
                        verticalSpace(8),
                        Text(
                          'لا يوجد لاعبين'.tr(),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 180.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: players.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      return _buildTeamPlayerCard(players[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTeamPlayerCard(dynamic player) {
    return Container(
      width: 140.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Player image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Container(
              height: 80.h,
              width: double.infinity,
              color: const Color(0xFFEFF4FF),
              child: Icon(
                Icons.person,
                size: 40.w,
                color: mainColor.withOpacity(0.3),
              ),
            ),
          ),
          // Player info
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              children: [
                Text(
                  'اسم اللاعب',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                verticalSpace(4),
                // Digital reports button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'التقارير الرقمية'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
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
