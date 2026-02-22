import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/filter_chips_widget.dart';
import '../widget/player_card_widget.dart';
import '../../data/model/player_card_model.dart';

class PlayersListScreen extends StatefulWidget {
  const PlayersListScreen({super.key});

  @override
  State<PlayersListScreen> createState() => _PlayersListScreenState();
}

class _PlayersListScreenState extends State<PlayersListScreen> {
  final List<String> filters = [
    'فيديو',
    'مضاف حديثًا',
    'العمر',
    'موقع اللعب',
  ];

  // Placeholder data - will be replaced with API data
  List<PlayerCardData> players = [];

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
                  Expanded(
                    child: TextUtils(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'قائمة اللاعبين'.tr(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list, color: mainColor),
                    onPressed: () {
                      _showFilterSheet(context);
                    },
                  ),
                ],
              ),
            ),

            // Filter chips
            FilterChipsWidget(
              filters: filters,
              onFilterSelected: (filter) {
                // Handle filter selection
              },
            ),

            verticalSpace(16),

            // Section title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'قائمة اللاعبين'.tr(),
              ),
            ),

            verticalSpace(12),

            // Players grid
            Expanded(
              child: players.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        return PlayerCardWidget(
                          player: players[index],
                          onInviteTap: () {
                            _showInvitationDialog(context, players[index]);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 80.w,
            color: mainColor.withOpacity(0.3),
          ),
          verticalSpace(20),
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            text: 'لا يوجد لاعبين متاحين حاليا'.tr(),
          ),
          verticalSpace(10),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black38,
            text: 'ابحث عن لاعبين جدد للنادي'.tr(),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              verticalSpace(20),
              TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'تصفية'.tr(),
              ),
              verticalSpace(16),

              // Age filter
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                text: 'العمر'.tr(),
              ),
              verticalSpace(8),
              Wrap(
                spacing: 8.w,
                children: ['10-14', '14-18', '18-25'].map((age) {
                  return Chip(
                    label: Text(age),
                    backgroundColor: Colors.grey[100],
                  );
                }).toList(),
              ),

              verticalSpace(16),

              // Position filter
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                text: 'موقع اللعب'.tr(),
              ),
              verticalSpace(8),
              Wrap(
                spacing: 8.w,
                children: [
                  'حراسة المرمى',
                  'خط الدفاع',
                  'خط الوسط',
                  'خط الهجوم',
                ].map((position) {
                  return Chip(
                    label: Text(position.tr()),
                    backgroundColor: Colors.grey[100],
                  );
                }).toList(),
              ),

              verticalSpace(16),

              // Sort by
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                text: 'ترتيب حسب'.tr(),
              ),
              verticalSpace(8),
              Wrap(
                spacing: 8.w,
                children: ['أعلى نقاط', 'أعلى تفاعل'].map((sort) {
                  return Chip(
                    label: Text(sort.tr()),
                    backgroundColor: Colors.grey[100],
                  );
                }).toList(),
              ),

              verticalSpace(20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'تطبيق'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              verticalSpace(10),
            ],
          ),
        );
      },
    );
  }

  void _showInvitationDialog(BuildContext context, PlayerCardData player) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: mainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                verticalSpace(20),
                Text(
                  'ارسال دعوة'.tr(),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                verticalSpace(4),
                Text(
                  player.fullName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                verticalSpace(20),
                _buildInvitationField('موقع النادي'.tr()),
                verticalSpace(12),
                _buildInvitationField('التاريخ'.tr()),
                verticalSpace(12),
                _buildInvitationField('اسم المدرب أو المسؤول'.tr()),
                verticalSpace(12),
                _buildInvitationField('ملاحظات'.tr(), maxLines: 3),
                verticalSpace(20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle invitation sending
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'ارسال الدعوة'.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: mainColor,
                      ),
                    ),
                  ),
                ),
                verticalSpace(10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvitationField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70, fontSize: 13.sp),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
