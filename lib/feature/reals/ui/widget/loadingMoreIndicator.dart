import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ⏳ Loading More Indicator
/// مؤشر تحميل المزيد من الفيديوهات
class LoadingMoreIndicator extends StatelessWidget {
  const LoadingMoreIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 200.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 8.w),
              TextUtils(
                text: 'جاري التحميل...',
                fontSize: 12,
                color: Colors.white, fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}