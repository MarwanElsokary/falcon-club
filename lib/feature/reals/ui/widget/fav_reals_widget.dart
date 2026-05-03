import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/thems/thems.dart';

class FavRealsWidget extends StatefulWidget {
  const FavRealsWidget({super.key, required this.index});
  final int index;

  @override
  // ignore: library_private_types_in_public_api
  _FavRealsWidgetState createState() => _FavRealsWidgetState();
}

class _FavRealsWidgetState extends State<FavRealsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLikeTap(RealsCubit cubit, int reelId, bool currentIsLiked) {
    // تشغيل الأنيميشن
    if (currentIsLiked) {
      _controller.reset();
    } else {
      _controller.forward();
    }

    // استدعاء الفانكشن الجديدة
    cubit.toggleLikeWithNotifier(reelId: reelId);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RealsCubit>();
    final reel = cubit.realsVide[widget.index];
    final isLikedNotifier = cubit.likeNotifiers[reel.id]!;
    final likeCountNotifier = cubit.likeCountNotifiers[reel.id]!;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _handleLikeTap(cubit, reel.id, isLikedNotifier.value),
          child: Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 45.w,
                  height: 45.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              PositionedDirectional(
                start: 0,
                bottom: 0,
                end: 0,
                top: 0,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isLikedNotifier,
                  builder: (context, isLiked, child) {
                    return Lottie.asset(
                      width: context.displayWidth / 1,
                      isLiked
                          ? 'assets/lottie/heart like animation-3.json'
                          : 'assets/lottie/heart like animation.json',
                      fit: BoxFit.cover,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller.duration = composition.duration;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        verticalSpace(3),
        SizedBox(
          width: 45.w,
          child: ValueListenableBuilder<int>(
            valueListenable: likeCountNotifier,
            builder: (context, likeCount, child) {
              return CenterTextUtils(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: '$likeCount',
              );
            },
          ),
        ),
      ],
    );
  }
}
