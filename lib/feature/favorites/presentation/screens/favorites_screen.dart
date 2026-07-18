import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/favorite_player.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/favorite_player_card.dart';

/// The coach's favourites tab (Club main screen, index 3).
///
/// Runs on the domain [FavoritesCubit] (was `ClubTeamCubit.fetchFavorites`).
/// Each card can un-favourite (optimistic, then a silent re-read); a failed
/// toggle rolls back and shows a snackbar without tearing down the grid.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
            child: SvgPicture.asset('assets/svgs/Group 386.svg', width: 120.w),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                _buildHeader(),
                SizedBox(height: 16.h),
                Expanded(
                  child: BlocConsumer<FavoritesCubit, FavoritesState>(
                    listenWhen: (_, curr) => curr is FavoritesActionError,
                    listener: (context, state) {
                      if (state is FavoritesActionError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: redClr,
                          ),
                        );
                      }
                    },
                    builder: (context, state) => switch (state) {
                      FavoritesLoaded(:final List<FavoritePlayer> players) =>
                        _buildGrid(context, players),
                      FavoritesActionError(
                        :final List<FavoritePlayer> players,
                      ) =>
                        _buildGrid(context, players),
                      FavoritesFailure(:final String message) => _buildError(
                        context,
                        message,
                      ),
                      _ => Center(
                        child: CupertinoActivityIndicator(radius: 15.w),
                      ),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.groups, color: mainColor, size: 26.w),
          SizedBox(width: 6.w),
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: ' اللاعبين المميزين'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<FavoritePlayer> players) {
    // Pull-to-refresh: a manual GetFavPlayers re-read, as a backstop to the live
    // sync (and for when the coach just wants to force a reload). Always
    // scrollable so the pull works even with few cards or an empty list.
    return RefreshIndicator(
      color: mainColor,
      onRefresh: () => context.read<FavoritesCubit>().refresh(),
      child: players.isEmpty ? _buildEmpty() : _buildCards(context, players),
    );
  }

  Widget _buildEmpty() {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
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
          ),
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context, List<FavoritePlayer> players) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 20.h,
        childAspectRatio: 0.80,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final FavoritePlayer player = players[index];
        return FavoritePlayerCard(
          player: player,
          rankIndex: index,
          onUnfavorite: () =>
              context.read<FavoritesCubit>().unfavorite(player.id),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String error) {
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
            onPressed: () => context.read<FavoritesCubit>().load(),
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
