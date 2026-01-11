import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChoosePayMentMethod extends StatelessWidget {
  const ChoosePayMentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    List data = [
      'assets/svgs/Vector.svg',
      'assets/svgs/ri_visa-line.svg',
      'assets/svgs/samsung_pay.svg',
    ];
    return SizedBox(
      width: context.displayWidth / 1,
      height: 40.w,
      child: Center(
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemCount: data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Center(
              child: Row(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100.r),
                        onTap: () {
                          if (index != 1) {
                            showSuccesSnackBar(
                              context: context,
                              title: 'هذه الخدمه تحت التطوير حاليا'.tr(),
                            );
                          }
                        },
                        child: Container(
                          width: 80.w,
                          height: 40.w,
                          padding: EdgeInsets.symmetric(horizontal: 20..w),
                          decoration: BoxDecoration(
                            color: index == 1
                                ? mainColor.withOpacity(0.3)
                                : whiteclr,
                            border: Border.all(
                              color: index == 1 ? mainColor : blackclr,
                            ),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              data[index],
                              width: 35.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: index == 1,
                        child: PositionedDirectional(
                          start: 0,
                          top: 0,
                          child: SvgPicture.asset(
                            'assets/svgs/بوابة الدفع.svg',
                            width: 14.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                  horizontalSpace(10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
