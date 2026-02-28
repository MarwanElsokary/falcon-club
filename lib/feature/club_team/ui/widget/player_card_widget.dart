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

/// Light background color for thumbnail container and reports button — Figma #EFF4FF
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
    _reelsFuture =
        context.read<ClubTeamCubit>().getReelsForPlayer(widget.player.id);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    return Container(
      // Figma specs: width 200, borderRadius 20, bg #5D2BF4, padding 16v/8h
      width: 200.w,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Player info row: details left, photo right ─────────────────
          _buildInfoRow(player),
          verticalSpace(12),

          // ── 2. Reel thumbnails ────────────────────────────────────────────
          _buildThumbnailsSection(),
          verticalSpace(8),

          // ── 3. "التقارير الرقمية" button ──────────────────────────────────
          _buildReportsButton(),
        ],
      ),
    );
  }

  // ── Info row ───────────────────────────────────────────────────────────────
  Widget _buildInfoRow(ClubPlayer player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: name, position, foot icons, TPS
        Expanded(child: _buildPlayerDetails(player)),
        horizontalSpace(8),
        // Right: photo frame
        _buildPhoto(player),
      ],
    );
  }

  // ── Player details (left column) ───────────────────────────────────────────
  Widget _buildPlayerDetails(ClubPlayer player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name — bold white
        TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: player.name,
          maxlines: 2,
        ),
        verticalSpace(4),

        // Arabic position — small white70
        TextUtils(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
          text: player.position,
          maxlines: 1,
        ),
        verticalSpace(6),

        // Foot icons using SVG assets
        _buildFootIcons(player.foot),
        verticalSpace(6),

        // TPS rating with star SVG
        _buildTpsRow(player.tps),
      ],
    );
  }

  // ── Photo frame (right side) ───────────────────────────────────────────────
  // Figma: width 48, height 65, borderRadius 120, bg #31187D, padding 4
  Widget _buildPhoto(ClubPlayer player) {
    final hasPhoto = player.photoPath != null && player.photoPath!.isNotEmpty;

    return Container(
      width: 48.w,
      height: 65.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: secondMainColor, // #31187D
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

  // ── Foot icons ─────────────────────────────────────────────────────────────
  // Vector.svg  = RIGHT foot — bright (1.0) when يمين, dimmed (0.4) when يسار
  // fteet.svg   = LEFT  foot — bright (1.0) when يسار, dimmed (0.4) when يمين
  Widget _buildFootIcons(String foot) {
    final isRight = foot == 'يمين';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Right foot
        Opacity(
          opacity: isRight ? 1.0 : 0.4,
          child: SvgPicture.asset(
            'assets/svgs/Vector.svg',
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        horizontalSpace(4),
        // Left foot (barefoot SVG)
        Opacity(
          opacity: !isRight ? 1.0 : 0.4,
          child: SvgPicture.asset(
            'assets/svgs/fteet.svg',
            width: 16.w,
            height: 16.w,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  // ── TPS with solar_star-bold-duotone.svg ──────────────────────────────────
  Widget _buildTpsRow(double tps) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svgs/solar_star-bold-duotone.svg',
          width: 14.w,
          height: 14.w,
          colorFilter: const ColorFilter.mode(
            Colors.amber,
            BlendMode.srcIn,
          ),
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

  // ── Reel thumbnails container ──────────────────────────────────────────────
  // Figma: bg #EFF4FF, borderRadius 12, border-bottom 0.5px,
  //        padding 8top/10right/8bottom/10left, gap 8 between thumbnails
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
          height: 80.h,
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
      height: 80.h,
      decoration: BoxDecoration(
        color: greyClr.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          color: greyClr,
          size: 24.w,
        ),
      ),
    );
  }

  Widget _thumbShimmer() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: greyClr.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // ── Reports button ─────────────────────────────────────────────────────────
  // Figma: bg #EFF4FF, borderRadius 12, full width, padding 8v/10h
  // In RTL layout: icon appears on the RIGHT of text
  Widget _buildReportsButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _lightBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // In RTL, first widget in Row appears on the right
          Icon(Icons.bar_chart_rounded, color: mainColor, size: 16.w),
          horizontalSpace(6),
          TextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: mainColor,
            text: 'التقارير الرقمية'.tr(),
          ),
        ],
      ),
    );
  }
}
