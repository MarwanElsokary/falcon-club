// ══════════════════════════════════════════════════════════════════
// favorite_player_card_widget.dart
// ══════════════════════════════════════════════════════════════════

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';

const Color _lightBg = Color(0xFFEFF4FF);

// نفس مسارات الـ assets في PlayerCardWidget
const String _rightFootAsset = 'assets/svgs/right.svg';
const String _leftFootAsset = 'assets/svgs/material-symbols_barefoot.svg';

class FavoritePlayerCardWidget extends StatefulWidget {
  final ClubPlayer player;
  final int rankIndex;
  final VoidCallback onInviteTap;

  const FavoritePlayerCardWidget({
    super.key,
    required this.player,
    required this.rankIndex,
    required this.onInviteTap,
  });

  @override
  State<FavoritePlayerCardWidget> createState() =>
      _FavoritePlayerCardWidgetState();
}

class _FavoritePlayerCardWidgetState extends State<FavoritePlayerCardWidget> {
  late Future<List<String>> _reelsFuture;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToProfile() {
    Navigator.of(context).pushNamed(
      AppRoute.playerProfile,
      arguments: {
        'isMyProfile': false,
        'playerId': widget.player.id,
        'showFavoriteButton': true,
        // ← المدرب والكشاف بس
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    return GestureDetector(
      onTap: _navigateToProfile,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Card ────────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(player),
                SizedBox(height: 8.h),
                _buildThumbnailsSection(),
                SizedBox(height: 8.h),
                // _buildInviteButton(),
              ],
            ),
          ),

          // ── Rank badge — top-start (يمين في RTL) ───────────────────────
          PositionedDirectional(
            top: -8.h,
            start: -8.w,
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFB800),
              ),
              child: Center(
                child: Text(
                  '${widget.rankIndex + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Info row: صورة oval على اليمين، نص على اليسار ────────────────────────
  // نفس منطق PlayerCardWidget: الصورة أول child → يمين فيزيائي في RTL
  Widget _buildInfoRow(ClubPlayer player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // يمين: الصورة
        _buildPhoto(player),
        SizedBox(width: 8.w),
        // يسار: النص
        Expanded(child: _buildPlayerDetails(player)),
      ],
    );
  }

  Widget _buildPlayerDetails(ClubPlayer player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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

  // ── الصورة oval — نفس PlayerCardWidget و PlayerImageWidget ───────────────
  Widget _buildPhoto(ClubPlayer player) {
    final hasPhoto = player.photoPath != null && player.photoPath!.isNotEmpty;
    return Container(
      width: 48.w,
      height: 68.w, // oval: height > width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: secondMainColor, width: 2.5.w),
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
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildFootIcons(String foot) {
    final isRight = foot == 'يمين';
    final isLeft = foot == 'يسار';
    return Row(
      mainAxisSize: MainAxisSize.min,
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
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final urls = snapshot.data ?? [];
          return Row(
            children: [
              Expanded(
                child: isLoading
                    ? _thumbShimmer()
                    : _thumbWidget(urls.isNotEmpty ? urls[0] : null),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: isLoading
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
          height: 70.h,
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
      height: 70.h,
      decoration: BoxDecoration(
        color: greyClr.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Icon(Icons.play_circle_outline, color: greyClr, size: 22.w),
      ),
    );
  }

  Widget _thumbShimmer() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: greyClr.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  // ── Invite button — GestureDetector منفصل يمنع الـ tap من الوصول للكارت ──
  // Widget _buildInviteButton() {
  //   return GestureDetector(
  //     onTap: widget.onInviteTap,
  //     behavior: HitTestBehavior.opaque,
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: _lightBg,
  //         borderRadius: BorderRadius.circular(12.r),
  //       ),
  //       padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.send_rounded, color: mainColor, size: 16.w),
  //           SizedBox(width: 6.w),
  //           TextUtils(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //             color: mainColor,
  //             text: 'ارسال دعوة'.tr(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
