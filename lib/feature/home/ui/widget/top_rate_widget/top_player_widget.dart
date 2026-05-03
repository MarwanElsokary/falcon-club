import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_cubit.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_state.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/widget/text_utils.dart';
import 'reverse_widgt.dart';

class TopPlayerWidget extends StatelessWidget {
  const TopPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RankCubit, RankState>(
      buildWhen: (previous, current) =>
          current is rankLoading ||
          current is rankSuccess ||
          current is realsError,
      builder: (context, state) {
        if (state is rankLoading ||
            context.read<RankCubit>().rankList.isEmpty) {
          return SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/solar_ranking-bold-duotone.svg',
                    width: 26.w,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      text: 'شاهد ترتيب اللاعبين '.tr(),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Stack(
                children: [
                  ReverseWidgt(),
                  PositionedDirectional(
                    bottom: 50.h,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context.pushNamed(
                              AppRoute.rankScreen,
                              arguments: {'context': context},
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: whiteclr,
                              borderRadius: BorderRadius.circular(66.r),
                            ),
                            child: Row(
                              children: [
                                CenterTextUtils(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: mainColor,
                                  text: 'عرض الترتيب'.tr(),
                                ),
                                horizontalSpace(7),
                                SvgPicture.asset(
                                  'assets/svgs/arabic_forward.svg',
                                  // ignore: deprecated_member_use
                                  color: mainColor,
                                  width: 16.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
