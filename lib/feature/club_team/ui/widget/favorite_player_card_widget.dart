import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falcon/feature/club_team/data/model/club_player_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Light background color for thumbnail container and button — Figma #EFF4FF
const Color _lightBg = Color(0xFFEFF4FF);

/// Player card variant used in the Favorites 2-column grid.
/// Shows rank badge top-left, "ارسال دعوة" button instead of reports button.
class FavoritePlayerCardWidget extends StatefulWidget {
  final ClubPlayer player;
  final int rankIndex; // 0-based, displayed as rankIndex+1
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
    _reelsFuture =
        context.read<ClubTeamCubit>().getReelsForPlayer(widget.player.id);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Card ──────────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Player info row
              _buildInfoRow(player),
              verticalSpace(12),

              // 2. Reel thumbnails
              _buildThumbnailsSection(),
              verticalSpace(8),

              // 3. "ارسال دعوة" button
              _buildInviteButton(),
            ],
          ),
        ),

        // ── Rank badge — top-start corner ──────────────────────────────
        PositionedDirectional(
          top: -8.h,
          start: -8.w,
          child: Container(
            width: 28.w,
            height: 28.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFB800), // gold
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
    );
  }

  // ── Info row ─────────────────────────────────────────────────────────────
  Widget _buildInfoRow(ClubPlayer player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildPlayerDetails(player)),
        horizontalSpace(8),
        _buildPhoto(player),
      ],
    );
  }

  // ── Player details ────────────────────────────────────────────────────────
  Widget _buildPlayerDetails(ClubPlayer player) {
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
        verticalSpace(4),
        TextUtils(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
          text: player.position,
          maxlines: 1,
        ),
        verticalSpace(6),
        _buildFootIcons(player.foot),
        verticalSpace(6),
        _buildTpsRow(player.tps),
      ],
    );
  }

  // ── Photo ─────────────────────────────────────────────────────────────────
  Widget _buildPhoto(ClubPlayer player) {
    final hasPhoto = player.photoPath != null && player.photoPath!.isNotEmpty;
    return Container(
      width: 48.w,
      height: 65.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: secondMainColor,
        borderRadius: BorderRadius.circular(120.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(116.r),
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
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Foot icons ────────────────────────────────────────────────────────────
  Widget _buildFootIcons(String foot) {
    final isRight = foot == 'يمين';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: isRight ? 1.0 : 0.4,
          child: SvgPicture.asset(
            'assets/svgs/Vector.svg',
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        horizontalSpace(4),
        Opacity(
          opacity: !isRight ? 1.0 : 0.4,
          child: SvgPicture.asset(
            'assets/svgs/fteet.svg',
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  // ── TPS ───────────────────────────────────────────────────────────────────
  Widget _buildTpsRow(double tps) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svgs/solar_star-bold-duotone.svg',
          width: 14.w,
          height: 14.w,
          colorFilter: const ColorFilter.mode(Colors.amber, BlendMode.srcIn),
        ),
        horizontalSpace(4),
        TextUtils(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: tps.toStringAsFixed(1),
        ),
      ],
    );
  }

  // ── Thumbnails ────────────────────────────────────────────────────────────
  Widget _buildThumbnailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: _lightBg,
        borderRadius: BorderRadius.circular(12.r),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFCBD5E0), width: 0.5),
        ),
      ),
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
      child: FutureBuilder<List<String>>(
        future: _reelsFuture,
        builder: (context, snapshot) {
          final isLoading =
              snapshot.connectionState == ConnectionState.waiting;
          final urls = snapshot.data ?? [];
          return Row(
            children: [
              Expanded(
                child: isLoading
                    ? _thumbShimmer()
                    : _thumbWidget(
                        urls.isNotEmpty ? urls[0] : null,
                      ),
              ),
              horizontalSpace(8),
              Expanded(
                child: isLoading
                    ? _thumbShimmer()
                    : _thumbWidget(
                        urls.length > 1 ? urls[1] : null,
                      ),
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
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: url,
          height: 70.h,
          fit: BoxFit.cover,
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
        borderRadius: BorderRadius.circular(12.r),
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
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // ── Invite button ─────────────────────────────────────────────────────────
  Widget _buildInviteButton() {
    return GestureDetector(
      onTap: widget.onInviteTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _lightBg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: mainColor, size: 16.w),
            horizontalSpace(6),
            TextUtils(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: mainColor,
              text: 'ارسال دعوة'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
