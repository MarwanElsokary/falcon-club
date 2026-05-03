import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
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
    final rankList = context.read<RankCubit>().rankList;

    // ✅ دالة مساعدة لبناء صورة اللاعب
    Widget _buildPlayerImage(String? photoPath, double width, double height) {
      if (photoPath == null || photoPath.isEmpty) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
        );
      }

      return CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: photoPath,
        fit: BoxFit.cover,
        placeholder: (context, url) => Skeletonizer(
          enabled: true,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Padding(
          padding: EdgeInsets.all(20.w),
          child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
        ),
      );
    }

    return Row(
      crossAxisAlignment: isReverse
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // اللاعب الثاني (المركز الثاني)
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              Column(
                children: [
                  verticalSpace(12),
                  InkWell(
                    onTap: () {
                      if (rankList.length > 1) {
                        context.pushNamed(
                          AppRoute.playerProfile,
                          arguments: {
                            'isMyProfile': true,
                            'playerId': '${rankList[1].id}',
                            'showFavoriteButton': true, // ← المدرب والكشاف بس

                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF4F7FF),
                            Color(0xFFCBD5EC),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
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
                                  child: rankList.length > 1
                                      ? _buildPlayerImage(
                                      rankList[1].photoPath, 90.w, 75.h)
                                      : Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: SvgPicture.asset(
                                        'assets/svgs/unavailabeImage.svg'),
                                  ),
                                ),
                              ),
                              verticalSpace(10),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text: rankList.length > 1
                                    ? rankList[1].name ?? ''
                                    : '',
                              ),
                              verticalSpace(2),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: blackclr,
                                text: rankList.length > 1
                                    ? '${rankList[1].tps ?? ''} XP'
                                    : '',
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
        // اللاعب الأول (المركز الأول)
        Expanded(
          flex: 7,
          child: Stack(
            children: [
              Column(
                children: [
                  verticalSpace(12),
                  InkWell(
                    onTap: () {
                      if (rankList.isNotEmpty) {
                        context.pushNamed(
                          AppRoute.playerProfile,
                          arguments: {
                            'isMyProfile': true,
                            'playerId': '${rankList[0].id}',
                            'showFavoriteButton': true, // ← المدرب والكشاف بس

                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF4F7FF),
                            Color(0xFFCBD5EC),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.r),
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
                                  child: rankList.isNotEmpty
                                      ? _buildPlayerImage(
                                      rankList[0].photoPath, 90.w, 100.h)
                                      : Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: SvgPicture.asset(
                                        'assets/svgs/unavailabeImage.svg'),
                                  ),
                                ),
                              ),
                              verticalSpace(10),
                              CenterTextUtils(
                                fontSize: 16,
                                maxlines: 1,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text: rankList.isNotEmpty
                                    ? rankList[0].name ?? ''
                                    : '',
                              ),
                              verticalSpace(2),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: blackclr,
                                text: rankList.isNotEmpty
                                    ? '${rankList[0].tps ?? ''} XP'
                                    : '',
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
        // اللاعب الثالث (المركز الثالث)
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              Column(
                children: [
                  verticalSpace(12),
                  InkWell(
                    onTap: () {
                      if (rankList.length > 2) {
                        context.pushNamed(
                          AppRoute.playerProfile,
                          arguments: {
                            'isMyProfile': true,
                            'playerId': '${rankList[2].id}',
                            'showFavoriteButton': true, // ← المدرب والكشاف بس

                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF4F7FF),
                            Color(0xFFCBD5EC),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
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
                                  child: rankList.length > 2
                                      ? _buildPlayerImage(
                                      rankList[2].photoPath, 90.w, 75.h)
                                      : Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: SvgPicture.asset(
                                        'assets/svgs/unavailabeImage.svg'),
                                  ),
                                ),
                              ),
                              verticalSpace(10),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text: rankList.length > 2
                                    ? rankList[2].name ?? ''
                                    : '',
                              ),
                              verticalSpace(2),
                              CenterTextUtils(
                                maxlines: 1,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: blackclr,
                                text: rankList.length > 2
                                    ? '${rankList[2].tps ?? ''} XP'
                                    : '',
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