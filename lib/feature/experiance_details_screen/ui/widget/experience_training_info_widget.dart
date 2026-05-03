import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cubit/experiance_details_state.dart';
import 'all_training_at_experiance_widget.dart';

class ExperienceTrainingInfoWidget extends StatelessWidget {
  const ExperienceTrainingInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperianceDetailsCubit, ExperianceDetailsState>(
      buildWhen: (previous, current) =>
          current is trialsDetailsLoading ||
          current is trialsDetailsSuccess ||
          current is trialsDetailsError,
      builder: (context, state) {
        return state.maybeWhen(
          trialsDetailssuccess: (trialsDetails) {
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
                    text: trialsDetails.data.trialTitle,
                  ),
                  verticalSpace(5),
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: blackclr,
                    text:
                        'تُعد الفئة العمرية من ${trialsDetails.data.minAge} إلى ${trialsDetails.data.maxAge} سنة، الأكثر استفادة من هذه المجموعة من التمارين',
                  ),
                  // verticalSpace(10),
                  // //training_cat
                  // ExperianceTrainingCatWidget(),
                  verticalSpace(10),

                  // allTrainingAtExperiance
                  AllTrainingAtExperianceWidget(
                    exerciseList: trialsDetails.data.exercises,
                  ),
                ],
              ),
            );
          },
          orElse: () {
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
                      text:
                          'مجموعة التمارين هذة تركز علي المهارات الاساسية لديك.',
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
          },
        );
      },
    );
  }
}
