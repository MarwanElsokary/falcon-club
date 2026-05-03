import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:falconclubapp/feature/club_team/ui/widget/player_reports_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/utils/colors.dart';
import 'assign_exercise_sheet.dart';

class PlayerCardWidget extends StatelessWidget {
  final ClubPlayer player;

  const PlayerCardWidget({super.key, required this.player});

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.playerProfile,
      arguments: {
        'isMyProfile': false,
        'playerId': player.id,
        'showFavoriteButton': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToProfile(context),
      child: Container(
        width: 152.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFF0EAF8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardTopSection(player: player),
            _CardBottomSection(player: player),
          ],
        ),
      ),
    );
  }
}

// ── Top — purple gradient + avatar ────────────────────────────────────────────

class _CardTopSection extends StatelessWidget {
  final ClubPlayer player;

  const _CardTopSection({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF761CBC), mainColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(12.w, 13.h, 12.w, 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // jersey number badge — فقط لو موجود

          // avatar centered + peek out
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: _PlayerAvatar(player: player),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JerseyBadge extends StatelessWidget {
  final int number;

  const _JerseyBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        '#$number',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final ClubPlayer player;

  const _PlayerAvatar({required this.player});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = player.photoPath != null && player.photoPath!.isNotEmpty;

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5.w),
        color: mainColor,
      ),
      child: ClipOval(
        child: hasPhoto
            ? CachedNetworkImage(
                imageUrl: player.photoPath!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Skeletonizer(
                  enabled: true,
                  child: Container(color: mainColor),
                ),
                errorWidget: (_, __, ___) => _AvatarFallback(name: player.name),
              )
            : _AvatarFallback(name: player.name),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;

  const _AvatarFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  mainColor,
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
}

// ── Bottom — name, position, tps, buttons ─────────────────────────────────────

class _CardBottomSection extends StatelessWidget {
  final ClubPlayer player;

  const _CardBottomSection({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(11.w, 22.h, 11.w, 11.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
          SizedBox(height: 5.h),
          _PositionPill(position: player.position),
          SizedBox(height: 7.h),
          _TpsRow(tps: player.tps),
          SizedBox(height: 7.h),
          const _CardDivider(),
          SizedBox(height: 7.h),
          _CardActions(player: player),
        ],
      ),
    );
  }
}

class _PositionPill extends StatelessWidget {
  final String position;

  const _PositionPill({required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: kLightPurple,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        position,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class _TpsRow extends StatelessWidget {
  final double tps;

  const _TpsRow({required this.tps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tps.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'TPS',
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: kTextGrey,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1.h, color: kLightPurple);
  }
}

class _CardActions extends StatelessWidget {
  final ClubPlayer player;

  const _CardActions({required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          label: 'التقارير'.tr(),
          icon: Icons.bar_chart_rounded,
          isPrimary: false,
          onTap: () => showPlayerReportsSheet(context, player: player),
        ),
        SizedBox(height: 5.h),
        _ActionButton(
          label: 'إضافة تمرين'.tr(),
          icon: Icons.sports_soccer_rounded,
          isPrimary: true,
          onTap: () => showAssignExerciseSheet(context, player: player),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 7.h),
        decoration: BoxDecoration(
          color: isPrimary ? mainColor : kLightPurple,
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13.w,
              color: isPrimary ? Colors.white : mainColor,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
