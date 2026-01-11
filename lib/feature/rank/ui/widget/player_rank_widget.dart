import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/rank/cubit/rank_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/widget/show_photo_widget.dart';

class PlayerRankWidget extends StatefulWidget {
  const PlayerRankWidget({super.key});

  @override
  State<PlayerRankWidget> createState() => _PlayerRankWidgetState();
}

class _PlayerRankWidgetState extends State<PlayerRankWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool showAllData = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    /// 🔥 Delay 500ms before animation starts
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
    showAllDataFun();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  showAllDataFun() async {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showAllData = true;
        log('$showAllData');
      });
    });
  }

  /// 🔥 Stagger animation per item
  Animation<double> _buildStagger(int index, int total) {
    final start = (index / total) * 0.6;
    final end = start + 0.4;

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutBack),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = context.read<RankCubit>().rankList;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: showAllData
          ? items.length
          : items.length > 15
          ? 15
          : items.length,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemBuilder: (context, index) {
        final anim = _buildStagger(
          index,
          showAllData
              ? items.length
              : items.length > 15
              ? 15
              : items.length,
        );

        return AnimatedBuilder(
          animation: anim,
          builder: (context, child) {
            final v = anim.value.clamp(0.0, 1.0);

            return Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, (1 - v) * -40),
                child: child,
              ),
            );
          },

          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 36.w,
                    child: Center(
                      child: index == 0
                          ? SvgPicture.asset(
                              'assets/svgs/Group 432.svg',
                              width: 30.w,
                            )
                          : index == 1
                          ? SvgPicture.asset(
                              'assets/svgs/Group 430.svg',
                              width: 30.w,
                            )
                          : index == 2
                          ? SvgPicture.asset(
                              'assets/svgs/Group 431.svg',
                              width: 30.w,
                            )
                          : TextUtils(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              text: '${index + 1}',
                            ),
                    ),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRoute.playerProfile,
                          arguments: {
                            'isMyProfile': true,
                            'playerId':
                                '${context.read<RankCubit>().rankList[index].id}',
                          },
                        );
                      },
                      child: Row(
                        children: [
                          horizontalSpace(20),

                          /// 🔥 Profile photo with gradient ring
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              showPhotoDialog(
                                context: context,
                                image: items[index].photoPath ?? '',
                                name: items[index].name ?? '',
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFA5731D),
                                        Color(0xFFA5731D),
                                        Color(0xFFE4D48E),
                                      ],
                                      stops: [0.0, 0.476, 1.0],
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),

                                ClipOval(
                                  child: SizedBox(
                                    width: 26.w,
                                    height: 26.w,
                                    child: CachedNetworkImage(
                                      imageUrl: items[index].photoPath ?? '',
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Skeletonizer(
                                        enabled: true,
                                        child: Container(
                                          width: 26.w,
                                          height: 26.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (_, __, ___) => Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: const BoxDecoration(
                                          color: offWhiteClr,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/images/Mask group.png',
                                          width: 26.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          horizontalSpace(10),

                          Expanded(
                            child: TextUtils(
                              maxlines: 1,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              text: items[index].name ?? '',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  TextUtils(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: '${items[index].tps ?? '0'}',
                  ),
                ],
              ),
              verticalSpace(10),
            ],
          ),
        );
      },
    );
  }
}
