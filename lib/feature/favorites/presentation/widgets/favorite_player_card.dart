import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/widget/profile_avatar.dart';
import '../../domain/entities/favorite_player.dart';
import 'animated_favorite_heart.dart';

/// A favourite player in the grid.
///
/// Shares the visual language and scale of the "فريقي" roster card
/// (`PlayerCardWidget`): a white card with a purple-gradient top, a centered
/// avatar peeking into a white lower section carrying name / position / TPS.
/// The roster card's report / assign-exercise / delete actions are intentionally
/// omitted for now (deferred until the Profile feature wraps); here the extras
/// are a gold rank badge and a red **un-favourite heart**.
class FavoritePlayerCard extends StatelessWidget {
  const FavoritePlayerCard({
    super.key,
    required this.player,
    required this.rankIndex,
    required this.onUnfavorite,
  });

  final FavoritePlayer player;
  final int rankIndex;
  final VoidCallback onUnfavorite;

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.playerProfile,
      arguments: <String, dynamic>{
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: const Color(0xFFF0EAF8)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildTop(), _buildBottom()],
            ),
          ),

          // ── Rank badge — top-start (يمين في RTL) ───────────────────────
          PositionedDirectional(
            top: -8.h,
            start: -8.w,
            child: _corner(
              const Color(0xFFFFB800),
              child: Text(
                '${rankIndex + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          // ── Un-favourite heart — top-end (يسار في RTL), Reels style ────
          PositionedDirectional(
            top: -8.h,
            end: -8.w,
            child: AnimatedFavoriteHeart(
              isFavorited: true, // everything in this grid is a favourite
              onTap: onUnfavorite,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner(Color color, {required Widget child}) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Center(child: child),
    );
  }

  Widget _buildTop() {
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
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 6.h, bottom: 18.h),
          child: _buildAvatar(),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    // Same shared portrait frame, and the same dimensions/styling as the roster
    // card — this card copied that card's chrome rather than reusing it, so the
    // two have to be kept deliberately in step.
    return ProfileAvatar(
      imageUrl: player.photoUrl,
      width: 64.w,
      height: 90.w,
      borderWidth: 2.5.w,
      borderColor: Colors.white,
      backgroundColor: mainColor,
      fallback: _avatarFallback(),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: mainColor,
      alignment: Alignment.center,
      child: Text(
        player.name.isNotEmpty ? player.name[0] : '؟',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBottom() {
    final String position = player.position ?? '';
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(11.w, 18.h, 11.w, 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: mainColor,
            ),
          ),
          if (position.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Container(
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
            ),
          ],
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                player.tps?.toStringAsFixed(1) ?? '-',
                style: TextStyle(
                  fontSize: 15.sp,
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
          ),
        ],
      ),
    );
  }
}
