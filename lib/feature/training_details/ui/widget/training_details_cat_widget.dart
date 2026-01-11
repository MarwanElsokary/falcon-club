import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainingDetailsCatWidget extends StatelessWidget {
  const TrainingDetailsCatWidget({super.key, required this.skills});
  final List skills;

  @override
  Widget build(BuildContext context) {
    List catColor = [mainColor, greenClr, kCOlor5];
    return skills.isEmpty
        ? SizedBox()
        : SizedBox(
            width: context.displayWidth / 1,
            height: 30.h,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45.r),
                        color: catColor[index % catColor.length].withOpacity(
                          0.18,
                        ),
                      ),
                      child: Center(
                        child: CenterTextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: catColor[index % catColor.length],
                          text: skills[index],
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
