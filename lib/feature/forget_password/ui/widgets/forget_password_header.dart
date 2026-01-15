import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/thems/thems.dart';

class ForgetPasswordHeader extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const ForgetPasswordHeader({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.h),
        Image.asset(
          imagePath,
          height: 180.h,
          cacheWidth: (180 * MediaQuery.of(context).devicePixelRatio).round(),
          cacheHeight: (180 * MediaQuery.of(context).devicePixelRatio).round(),
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 180.h,
            color: Colors.grey[200],
            child: Icon(Icons.lock_reset, size: 60.w, color: mainColor),
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            title.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: mainColor.withAlpha(150),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
