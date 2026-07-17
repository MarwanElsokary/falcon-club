import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/block_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/text_utils.dart';

class RejectReasonWidget extends StatelessWidget {
  const RejectReasonWidget({super.key, required this.rejectedReason});
  final String rejectedReason;

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
                padding: EdgeInsetsDirectional.only(start: 5.w),
                child: BlockAnimation(
                  lottiePath: 'assets/lottie/Rejected.json',
                  width: 35.w,
                ),
              ),
              horizontalSpace(5),
              Expanded(
                child: TextUtils(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: recGreyClr,
                  text: 'تم رفض التمرين'.tr(),
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
                    text: rejectedReason,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
