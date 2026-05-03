import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/feature/training_details/cubit/training_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import '../../../last_attempt/ui/widget/ai_loading_widget.dart';
import '../../cubit/training_details_cubit.dart';

class VidoeUploadLoad extends StatelessWidget {
  const VidoeUploadLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingDetailsCubit, TrainingDetailsState>(
      builder: (context, state) {
        if (state is addAttemptProgress || state is addAttemptLoading) {
          int percent = 0;
          if (state is addAttemptProgress) {
            percent = state.progress.clamp(0, 100);
          }

          return Container(
            color: offWhiteClr.withOpacity(0.3),

            child: Center(
              child: Container(
                width: context.displayWidth / 1.2,
                height: context.displayHeight / 2,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      height: 250.w,
                      width: 250.w,
                      margin: EdgeInsets.symmetric(vertical: 25.w),
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                        color: offWhiteClr.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: offWhiteClr.withOpacity(0.2),
                          width: 5.w,
                        ),
                      ),
                      child: CustomPaint(
                        painter: GradientCirclePainter(
                          percent: percent / 100, // 0.0 -> 1.0
                          strokeWidth: 15.w,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: offWhiteClr.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: offWhiteClr.withOpacity(0.2),
                                width: 5.w,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: mainColor,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CenterTextUtils(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    text: '$percent%',
                                  ),
                                  const SizedBox(height: 5),
                                  CenterTextUtils(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: percent >= 70
                                        ? greenClr
                                        : Colors.white,
                                    text: percent >= 70
                                        ? 'باقي شوي ويخلص...'.tr()
                                        : 'الحين ننزله لك...'.tr(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
