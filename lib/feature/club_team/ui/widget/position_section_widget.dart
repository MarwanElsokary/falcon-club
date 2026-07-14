import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:falconclubapp/feature/club_team/ui/widget/player_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/colors.dart';

class PositionSectionWidget extends StatelessWidget {
  final String title;
  final String icon;
  final List<ClubPlayer> players;
  final bool showDividerAbove;

  const PositionSectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.players,
    this.showDividerAbove = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDividerAbove) const _SectionDivider(),
        _SectionHeader(title: title, icon: icon, count: players.length),
        SizedBox(height: 14.h),
        _PlayersList(players: players),
        SizedBox(height: 6.h),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String icon;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 14.sp)),
          SizedBox(width: 8.w),
          Text(
            title.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: kLightPurple,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Horizontal list ───────────────────────────────────────────────────────────

class _PlayersList extends StatelessWidget {
  final List<ClubPlayer> players;

  const _PlayersList({required this.players});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: players.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) => PlayerCardWidget(player: players[i]),
      ),
    );
  }
}

// ── Divider بين الـ sections ──────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
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
          _DiamondDot(
            size: 5.w,
            color: const Color(0xFF9B3DD4).withOpacity(0.45),
          ),
          SizedBox(width: 5.w),
          _DiamondDot(
            size: 7.w,
            color: const Color(0xFF761CBC).withOpacity(0.65),
          ),
          SizedBox(width: 5.w),
          _DiamondDot(
            size: 5.w,
            color: const Color(0xFF9B3DD4).withOpacity(0.45),
          ),
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
}

class _DiamondDot extends StatelessWidget {
  final double size;
  final Color color;

  const _DiamondDot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 deg
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
