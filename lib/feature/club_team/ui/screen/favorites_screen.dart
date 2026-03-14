import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/constants.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
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

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isScout = false;

  @override
  void initState() {
    super.initState();
    context.read<ClubTeamCubit>().fetchFavorites();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final userType = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userType,
    );
    if (mounted) {
      setState(() {
        _isScout = userType == 'scout';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteclr,
      body: SafeArea(
        child: Column(
          children: [
            verticalSpace(12),
            _buildHeader(),
            verticalSpace(12),
            Expanded(
              child: BlocBuilder<ClubTeamCubit, ClubTeamState>(
                buildWhen: (prev, curr) =>
                    curr is favLoading ||
                    curr is favSuccess ||
                    curr is favError,
                builder: (context, state) {
                  return state.maybeWhen(
                    favloading: () => Center(
                      child: CupertinoActivityIndicator(radius: 15.w),
                    ),
                    faverror: (error) => _buildError(error),
                    favsuccess: (data) {
                      final players =
                          context.read<ClubTeamCubit>().cachedFavPlayers;
                      return _buildGrid(players);
                    },
                    orElse: () => Center(
                      child: CupertinoActivityIndicator(radius: 15.w),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_ios, color: mainColor, size: 14.w),
                horizontalSpace(4),
                TextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                  text: 'الرجوع'.tr(),
                ),
              ],
            ),
          ),
          // Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bookmark, color: mainColor, size: 24.w),
              horizontalSpace(6),
              TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'قائمة اللاعبين'.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Grid ──────────────────────────────────────────────────────────────────
  Widget _buildGrid(List<ClubPlayer> players) {
    if (players.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_outlined,
              color: greyClr,
              size: 60.w,
            ),
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
          showInviteButton: !_isScout,
          onInviteTap: _isScout
              ? () {}
              : () => showInviteFormSheet(
                    context,
                    playerName: player.name,
                  ),
        );
      },
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
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
            onPressed: () {
              context.read<ClubTeamCubit>().fetchFavorites();
            },
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: Text(
              'إعادة المحاولة'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
