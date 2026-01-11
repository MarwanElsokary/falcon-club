import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'talent_slider_widget.dart';

class JoinTalentWidget extends StatelessWidget {
  const JoinTalentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.displayWidth / 1,

      decoration: BoxDecoration(
        color: whiteclr,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          //
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //
                SvgPicture.asset(
                  'assets/svgs/Training_un_select.svg',
                  // ignore: deprecated_member_use
                  color: Colors.black,
                  width: 26.w,
                ),
                horizontalSpace(10),
                Expanded(
                  child: TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    text: 'شارك في التدريبات وخلينا نشوف موهبتك'.tr(),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(10),
          TalentSliderWidget(),
        ],
      ),
    );
  }
}
