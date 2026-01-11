import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/thems/thems.dart';
import '../../../../../core/widget/center_text_utils.dart';
import '../../../../rank/cubit/rank_cubit.dart';

class TopThreeRateWidget extends StatelessWidget {
  const TopThreeRateWidget({super.key, required this.isReverse});
  final bool isReverse;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isReverse
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,

      children: [
        //2
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              Column(
                children: [
                  verticalSpace(12),
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoute.playerProfile,
                        arguments: {
                          'isMyProfile': true,
                          'playerId':
                              '${context.read<RankCubit>().rankList[1].id}',
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF4F7FF), // #F4F7FF
                            Color(0xFFCBD5EC), // #CBD5EC
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r), // optional
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.w,
                          ),

                          child: Column(
                            children: [
                              SizedBox(
                                width: 90.w,
                                height: 75.h,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(14.r),
                                  child: CachedNetworkImage(
                                    width: 90.w,
                                    height: 75.h,
                                    imageUrl:
                                        context
                                                .read<RankCubit>()
                                                .rankList
                                                .length >
                                            2
                                        ? context
                                                  .read<RankCubit>()
                                                  .rankList[1]
                                                  .photoPath ??
                                              ''
                                        : '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Skeletonizer(
                                      enabled: true,
                                      child: Container(
                                        width: 90.w,
                                        height: 75.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ), // Match the border radius
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/unavailabeImage.svg',
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              verticalSpace(10),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text:
                                    context.read<RankCubit>().rankList.length >
                                        2
                                    ? context
                                              .read<RankCubit>()
                                              .rankList[1]
                                              .name ??
                                          ''
                                    : '',
                              ),
                              verticalSpace(2),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: blackclr,
                                text:
                                    '${context.read<RankCubit>().rankList.length > 2 ? context.read<RankCubit>().rankList[1].tps ?? '' : ''} XP',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                top: 0,
                start: -5,
                child: SvgPicture.asset(
                  width: 55.w,
                  'assets/svgs/second_level.svg',
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(10),
        //1
        Expanded(
          flex: 7,
          child: Stack(
            children: [
              Column(
                children: [
                  verticalSpace(12),
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoute.playerProfile,
                        arguments: {
                          'isMyProfile': true,
                          'playerId':
                              '${context.read<RankCubit>().rankList[0].id}',
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF4F7FF), // #F4F7FF
                            Color(0xFFCBD5EC), // #CBD5EC
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.r), // optional
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 15.w,
                          ),

                          child: Column(
                            children: [
                              SizedBox(
                                width: 90.w,
                                height: 100.h,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(16.r),
                                  child: CachedNetworkImage(
                                    width: 90.w,
                                    height: 100.h,
                                    imageUrl:
                                        context
                                                .read<RankCubit>()
                                                .rankList
                                                .length >
                                            1
                                        ? context
                                                  .read<RankCubit>()
                                                  .rankList[0]
                                                  .photoPath ??
                                              ''
                                        : '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Skeletonizer(
                                      enabled: true,
                                      child: Container(
                                        width: 90.w,
                                        height: 100.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ), // Match the border radius
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/unavailabeImage.svg',
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              verticalSpace(10),
                              CenterTextUtils(
                                fontSize: 16,
                                maxlines: 1,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text:
                                    context.read<RankCubit>().rankList.length >
                                        1
                                    ? context
                                              .read<RankCubit>()
                                              .rankList[0]
                                              .name ??
                                          ''
                                    : '',
                              ),
                              verticalSpace(2),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: blackclr,
                                text:
                                    '${context.read<RankCubit>().rankList.length > 1 ? context.read<RankCubit>().rankList[0].tps ?? '' : ''} XP',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                top: 0,
                start: -5,
                child: SvgPicture.asset(
                  width: 55.w,
                  'assets/svgs/iconamoon_certificate-badge-fill.svg',
                ),
              ),
            ],
          ),
        ),
        horizontalSpace(10),
        //3
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              Column(
                children: [
                  verticalSpace(12),
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        AppRoute.playerProfile,
                        arguments: {
                          'isMyProfile': true,
                          'playerId':
                              '${context.read<RankCubit>().rankList[2].id}',
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF4F7FF), // #F4F7FF
                            Color(0xFFCBD5EC), // #CBD5EC
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r), // optional
                      ),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.w,
                          ),

                          child: Column(
                            children: [
                              SizedBox(
                                width: 90.w,
                                height: 75.h,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(14.r),
                                  child: CachedNetworkImage(
                                    width: 90.w,
                                    height: 75.h,
                                    imageUrl:
                                        context
                                                .read<RankCubit>()
                                                .rankList
                                                .length >
                                            3
                                        ? context
                                                  .read<RankCubit>()
                                                  .rankList[2]
                                                  .photoPath ??
                                              ''
                                        : '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Skeletonizer(
                                      enabled: true,
                                      child: Container(
                                        width: 90.w,
                                        height: 75.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ), // Match the border radius
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: SvgPicture.asset(
                                            'assets/svgs/unavailabeImage.svg',
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              verticalSpace(10),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text:
                                    context.read<RankCubit>().rankList.length >
                                        3
                                    ? context
                                              .read<RankCubit>()
                                              .rankList[2]
                                              .name ??
                                          ''
                                    : '',
                              ),
                              verticalSpace(2),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: blackclr,
                                text:
                                    '${context.read<RankCubit>().rankList.length > 3 ? context.read<RankCubit>().rankList[2].tps ?? '' : ''} XP',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                top: 0,
                start: -5,
                child: SvgPicture.asset(
                  width: 55.w,
                  'assets/svgs/third_level.svg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
