import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/padding_utils.dart';

class UploadProgressWidget extends StatelessWidget {
  final int? progress;

  const UploadProgressWidget({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingUtils(),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Animation
            Lottie.asset(
              'assets/lottie/load.json',
              width: 150.w,
              height: 150.h,
            ),

            verticalSpace(20),

            // Progress text
            Text(
              progress != null
                  ? 'جاري رفع الصورة... $progress%'
                  : 'جاري تحليل الصورة بالذكاء الاصطناعي...',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: mainColor,
              ),
              textAlign: TextAlign.center,
            ),

            verticalSpace(16),

            // Progress bar
            if (progress != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress! / 100,
                      minHeight: 10.h,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                  ),
                  verticalSpace(8),
                  Text(
                    '$progress%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              )
            else
              CircularProgressIndicator(color: mainColor),

            verticalSpace(16),

            Text(
              'يرجى الانتظار، هذا قد يستغرق بضع ثوانٍ...',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}