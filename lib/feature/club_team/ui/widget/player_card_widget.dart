import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/viewer_capability_port.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_state.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:falconclubapp/feature/club_team/ui/widget/player_reports_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widget/profile_avatar.dart';
import '../../../../core/widget/show_confirm_dialog.dart';
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
    // The shared profile frame at card scale — same tall rounded portrait as
    // the profile screens, keeping this card's own white-on-purple styling and
    // its initial-letter fallback.
    return ProfileAvatar(
      imageUrl: player.photoPath,
      width: 64.w,
      height: 90.w,
      borderWidth: 2.5.w,
      borderColor: Colors.white,
      backgroundColor: mainColor,
      fallback: _AvatarFallback(name: player.name),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;

  const _AvatarFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
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

// ── Actions — التقارير / إضافة تمرين / حذف من الفريق ──────────────────────────

class _CardActions extends StatelessWidget {
  final ClubPlayer player;

  const _CardActions({required this.player});

  void _confirmDelete(BuildContext context) {
    final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
    showConfirmDialog(
      context: context,
      isDestructive: true,
      title: 'هل تريد حذف "${player.name}" من الفريق؟'.tr(),
      onConfirm: () => cubit.deletePlayerFromTeam(player.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubTeamCubit, ClubTeamState>(
      buildWhen: (_, current) => current.maybeWhen(
        deleteTraineeLoading: () => true,
        deleteTraineeSuccess: (_) => true,
        deleteTraineeError: (_) => true,
        clubPlayerssuccess: (_) => true,
        orElse: () => false,
      ),
      builder: (context, state) {
        final isDeleting = state.maybeWhen(
          deleteTraineeLoading: () => true,
          orElse: () => false,
        );

        // "إضافة تمرين" ends in a video upload, which is Club-only.
        //
        // This card is reached from the drawer's "فريقي" item as well as the
        // Club's team tab — and `DrawerPermissions.canShowMyTeam` grants that
        // item to **MainClub**. So a MainClub supervisor could open this and
        // upload an attempt for a player, which is the coach's job, not theirs.
        // Same rule as the Scout hole in the trials flow, a different door.
        final bool canUpload = getIt<ViewerCapabilityPort>()
            .current()
            .canUploadAttempt;

        return Column(
          children: [
            _ActionButton(
              label: 'التقارير'.tr(),
              icon: Icons.bar_chart_rounded,
              isPrimary: false,
              onTap: () => showPlayerReportsSheet(context, player: player),
            ),
            if (canUpload) ...[
              SizedBox(height: 5.h),
              _ActionButton(
                label: 'إضافة تمرين'.tr(),
                icon: Icons.sports_soccer_rounded,
                isPrimary: true,
                onTap: () => showAssignExerciseSheet(
                  context,
                  player: player,
                  onUploaded: () =>
                      context.read<ClubTeamCubit>().fetchClubPlayers(),
                ),
              ),
            ],
            SizedBox(height: 5.h),
            _DeleteFromTeamButton(
              isLoading: isDeleting,
              onTap: () => _confirmDelete(context),
            ),
          ],
        );
      },
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
            Icon(icon, size: 13.w, color: isPrimary ? Colors.white : mainColor),
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

// ── زر حذف من الفريق ────────────────────────────────────────────────────────

class _DeleteFromTeamButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _DeleteFromTeamButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Colors.red.shade400;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 7.h),
        decoration: BoxDecoration(
          color: isLoading ? color.withOpacity(0.4) : color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              size: 13.w,
              color: isLoading ? Colors.white54 : color,
            ),
            SizedBox(width: 4.w),
            Text(
              'حذف من الفريق'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isLoading ? Colors.white54 : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
