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
import 'package:skeletonizer/skeletonizer.dart';

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
    _reelsFuture = context
        .read<ClubTeamCubit>()
        .getReelsForPlayer(widget.player.id);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    return Container(
      width: 160.w,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Header: name + circle photo ───────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: player.name,
                    maxlines: 2,
                  ),
                ),
                horizontalSpace(6),
                _buildPhoto(player),
              ],
            ),
          ),

          // ── 2. Position ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextUtils(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              text: player.position,
              maxlines: 1,
            ),
          ),
          verticalSpace(4),

          // ── 3. Foot indicator + TPS ───────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                _buildFootIndicator(player.foot),
                const Spacer(),
                Icon(Icons.star, color: Colors.amber, size: 12.w),
                horizontalSpace(3),
                TextUtils(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  text: player.tps.toStringAsFixed(1),
                ),
              ],
            ),
          ),
          verticalSpace(8),

          // ── 4. Reel thumbnails ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: FutureBuilder<List<String>>(
              future: _reelsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      Expanded(child: _videoThumbShimmer()),
                      horizontalSpace(6),
                      Expanded(child: _videoThumbShimmer()),
                    ],
                  );
                }
                final urls = snapshot.data ?? [];
                return Row(
                  children: [
                    Expanded(
                      child: _videoThumb(urls.isNotEmpty ? urls[0] : null),
                    ),
                    horizontalSpace(6),
                    Expanded(
                      child: _videoThumb(urls.length > 1 ? urls[1] : null),
                    ),
                  ],
                );
              },
            ),
          ),
          verticalSpace(8),

          // ── 5. "التقارير الرقمية" button ──────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, color: mainColor, size: 14.w),
                  horizontalSpace(4),
                  TextUtils(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                    text: 'التقارير الرقمية'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Player photo (top-right circle) ────────────────────────────────────────
  Widget _buildPhoto(ClubPlayer player) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w),
      ),
      child: ClipOval(
        child: player.photoPath != null && player.photoPath!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: player.photoPath!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Skeletonizer(
                  enabled: true,
                  child: Container(color: fillColor),
                ),
                errorWidget: (_, __, ___) => _fallbackPhoto(player.name),
              )
            : _fallbackPhoto(player.name),
      ),
    );
  }

  Widget _fallbackPhoto(String name) {
    return Container(
      color: secondMainColor,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Foot indicator ──────────────────────────────────────────────────────────
  Widget _buildFootIndicator(String foot) {
    // TODO: Replace with SVG assets when available
    // Right foot asset: assets/svgs/foot_right.svg
    // Left foot asset: assets/svgs/foot_left.svg
    final isRight = foot == 'يمين';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First icon represents right foot
        Text(
          '🦶',
          style: TextStyle(
            fontSize: 12.sp,
            color: isRight ? Colors.white : Colors.white38,
          ),
        ),
        horizontalSpace(2),
        // Second icon represents left foot (mirrored)
        Transform.scale(
          scaleX: -1,
          child: Text(
            '🦶',
            style: TextStyle(
              fontSize: 12.sp,
              color: !isRight ? Colors.white : Colors.white38,
            ),
          ),
        ),
      ],
    );
  }

  // ── Video thumbnail ─────────────────────────────────────────────────────────
  Widget _videoThumb(String? url) {
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: CachedNetworkImage(
          imageUrl: url,
          height: 90.h,
          fit: BoxFit.cover,
          placeholder: (_, __) => _videoThumbShimmer(),
          errorWidget: (_, __, ___) => _videoThumbPlaceholder(),
        ),
      );
    }
    return _videoThumbPlaceholder();
  }

  Widget _videoThumbPlaceholder() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: secondMainColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          color: Colors.white54,
          size: 26.w,
        ),
      ),
    );
  }

  Widget _videoThumbShimmer() {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: secondMainColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
