import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/utils/colors.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../../club_team/data/model/club_player_model.dart';
import 'home_section_header.dart';

/// The club at a glance: how many players, how many coaches, who is waiting.
///
/// Player and coach counts are read from the shell's [ClubTeamCubit], which
/// already holds them. The pending-requests count is *passed in* rather than
/// read from `RequestsCubit`: that cubit belongs to the requests tab, and this
/// widget has no business reaching into it. Whoever builds this screen decides
/// where the number comes from — and can pass null when there is none yet.
class ClubOrgSummarySection extends StatelessWidget {
  const ClubOrgSummarySection({
    super.key,
    required this.onOpenPlayers,
    required this.onOpenCoaches,
    required this.onOpenRequests,
    this.pendingRequests,
  });

  final VoidCallback onOpenPlayers;
  final VoidCallback onOpenCoaches;
  final VoidCallback onOpenRequests;

  /// Pending requests, or null when the count is not known.
  final int? pendingRequests;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubTeamCubit, ClubTeamState>(
      buildWhen: (_, ClubTeamState current) => current.maybeWhen(
        clubPlayersloading: () => true,
        clubPlayerssuccess: (_) => true,
        clubPlayerserror: (_) => true,
        clubTraineesLoading: () => true,
        clubTraineesSuccess: (_) => true,
        clubTraineesError: (_) => true,
        orElse: () => false,
      ),
      builder: (BuildContext context, _) {
        final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
        final int playerCount = cubit.groupedPlayers.values.fold<int>(
          0,
          (int sum, List<ClubPlayer> group) => sum + group.length,
        );

        return Container(
          width: context.displayWidth,
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            children: [
              HomeSectionHeader(
                iconAsset: 'assets/svgs/mage_users.svg',
                title: 'ناديك في لمحة'.tr(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _StatTile(
                        label: 'اللاعبين'.tr(),
                        value: playerCount,
                        onTap: onOpenPlayers,
                      ),
                    ),
                    horizontalSpace(10),
                    Expanded(
                      child: _StatTile(
                        label: 'المدربين'.tr(),
                        value: cubit.cachedTrainees.length,
                        onTap: onOpenCoaches,
                      ),
                    ),
                    horizontalSpace(10),
                    Expanded(
                      child: _StatTile(
                        label: 'الطلبات'.tr(),
                        value: pendingRequests,
                        // Waiting requests are the one thing here that needs
                        // acting on, so they read as urgent rather than as
                        // another statistic.
                        highlight:
                            pendingRequests != null && pendingRequests! > 0,
                        onTap: onOpenRequests,
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpace(20),
            ],
          ),
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.highlight = false,
  });

  final String label;

  /// Null renders a chevron — an entry point that does not claim a number it
  /// has not been given.
  final int? value;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final int? count = value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: kLightPurple,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 28.h,
              child: Center(
                child: count == null
                    ? Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16.w,
                        color: mainColor,
                      )
                    : CenterTextUtils(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: highlight ? redClr : mainColor,
                        text: '$count',
                        maxlines: 1,
                      ),
              ),
            ),
            verticalSpace(2),
            CenterTextUtils(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              text: label,
              maxlines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
