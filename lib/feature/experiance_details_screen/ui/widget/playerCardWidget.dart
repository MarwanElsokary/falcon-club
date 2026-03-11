import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/data/model/club_player_model.dart';
import 'package:falcon/feature/club_team/ui/widget/player_reports_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';

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
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── صورة + بيانات ─────────────────────────────────────
            _buildInfoRow(),
            SizedBox(height: 12.h),

            // ── زرار التقارير الرقمية ─────────────────────────────
            _buildReportsButton(context),
            SizedBox(height: 8.h),

            // ── زرار إضافة محاولة ────────────────────────────────
            _buildAddAttemptButton(context),
          ],
        ),
      ),
    );
  }

  // ── Info Row ────────────────────────────────────────────────────
  Widget _buildInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الصورة على اليمين في RTL
        _buildPhoto(),
        SizedBox(width: 8.w),
        Expanded(child: _buildPlayerDetails()),
      ],
    );
  }

  Widget _buildPlayerDetails() {
    return Column(
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
        _buildFootIcons(),
        SizedBox(height: 6.h),
        _buildTpsRow(),
      ],
    );
  }

  // ── صورة oval ──────────────────────────────────────────────────
  Widget _buildPhoto() {
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

  Widget _buildFootIcons() {
    final isRight = player.foot == 'يمين';
    final isLeft = player.foot == 'يسار';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: isRight ? 1.0 : 0.35,
          child: SvgPicture.asset(
            _rightFootAsset,
            width: 16.w,
            height: 16.w,
            colorFilter:
            const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: 4.w),
        Opacity(
          opacity: isLeft ? 1.0 : 0.35,
          child: SvgPicture.asset(
            _leftFootAsset,
            width: 16.w,
            height: 16.w,
            colorFilter:
            const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  Widget _buildTpsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svgs/solar_star-bold-duotone.svg',
          width: 14.w,
          height: 14.w,
        ),
        SizedBox(width: 4.w),
        TextUtils(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: player.tps.toStringAsFixed(1),
        ),
      ],
    );
  }

  // ── زرار التقارير الرقمية ──────────────────────────────────────
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
        padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, color: mainColor, size: 15.w),
            SizedBox(width: 5.w),
            TextUtils(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: mainColor,
              text: 'التقارير الرقمية'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  // ── زرار إضافة محاولة ─────────────────────────────────────────
  Widget _buildAddAttemptButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddAttemptSheet(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: secondMainColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.white, size: 15.w),
            SizedBox(width: 5.w),
            TextUtils(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              text: 'إضافة محاولة'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Sheet — اختيار التمرين ─────────────────────────────
  void _showAddAttemptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAttemptFromCardSheet(player: player),
    );
  }
}

// ── Bottom Sheet — اختيار التمرين للاعب ───────────────────────────
class _AddAttemptFromCardSheet extends StatelessWidget {
  const _AddAttemptFromCardSheet({required this.player});
  final ClubPlayer player;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ───────────────────────────────────────────
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: greyClr.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          verticalSpace(16),

          // ── هيدر ─────────────────────────────────────────────
          TextUtils(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'إضافة محاولة لـ ${player.name}',
          ),
          verticalSpace(6),
          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: greyClr,
            text: 'اختر التمرين الذي تريد إضافة محاولة له'.tr(),
          ),
          verticalSpace(20),

          // ── زرار الانتقال لصفحة التمارين ─────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.pushNamed(
                  AppRoute.trainingDetailsScreen,
                  arguments: {
                    'playerId': player.id,
                  },
                );
              },
              icon:
              const Icon(Icons.fitness_center, color: Colors.white),
              label: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: 'اختيار تمرين'.tr(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}