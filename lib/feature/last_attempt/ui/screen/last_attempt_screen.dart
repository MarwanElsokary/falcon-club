import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../training_details/data/model/exercise_details_model.dart';
import '../widget/ai_loading_widget.dart';
import '../widget/ai_score/ai_score_widget.dart';
import '../widget/ai_video_widget.dart';
import '../widget/attempt_count.dart';
import '../widget/last_attempt_app_bar_widget.dart';
import '../widget/reject_reason_widget.dart';

class LastAttemptScreen extends StatelessWidget {
  const LastAttemptScreen({super.key, required this.exerciseDetails});
  final ExerciseDetailsModel exerciseDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: lastAttemptAppBar(
        context: context,
        title: 'ملخص الآداء بالمدرب الذكي'.tr(),
      ),
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            exerciseDetails
                    .data
                    .attempts[exerciseDetails.data.attempts.length - 1]
                    .skills
                    .isNotEmpty
                ? AiScoreWidget(
                    skill: exerciseDetails
                        .data
                        .attempts[exerciseDetails.data.attempts.length - 1]
                        .skills,
                  )
                : Visibility(
                    visible:
                        exerciseDetails
                            .data
                            .attempts[exerciseDetails.data.attempts.length - 1]
                            .rejectedReason
                            .toString() ==
                        'null',
                    child: AiLoadingWidget(),
                  ),

            //Ai Video
            Container(
              width: context.displayWidth / 1,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/svgs/mingcute_ai-fill.svg'),
                      horizontalSpace(10),
                      Expanded(
                        child: TextUtils(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: mainColor,
                          text:
                              exerciseDetails
                                      .data
                                      .attempts[exerciseDetails
                                              .data
                                              .attempts
                                              .length -
                                          1]
                                      .aiVideo !=
                                  null
                              ? 'شاهد تحليل المدرب الذكي للتمرين'.tr()
                              : exerciseDetails
                                        .data
                                        .attempts[exerciseDetails
                                                .data
                                                .attempts
                                                .length -
                                            1]
                                        .rejectedReason !=
                                    null
                              ? 'تم مراجعه هذا الفيديو'.tr()
                              : 'يتم مراجعه هذا الفيديو الان'.tr(),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(15),
                  AiVideoWidget(
                    videoUrl:
                        exerciseDetails
                            .data
                            .attempts[exerciseDetails.data.attempts.length - 1]
                            .aiVideo ??
                        exerciseDetails
                            .data
                            .attempts[exerciseDetails.data.attempts.length - 1]
                            .video,
                  ),
                  verticalSpace(10),
                ],
              ),
            ),
            verticalSpace(10),

            //rejectedReason
            exerciseDetails
                        .data
                        .attempts[exerciseDetails.data.attempts.length - 1]
                        .rejectedReason !=
                    null
                ? RejectReasonWidget(
                    rejectedReason:
                        exerciseDetails
                            .data
                            .attempts[exerciseDetails.data.attempts.length - 1]
                            .rejectedReason ??
                        '',
                  )
                : AttemptCount(
                    attemCount: '${exerciseDetails.data.attemptsCount ?? '0'}',
                  ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
