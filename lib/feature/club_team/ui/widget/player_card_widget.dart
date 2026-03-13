import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/data/model/club_player_model.dart';
import 'package:falcon/feature/club_team/ui/widget/player_reports_sheet.dart';
import 'package:falcon/feature/player_reels/ui/widget/player_reels_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';
import 'assign_exercise_sheet.dart';

const String _rightFootAsset = 'assets/svgs/right.svg';
const String _leftFootAsset = 'assets/svgs/material-symbols_barefoot.svg';
const Color _lightBg = Color(0xFFEFF4FF);

class PlayerCardWidget extends StatelessWidget {
  final ClubPlayer player;

  const PlayerCardWidget({super.key, required this.player});

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.playerProfile,
      arguments: {'isMyProfile': false, 'playerId': player.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToProfile(context),
      child: Container(
        width: 200.w,
        height: 351.h,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildInfoRow(player),
            SizedBox(height: 8.h),
            // ── Reels Section ──────────────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _lightBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFFCBD5E0), width: 0.5),
                  ),
                ),
                padding: EdgeInsets.all(8.w),
                child: PlayerReelsSectionWidget(playerId: player.id),
              ),
            ),
            SizedBox(height: 8.h),
            _buildReportsButton(context),
            SizedBox(height: 6.h),
            _buildAssignExerciseButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ClubPlayer player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildPhoto(player),
        SizedBox(width: 8.w),
        Expanded(child: _buildPlayerDetails(player)),
      ],
    );
  }

  Widget _buildPlayerDetails(ClubPlayer player) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: player.name,
          maxlines: 2,
        ),
        SizedBox(height: 4.h),
        TextUtils(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
          text: player.position,
          maxlines: 1,
        ),
        SizedBox(height: 6.h),
        _buildFootIcons(player.foot),
        SizedBox(height: 6.h),
        _buildTpsRow(player.tps),
      ],
    );
  }

  Widget _buildPhoto(ClubPlayer player) {
    final hasPhoto = player.photoPath != null && player.photoPath!.isNotEmpty;
    return Container(
      width: 52.w,
      height: 74.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: secondMainColor, width: 3.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: hasPhoto
            ? CachedNetworkImage(
          imageUrl: player.photoPath!,
          fit: BoxFit.cover,
          placeholder: (_, __) => Skeletonizer(
            enabled: true,
            child: Container(color: secondMainColor),
          ),
          errorWidget: (_, __, ___) => _photoFallback(player.name),
        )
            : _photoFallback(player.name),
      ),
    );
  }

  Widget _photoFallback(String name) {
    return Container(
      color: secondMainColor,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '؟',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFootIcons(String foot) {
    final isRight = foot == 'يمين';
    final isLeft = foot == 'يسار';
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Opacity(
          opacity: isRight ? 1.0 : 0.35,
          child: SvgPicture.asset(_rightFootAsset,
              width: 16.w,
              height: 16.w,
              colorFilter:
              const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        ),
        SizedBox(width: 4.w),
        Opacity(
          opacity: isLeft ? 1.0 : 0.35,
          child: SvgPicture.asset(_leftFootAsset,
              width: 16.w,
              height: 16.w,
              colorFilter:
              const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
        ),
      ],
    );
  }

  Widget _buildTpsRow(double tps) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/svgs/solar_star-bold-duotone.svg',
            width: 14.w, height: 14.w),
        SizedBox(width: 4.w),
        TextUtils(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: tps.toStringAsFixed(1),
        ),
      ],
    );
  }

  Widget _buildReportsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showPlayerReportsSheet(
        context,
        playerId: player.id,
        playerName: player.name,
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _lightBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, color: mainColor, size: 16.w),
            SizedBox(width: 6.w),
            TextUtils(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: mainColor,
              text: 'التقارير الرقمية'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignExerciseButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showAssignExerciseSheet(context, player: player),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [mainColor, secondMainColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_soccer_rounded,
                color: Colors.white, size: 16.w),
            SizedBox(width: 6.w),
            TextUtils(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              text: 'إضافة تمرين',
            ),
          ],
        ),
      ),
    );
  }
}