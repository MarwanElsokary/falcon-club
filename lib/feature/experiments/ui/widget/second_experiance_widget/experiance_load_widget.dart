import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExperianceLoadWidget extends StatelessWidget {
  const ExperianceLoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              34.r,
            ), // Using .r for responsive border radius
            child: SizedBox(
              width: 250.w,
              height: 285.h,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
              ),
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            top: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.0), // rgba(0,0,0,0)
                    Colors.black, // #000000
                  ],
                  stops: [0.5955, 1.0], // 59.55%, 100%
                ),
              ),
              child: Container(
                padding: paddingUtils(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.0), // rgba(0, 0, 0, 0) at 0%
                      Color.fromRGBO(
                        93,
                        43,
                        244,
                        0.32,
                      ), // rgba(93, 43, 244, 0.32) at 75%
                    ],
                    stops: [0.0, 0.75],
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 20.w,
            start: 20.w,
            end: 20.w,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: '10 دقائق جري سريع',
                  ),
                  verticalSpace(10),
                  TextUtils(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: 'اللياقة البدنية',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
