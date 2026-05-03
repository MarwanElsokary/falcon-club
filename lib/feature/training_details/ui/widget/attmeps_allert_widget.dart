import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/block_animation.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/training_details/data/model/exercise_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AttmepsAllertWidget extends StatelessWidget {
  const AttmepsAllertWidget({
    super.key,
    required this.exerciseDetails,
    required this.onPressed,
  });
  final ExerciseDetailsModel exerciseDetails;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    List catColor = [mainColor, Color(0xFF0C4F45), kCOlor5];

    return Stack(
      children: [
        SizedBox(
          height: context.displayHeight / 2,
          width: context.displayWidth / 1,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(5),
                Container(
                  width: 80.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: greyClr.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                Container(
                  height: (context.displayHeight / 2.5),
                  width: context.displayWidth / 1,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 0.w,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        verticalSpace(
                          exerciseDetails.data.attemptsCount == 1 ? 10 : 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            exerciseDetails.data.attemptsCount == 1
                                ? BlockAnimation(
                                    lottiePath:
                                        'assets/lottie/Alert Icon Exclamation.json',
                                    width: 40.w,
                                  )
                                : SvgPicture.asset(
                                    'assets/svgs/pajamas_retry.svg',
                                    width: 18.w,
                                  ),
                            horizontalSpace(
                              exerciseDetails.data.attemptsCount == 1 ? 0 : 10,
                            ),
                            TextUtils(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              text:
                                  'متبقي'
                                  ' ${exerciseDetails.data.attemptsCount ?? ''} '
                                  'من المحاولات',
                            ),

                            //Last attempt last_attempt_screen.dart
                          ],
                        ),
                        verticalSpace(15),
                        TextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          text: 'قبل ان تبدا التصوير تاكد من التالي:'.tr(),
                        ),
                        verticalSpace(15),
                        ListView.builder(
                          itemCount:
                              exerciseDetails.data.playerInstructions.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, i) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                catColor[i % catColor.length],
                                            blurRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        color: catColor[i % catColor.length],
                                      ),

                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 12.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                    horizontalSpace(5),
                                    Expanded(
                                      child: TextUtils(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        text: exerciseDetails
                                            .data
                                            .playerInstructions[i],
                                      ),
                                    ),
                                  ],
                                ),
                                verticalSpace(7),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ButtonUtils(
                    text: 'فهمت التعليمات',
                    onPressed: onPressed,
                    colorstext: Colors.white,
                    background: mainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
