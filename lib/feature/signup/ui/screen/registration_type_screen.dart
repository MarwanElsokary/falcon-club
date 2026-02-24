import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/app_bar_utils.dart';
import '../../../../core/widget/padding_utils.dart';
import '../../../../core/widget/text_utils.dart';

class RegistrationTypeScreen extends StatelessWidget {
  const RegistrationTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: ''),
      body: Padding(
        padding: paddingUtils(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextUtils(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'هل أنت مدرب في نادي أم كشاف؟'.tr(),
            ),
            verticalSpace(10),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: blackclr,
              text: 'اختر نوع الحساب للمتابعة'.tr(),
            ),
            verticalSpace(40),
            _buildOptionCard(
              context: context,
              icon: Icons.sports_soccer,
              title: 'نادي'.tr(),
              subtitle: 'سجل كمدرب في نادي لاستكشاف اللاعبين'.tr(),
              isEnabled: true,
              onTap: () {
                context.pushNamed(AppRoute.clubSignUpScreen);
              },
            ),
            verticalSpace(20),
            _buildOptionCard(
              context: context,
              icon: Icons.search,
              title: 'كشاف'.tr(),
              subtitle: 'لم تضاف بعد، سيتم الإضافة قريباً'.tr(),
              isEnabled: false,
              onTap: () {
                _showComingSoonDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: isEnabled ? fillColor : fillColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isEnabled
                ? mainColor.withOpacity(0.3)
                : greyClr.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            if (isEnabled)
              BoxShadow(
                color: mainColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isEnabled
                    ? mainColor.withOpacity(0.15)
                    : greyClr.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isEnabled ? mainColor : greyClr,
                size: 28.w,
              ),
            ),
            horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextUtils(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isEnabled ? Colors.black : greyClr,
                        text: title,
                      ),
                      if (!isEnabled) ...[
                        horizontalSpace(8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: TextUtils(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                            text: 'قريباً'.tr(),
                          ),
                        ),
                      ],
                    ],
                  ),
                  verticalSpace(4),
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isEnabled ? blackclr : greyClr,
                    text: subtitle,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isEnabled ? mainColor : greyClr.withOpacity(0.5),
              size: 18.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: TextUtils(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: mainColor,
          text: 'كشاف'.tr(),
        ),
        content: TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          text: 'لم تضاف بعد، سيتم الإضافة قريباً'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: mainColor,
              text: 'حسناً'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
