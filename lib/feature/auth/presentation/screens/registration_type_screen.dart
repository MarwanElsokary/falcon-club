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
              text: 'ما نوع حسابك؟'.tr(),
            ),
            verticalSpace(10),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: blackclr,
              text: 'اختر نوع الحساب للمتابعة'.tr(),
            ),
            verticalSpace(40),

            // ── نادي ────────────────────────────────────────────────────
            _buildOptionCard(
              context: context,
              icon: Icons.sports_soccer,
              title: 'نادي'.tr(),
              subtitle: 'سجل كمدرب في نادي لاستكشاف اللاعبين وإدارة الفريق'.tr(),
              isEnabled: true,
              onTap: () => context.pushNamed(AppRoute.clubSignUpScreen),
            ),
            verticalSpace(20),

            // ── كشاف ────────────────────────────────────────────────────
            _buildOptionCard(
              context: context,
              icon: Icons.search_rounded,
              title: 'كشاف'.tr(),
              subtitle: 'اكتشف المواهب وتابع أداء اللاعبين والريلز'.tr(),
              isEnabled: true,
              onTap: () => context.pushNamed(AppRoute.scoutSignUpScreen),
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
                color: mainColor.withOpacity(0.08),
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
                    ? mainColor.withOpacity(0.12)
                    : greyClr.withOpacity(0.12),
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
                  TextUtils(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isEnabled ? Colors.black : greyClr,
                    text: title,
                  ),
                  verticalSpace(4),
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isEnabled ? blackclr : greyClr,
                    text: subtitle,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isEnabled ? mainColor : greyClr.withOpacity(0.4),
              size: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}