import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falcon/feature/experiments/cubit/experiments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../home/ui/widget/join_talent_widget/show_all_button_widget.dart';
import 'carousel_slider_widget.dart';
import 'load_carousal_slider_widget.dart';

class FirstExperianceWidget extends StatelessWidget {
  const FirstExperianceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtils(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'أثبت مهارتك وارتقِ في الترتيب.'.tr(),
              ),
              verticalSpace(10),
              TextUtils(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: blackclr,
                text:
                    'انضم إلى التجارب المدعومة بالذكاء الاصطناعي واكتشف كيف تقارن أداءك مع لاعبين من جميع أنحاء العالم.'
                        .tr(),
              ),
            ],
          ),
        ),
        verticalSpace(15),
        BlocBuilder<ExperimentsCubit, ExperimentsState>(
          buildWhen: (previous, current) =>
              current is bestTrialsLoading ||
              current is bestTrialsSuccess ||
              current is bestTrialsError,
          builder: (context, state) {
            return state.maybeWhen(
              bestTrialssuccess: (allTrialsdata) {
                return CarouselSliderWidget(
                  heroPage: 'experiance',
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

        verticalSpace(15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: InkWell(
            onTap: () {
              context.pushNamed(AppRoute.allExperimentScreen);
            },
            child: ShowAllButtonWidget(title: 'عرض الكل'.tr()),
          ),
        ),
      ],
    );
  }
}
