import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UploadTrainingWidget extends StatelessWidget {
  const UploadTrainingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.displayWidth,
          height: 80.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // أعلى الـ Container
              end: Alignment.bottomCenter, // أسفل الـ Container
              colors: [
                Color(0xFFEFF4FF), // اللون الأعلى (#EFF4FF)
                Color(0xFF5D2BF4), // اللون الأسفل (#5D2BF4)
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
        ),
        PositionedDirectional(
          end: 0,
          child: SvgPicture.asset('assets/svgs/app_bar_icon.svg'),
        ),
        PositionedDirectional(
          child: Column(
            children: [
              verticalSpace(20),
              //ارفع تدريباتك الآن  و اظهر مهاراتك
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/hugeicons_video-01.svg',
                      width: 26.w,
                    ),
                    horizontalSpace(10),
                    Expanded(
                      child: TextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: 'ابدأ الان و تصدر بين اللاعبين الآخرين'.tr(),
                      ),
                    ),
                  ],
                ),
              ),
              // verticalSpace(20),
              // UploadTrainingSliderWidet(),
              verticalSpace(20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: 'ابدأ نشر الآن'.tr(),
                        ),
                      ),
                    ),
                    horizontalSpace(110),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: 'و ارينا مهاراتك'.tr(),
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
  }
}
