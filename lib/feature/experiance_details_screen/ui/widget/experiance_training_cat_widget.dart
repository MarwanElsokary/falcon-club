import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperianceTrainingCatWidget extends StatelessWidget {
  const ExperianceTrainingCatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List catData = ['المرونة', 'القوة ', 'السرعة'];
    List catColor = [mainColor, greenClr, kCOlor5];
    return SizedBox(
      width: context.displayWidth / 1,
      height: 30.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: catData.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45.r),
                  color: catColor[index % catColor.length].withOpacity(0.18),
                ),
                child: Center(
                  child: CenterTextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: catColor[index % catColor.length],
                    text: catData[index],
                  ),
                ),
              ),
              horizontalSpace(10),
            ],
          );
        },
      ),
    );
  }
}
