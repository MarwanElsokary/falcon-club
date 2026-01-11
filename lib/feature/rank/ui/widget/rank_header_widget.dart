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
    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      isExpand = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
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
                SizedBox(
                  width: 38.w,
                  child: header(
                    icon: 'assets/svgs/stash_trophy-solid.svg',
                    title: 'رتبة'.tr(),
                  ),
                ),
                horizontalSpace(20),
                header(icon: 'assets/svgs/wpf_name.svg', title: 'الاسم'.tr()),
                Expanded(
                  child: header(
                    icon: 'assets/svgs/solar_star-bold-duotone.svg',
                    title: 'النقاط'.tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget header({required String icon, required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset(icon),
        TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: title,
        ),
      ],
    );
  }
}
