import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/model/exercise_details_model.dart';

class AttempsWidget extends StatelessWidget {
  const AttempsWidget({super.key, required this.exerciseDetails});
  final ExerciseDetailsModel exerciseDetails;

  @override
  Widget build(BuildContext context) {
    return exerciseDetails.data.attempts.isEmpty
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/pajamas_retry.svg'),
                horizontalSpace(10),
                Expanded(
                  child: TextUtils(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text:
                        'متبقي'
                        ' ${exerciseDetails.data.attemptsCount ?? ''} '
                        'من المحاولات',
                  ),
                ),
                //Last attempt last_attempt_screen.dart
                InkWell(
                  onTap: () {
                    //
                    context.pushNamed(
                      AppRoute.lastAttemptScreen,
                      arguments: {'exerciseDetails': exerciseDetails},
                    );
                  },
                  child: Row(
                    children: [
                      TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            exerciseDetails
                                    .data
                                    .attempts[exerciseDetails
                                            .data
                                            .attempts
                                            .length -
                                        1]
                                    .rejectedReason !=
                                null
                            ? recGreyClr
                            : mainColor,
                        text: 'المحاولة الأخيرة'.tr(),
                      ),
                      horizontalSpace(5),
                      Column(
                        children: [
                          verticalSpace(3),
                          SvgPicture.asset(
                            'assets/svgs/arabic_forward.svg',
                            width: 12.w,
                            color:
                                exerciseDetails
                                        .data
                                        .attempts[exerciseDetails
                                                .data
                                                .attempts
                                                .length -
                                            1]
                                        .rejectedReason !=
                                    null
                                ? recGreyClr
                                : mainColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
