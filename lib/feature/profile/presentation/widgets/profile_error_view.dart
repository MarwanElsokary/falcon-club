import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The shared error state for both self-profile screens.
///
/// The Coach and MainClub screens had a near-verbatim `_buildError` (~35 lines);
/// they differed only in the leading [icon] (`Icons.error` vs
/// `Icons.error_outline`), so that is the one parameter.
class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({
    super.key,
    required this.message,
    required this.icon,
    required this.onRetry,
  });

  final String message;
  final IconData icon;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red, size: 60.w),
            verticalSpace(20),
            TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              text: 'حدث خطأ'.tr(),
            ),
            verticalSpace(10),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              text: message,
            ),
            verticalSpace(20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              child: Text(
                'إعادة المحاولة'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
