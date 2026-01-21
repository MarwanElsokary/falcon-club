import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RankHeaderWidget extends StatefulWidget {
  const RankHeaderWidget({super.key});

  @override
  State<RankHeaderWidget> createState() => _RankHeaderWidgetState();
}

class _RankHeaderWidgetState extends State<RankHeaderWidget> {
  bool isExpand = false;

  @override
  void initState() {
    wait();
    super.initState();
  }

  wait() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      isExpand = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      height: isExpand ? 60.h : 0,
      width: context.displayWidth / 1,
      decoration: BoxDecoration(
        color: mainColor,
        border: Border(
          bottom: BorderSide(color: offWhiteClr, width: 0.2.w),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                // الرتبة
                Container(
                  width: 50.w, // ✅ زيادة العرض قليلاً
                  child: header(
                    icon: 'assets/svgs/stash_trophy-solid.svg',
                    title: 'رتبة'.tr(),
                  ),
                ),
                horizontalSpace(15.w), // ✅ تقليل المسافة

                // الاسم
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: header(
                      icon: 'assets/svgs/wpf_name.svg',
                      title: 'الاسم'.tr(),
                      alignRight: true, // ✅ محاذاة للبداية
                    ),
                  ),
                ),

                // النقاط
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: header(
                      icon: 'assets/svgs/solar_star-bold-duotone.svg',
                      title: 'النقاط'.tr(),
                      alignCenter: true, // ✅ محاذاة للوسط
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget header({
    required String icon,
    required String title,
    bool alignRight = false,
    bool alignCenter = false,
  }) {
    return Row(
      mainAxisAlignment: alignCenter
          ? MainAxisAlignment.center
          : (alignRight ? MainAxisAlignment.start : MainAxisAlignment.end),
      mainAxisSize: MainAxisSize.min, // ✅ تغيير إلى min لتجنب التجاوز
      children: [
        SizedBox(
          width: 16.w, // ✅ تحديد عرض ثابت للأيقونة
          child: SvgPicture.asset(icon),
        ),
        horizontalSpace(4.w), // ✅ تقليل المسافة
        Flexible( // ✅ استخدام Flexible بدلاً من Expanded
          child: TextUtils(
            fontSize: 12.sp, // ✅ تقليل حجم الخط قليلاً
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: title,
            maxlines: 1,
          ),
        ),
      ],
    );
  }
}