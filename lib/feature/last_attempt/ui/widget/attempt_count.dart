import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/text_utils.dart';

class AttemptCount extends StatelessWidget {
  const AttemptCount({super.key, required this.attemCount});
  final String attemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.displayWidth / 1,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 15.w),
                child: SvgPicture.asset(
                  'assets/svgs/pajamas_retry.svg',
                  width: 18.w,
                  color: mainColor,
                ),
              ),
              horizontalSpace(8),
              Expanded(
                child: TextUtils(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: mainColor,
                  text: 'عدد المحولات المتبقيه'.tr(),
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 20.w),
            child: Row(
              children: [
                Container(
                  height: 5.w,
                  width: 5.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
                horizontalSpace(5),
                Expanded(
                  child: TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    text:
                        '${'متبقي'.tr()} $attemCount ${'من المحاولات يمكنك الاستفاده منها'.tr()}',
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(5),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20.w),
          //   child: ButtonUtils(
          //     text: 'العوده',
          //     border: 30.r,
          //     borderColor: Colors.transparent,
          //     onPressed: () {
          //       context.pop();
          //     },
          //     colorstext: Colors.white,
          //     background: mainColor,
          //   ),
          // ),
        ],
      ),
    );
  }
}
