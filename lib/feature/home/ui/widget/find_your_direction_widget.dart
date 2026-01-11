import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/experiments/cubit/experiments_state.dart';
import 'package:falcon/feature/experiments/ui/widget/first_experinance/carousel_slider_widget.dart';
import 'package:falcon/feature/experiments/ui/widget/first_experinance/load_carousal_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/widget/center_text_utils.dart';
import '../../../experiments/cubit/experiments_cubit.dart';

class FindYourDirectionWidget extends StatelessWidget {
  const FindYourDirectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteclr,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //
            Padding(
              padding: paddingUtils(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/solar_notes-broken.svg',
                    width: 26.w,
                  ),
                  horizontalSpace(10),
                  Expanded(
                    child: TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: 'أهم تجارب الأنديةالرياضية'.tr(),
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(10),
            //slider
            BlocBuilder<ExperimentsCubit, ExperimentsState>(
              buildWhen: (previous, current) =>
                  current is bestTrialsLoading ||
                  current is bestTrialsSuccess ||
                  current is bestTrialsError,
              builder: (context, state) {
                return state.maybeWhen(
                  bestTrialssuccess: (allTrialsdata) {
                    return CarouselSliderWidget(
                      heroPage: 'home',
                      height: 400,
                      padding: 20,
                    );
                  },
                  orElse: () {
                    return LoadCarousalSliderWidget(height: 400, padding: 20);
                  },
                );
              },
            ),
            verticalSpace(10),
            Padding(
              padding: paddingUtils(),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100.r),
                    onTap: () {
                      context.pushNamed(AppRoute.allExperimentScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(66.r),
                      ),
                      child: Row(
                        children: [
                          CenterTextUtils(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            text: 'عرض التجارب'.tr(),
                          ),
                          horizontalSpace(7),
                          SvgPicture.asset(
                            'assets/svgs/arabic_forward.svg',
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
    );
  }
}
