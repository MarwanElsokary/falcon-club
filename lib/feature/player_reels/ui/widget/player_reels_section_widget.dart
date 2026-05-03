import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/networking/api_service.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/feature/player_reels/cubit/player_reels_cubit.dart';
import 'package:falconclubapp/feature/player_reels/data/repo/player_reels_repo.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/data/model/real_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

const Color _lightBg = Color(0xFFEFF4FF);

/// قسم الريلز في PlayerCardWidget
/// — يعرض الريلز أفقياً بـ thumbnail
/// — لما تضغط على ريل يفتح RealsScreen مبدأه من الريل ده
class PlayerReelsSectionWidget extends StatelessWidget {
  final String playerId;

  const PlayerReelsSectionWidget({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlayerReelsCubit>()..fetchReels(playerId),
      child: _ReelsSectionBody(playerId: playerId),
    );
  }
}

class _ReelsSectionBody extends StatelessWidget {
  final String playerId;

  const _ReelsSectionBody({required this.playerId});

  void _openReels(BuildContext context, List<RealsVide> reels, int startIndex) {
    // نحمّل الريلز في RealsCubit ثم نروح للشاشة
    final realsCubit = getIt<RealsCubit>();
    realsCubit.realsVide = List.from(reels);
    realsCubit.initializeNotifiers();

    Navigator.of(context).pushNamed(
      AppRoute.mainRealsScreen,
      arguments: {
        'playnowOrNot': true,
        'playerProfile': true,
        'startIndex': startIndex,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerReelsCubit, PlayerReelsState>(
      builder: (context, state) {
        if (state is PlayerReelsLoading) {
          return _buildShimmer();
        }
        if (state is PlayerReelsSuccess && state.reels.isNotEmpty) {
          return _buildReelsList(context, state.reels);
        }
        // Initial / Error / Empty — نعرض placeholder
        return _buildEmpty();
      },
    );
  }

  // ── Reels horizontal list ────────────────────────────────────────────────
  Widget _buildReelsList(BuildContext context, List<RealsVide> reels) {
    return SizedBox(
      height: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: reels.length,
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => _openReels(context, reels, index),
            child: _ReelThumb(reel: reels[index]),
          );
        },
      ),
    );
  }

  // ── Shimmer ────────────────────────────────────────────────────────────────
  Widget _buildShimmer() {
    return Row(
      children: List.generate(
        2,
            (_) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Skeletonizer(
              enabled: true,
              child: Container(
                decoration: BoxDecoration(
                  color: greyClr.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Empty placeholder ──────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Icon(
        Icons.play_circle_outline_rounded,
        color: greyClr.withOpacity(0.5),
        size: 32.w,
      ),
    );
  }
}

// ── Single reel thumbnail ──────────────────────────────────────────────────────
class _ReelThumb extends StatelessWidget {
  final RealsVide reel;

  const _ReelThumb({required this.reel});

  @override
  Widget build(BuildContext context) {
    // نستخدم shareVideo كـ thumbnail لأنه صورة/فيديو مباشر
    // أو نعرض play icon فقط لو مفيش صورة
    final thumbUrl = reel.shareVideo ?? '';
    final hasThumb = thumbUrl.isNotEmpty &&
        (thumbUrl.endsWith('.jpg') ||
            thumbUrl.endsWith('.jpeg') ||
            thumbUrl.endsWith('.png') ||
            thumbUrl.endsWith('.webp'));

    return Container(
      width: 72.w,
      margin: EdgeInsets.only(left: 6.w),
      decoration: BoxDecoration(
        color: greyClr.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // صورة أو خلفية
            if (hasThumb)
              CachedNetworkImage(
                imageUrl: thumbUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    color: greyClr.withOpacity(0.2)),
                errorWidget: (_, __, ___) => _videoBackground(),
              )
            else
              _videoBackground(),

            // Play icon overlay
            Center(
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videoBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainColor.withOpacity(0.3),
            mainColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}