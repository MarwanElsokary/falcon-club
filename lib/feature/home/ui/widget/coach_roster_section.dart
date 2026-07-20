import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../../club_team/data/model/club_player_model.dart';
import 'home_section_header.dart';

/// The coach's squad, one tap from home.
///
/// Reads the roster the shell's [ClubTeamCubit] already holds — this section
/// never fetches, so it costs nothing on a screen that is always built.
class CoachRosterSection extends StatelessWidget {
  const CoachRosterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubTeamCubit, ClubTeamState>(
      buildWhen: (_, ClubTeamState current) => current.maybeWhen(
        clubPlayersloading: () => true,
        clubPlayerssuccess: (_) => true,
        clubPlayerserror: (_) => true,
        orElse: () => false,
      ),
      builder: (BuildContext context, ClubTeamState state) {
        final List<ClubPlayer> players = context
            .read<ClubTeamCubit>()
            .groupedPlayers
            .values
            .expand((List<ClubPlayer> group) => group)
            .toList();

        final bool isLoading = state.maybeWhen(
          clubPlayersloading: () => true,
          orElse: () => false,
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
                title: 'لاعبو فريقك'.tr(),
              ),
              SizedBox(
                height: 110.h,
                child: _RosterBody(players: players, isLoading: isLoading),
              ),
              verticalSpace(20),
            ],
          ),
        );
      },
    );
  }
}

class _RosterBody extends StatelessWidget {
  const _RosterBody({required this.players, required this.isLoading});

  final List<ClubPlayer> players;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Only a genuinely empty list should spin; a refresh over existing players
    // keeps showing them rather than blanking the strip.
    if (isLoading && players.isEmpty) {
      return Center(
        child: CupertinoActivityIndicator(radius: 12.w, color: mainColor),
      );
    }

    if (players.isEmpty) {
      return Center(
        child: CenterTextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          text: 'لا يوجد لاعبون في فريقك بعد'.tr(),
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: players.length,
      separatorBuilder: (_, __) => horizontalSpace(12),
      itemBuilder: (_, int i) => _RosterChip(player: players[i]),
    );
  }
}

class _RosterChip extends StatelessWidget {
  const _RosterChip({required this.player});

  final ClubPlayer player;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoute.playerProfile,
        arguments: <String, dynamic>{
          'isMyProfile': false,
          'playerId': player.id,
          'showFavoriteButton': true,
        },
      ),
      child: SizedBox(
        width: 56.w,
        child: Column(
          children: [
            ProfileAvatar(
              imageUrl: player.photoPath,
              width: 48.w,
              height: 66.w,
              borderWidth: 2.w,
              borderColor: whiteclr,
              backgroundColor: mainColor,
              fallback: CenterTextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: whiteclr,
                text: player.name.isNotEmpty ? player.name[0] : '؟',
              ),
            ),
            verticalSpace(5),
            CenterTextUtils(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              text: player.name,
              maxlines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
