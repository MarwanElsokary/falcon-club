import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falcon/feature/club_team/data/model/club_player_model.dart';
import 'package:falcon/feature/club_team/ui/widget/player_reports_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';
import 'assign_exercise_sheet.dart';

const String _rightFootAsset = 'assets/svgs/right.svg';
const String _leftFootAsset = 'assets/svgs/material-symbols_barefoot.svg';
const Color _lightBg = Color(0xFFEFF4FF);

class PlayerCardWidget extends StatefulWidget {
  final ClubPlayer player;

  const PlayerCardWidget({super.key, required this.player});

  @override
  State<PlayerCardWidget> createState() => _PlayerCardWidgetState();
}

class _PlayerCardWidgetState extends State<PlayerCardWidget> {
  late Future<List<String>> _reelsFuture;

  @override
  void initState() {
    super.initState();
    _reelsFuture = context.read<ClubTeamCubit>().getReelsForPlayer(
      widget.player.id,
    );
  }

  void _navigateToProfile() {
    Navigator.of(context).pushNamed(
      AppRoute.playerProfile,
      arguments: {'isMyProfile': false, 'playerId': widget.player.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToProfile,
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
            _buildInfoRow(widget.player),
            SizedBox(height: 8.h),
            Expanded(child: _buildThumbnailsSection()),
            SizedBox(height: 8.h),
            _buildReportsButton(context),
            SizedBox(height: 6.h),
            _buildAssignExerciseButton(context),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // INFO ROW
  // RTL layout: الاسم + بيانات على اليسار، الصورة على اليمين الفيزيائي
  //
  // نستخدم Directionality.of لضمان الصورة دايما يمين فيزيائي:
  //   Row children: [photo, Expanded(text)]   ← في RTL هيرسم: text | photo
  //                                              photo على اليمين ✓
  // ══════════════════════════════════════════════════════════════════
  Widget _buildInfoRow(ClubPlayer player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        // في RTL: هذا هو الـ child الأول فيظهر على اليمين الفيزيائي
        _buildPhoto(player),
        SizedBox(width: 8.w),
        // النص يملأ الباقي على اليسار
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

  // ── الصورة — oval بالظبط زي PlayerImageWidget ───────────────────
  // PlayerImageWidget: width 98.w, height 139.w, borderRadius 100.r
  // هنا نصغّرها تناسبياً للكارت: width 52.w, height 74.w
  Widget _buildPhoto(ClubPlayer player) {
    final hasPhoto = player.photoPath != null && player.photoPath!.isNotEmpty;
    return Container(
      width: 52.w,
      height: 74.w, // oval: height > width
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
          child: SvgPicture.asset(
            _rightFootAsset,
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: 4.w),
        Opacity(
          opacity: isLeft ? 1.0 : 0.35,
          child: SvgPicture.asset(
            _leftFootAsset,
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  Widget _buildTpsRow(double tps) {
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
          text: tps.toStringAsFixed(1),
        ),
      ],
    );
  }

  Widget _buildThumbnailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: _lightBg,
        borderRadius: BorderRadius.circular(12.r),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFCBD5E0), width: 0.5),
        ),
      ),
      padding: EdgeInsets.all(8.w),
      child: FutureBuilder<List<String>>(
        future: _reelsFuture,
        builder: (context, snapshot) {
          final loading = snapshot.connectionState == ConnectionState.waiting;
          final urls = snapshot.data ?? [];
          return Row(
            children: [
              Expanded(
                child: loading
                    ? _thumbShimmer()
                    : _thumbWidget(urls.isNotEmpty ? urls[0] : null),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: loading
                    ? _thumbShimmer()
                    : _thumbWidget(urls.length > 1 ? urls[1] : null),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _thumbWidget(String? url) {
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (_, __) => _thumbShimmer(),
          errorWidget: (_, __, ___) => _thumbPlaceholder(),
        ),
      );
    }
    return _thumbPlaceholder();
  }

  Widget _thumbPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: greyClr.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Icon(Icons.play_circle_outline, color: greyClr, size: 24.w),
      ),
    );
  }

  Widget _thumbShimmer() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: greyClr.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildReportsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showPlayerReportsSheet(
        context,
        playerId: widget.player.id,
        playerName: widget.player.name,
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
      onTap: () => showAssignExerciseSheet(context, player: widget.player),
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
            Icon(Icons.sports_soccer_rounded, color: Colors.white, size: 16.w),
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