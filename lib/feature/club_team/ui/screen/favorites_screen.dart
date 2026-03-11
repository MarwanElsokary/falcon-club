// ══════════════════════════════════════════════════════════════════
// favorites_screen.dart
// ══════════════════════════════════════════════════════════════════

import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falcon/feature/club_team/cubit/club_team_state.dart';
import 'package:falcon/feature/club_team/data/model/club_player_model.dart';
import 'package:falcon/feature/club_team/ui/widget/favorite_player_card_widget.dart';
import 'package:falcon/feature/club_team/ui/widget/invite_form_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClubTeamCubit>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteclr,
      body: Stack(
        children: [
          // ── Background SVG — نفس ExperimentScreen ──────────────────────
          PositionedDirectional(
            start: 0,
            top: 0,
            child: SvgPicture.asset(
              'assets/svgs/Group 386.svg',
              width: 120.w,
            ),
          ),

          // ── المحتوى ────────────────────────────────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // ── Header ───────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // زر الرجوع — بس السهم بدون نص
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: mainColor,
                              size: 16.w,
                            ),
                          ),
                        ),
                      ),

                      // العنوان على اليمين
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextUtils(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            text: 'قائمة اللاعبين'.tr(),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.bookmark,
                              color: mainColor, size: 26.w),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // ── Grid ─────────────────────────────────────────────────
                Expanded(
                  child: BlocBuilder<ClubTeamCubit, ClubTeamState>(
                    buildWhen: (prev, curr) =>
                    curr is favLoading ||
                        curr is favSuccess ||
                        curr is favError,
                    builder: (context, state) {
                      return state.maybeWhen(
                        favloading: () => Center(
                          child:
                          CupertinoActivityIndicator(radius: 15.w),
                        ),
                        faverror: (error) => _buildError(error),
                        favsuccess: (data) {
                          final players = context
                              .read<ClubTeamCubit>()
                              .cachedFavPlayers;
                          return _buildGrid(players);
                        },
                        orElse: () => Center(
                          child:
                          CupertinoActivityIndicator(radius: 15.w),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<ClubPlayer> players) {
    if (players.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border_outlined,
                color: greyClr, size: 60.w),
            verticalSpace(16),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: greyClr,
              text: 'لا يوجد لاعبون في قائمة الاهتمامات'.tr(),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.58,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return FavoritePlayerCardWidget(
          player: player,
          rankIndex: index,
          onInviteTap: () =>
              showInviteFormSheet(context, playerName: player.name),
        );
      },
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: redClr, size: 40.w),
          verticalSpace(10),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            text: error,
          ),
          verticalSpace(16),
          ElevatedButton(
            onPressed: () =>
                context.read<ClubTeamCubit>().fetchFavorites(),
            style:
            ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: Text('إعادة المحاولة'.tr(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}