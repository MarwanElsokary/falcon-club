import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../exercise/domain/entities/trial.dart';
import '../../cubit/trial_details_cubit.dart';
import '../../cubit/trial_details_state.dart';
import 'trial_exercises_widget.dart';

class TrialInfoWidget extends StatelessWidget {
  const TrialInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrialDetailsCubit, TrialDetailsState>(
      builder: (context, state) {
        return switch (state) {
          TrialDetailsLoaded(:final Trial trial) => _loaded(context, trial),
          // The failure case keeps the same skeleton the old screen showed for
          // anything-but-success — the trials list already handles the empty
          // case, and reaching a broken single trial is rare enough that a
          // shimmer beats a hard error block here.
          _ => _skeleton(context),
        };
      },
    );
  }

  Widget _loaded(BuildContext context, Trial trial) {
    return Container(
      width: context.displayWidth / 1,
      padding: paddingUtils(),
      decoration: BoxDecoration(
        color: whiteclr,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(10.r),
          topStart: Radius.circular(10.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUtils(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: trial.title,
          ),
          // The age-range sentence is shown only when both ends are known.
          // Interpolating raw min/max used to render "من null إلى null سنة".
          if (trial.hasAgeRange) ...[
            verticalSpace(5),
            TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: blackclr,
              text:
                  'تُعد الفئة العمرية من ${trial.minAge} إلى ${trial.maxAge} سنة، الأكثر استفادة من هذه المجموعة من التمارين',
            ),
          ],
          verticalSpace(10),
          TrialExercisesWidget(exercises: trial.exercises),
        ],
      ),
    );
  }

  Widget _skeleton(BuildContext context) {
    return Container(
      width: context.displayWidth / 1,
      height: context.displayHeight / 2,
      padding: paddingUtils(),
      decoration: BoxDecoration(
        color: whiteclr,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(10.r),
          topStart: Radius.circular(10.r),
        ),
      ),
      child: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'مجموعة التمارين هذة تركز علي المهارات الاساسية لديك.',
            ),
            verticalSpace(5),
            TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: blackclr,
              text:
                  'تعتبر هذه المجموعة من التمارين وسيلة فعالة لتعزيز المهارات الأساسية لديك. من خلال التركيز على الجوانب الأساسية، يمكنك تحسين أدائك بشكل ملحوظ. كما أن ممارسة هذه التمارين بانتظام ستساعدك على بناء الثقة في قدراتك. لا تتردد في تخصيص وقت يومي لممارستها لتحقيق أفضل النتائج.',
            ),
            verticalSpace(10),
          ],
        ),
      ),
    );
  }
}
