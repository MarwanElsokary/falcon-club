import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/spacing.dart';
import '../thems/thems.dart';
import 'text_utils.dart';

PreferredSizeWidget profileAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: mainColor,
    leading: const Text(''),
    actions: [
      horizontalSpace(20),
      //icon
      SvgPicture.asset(
        'assets/svgs/Vector-2.svg',
        height: 25.w,
        fit: BoxFit.cover,
      ),
      horizontalSpace(10),
      //search
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 37.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              //logo
              SvgPicture.asset('assets/svgs/Heart Angle.svg'),
              horizontalSpace(7),
              TextUtils(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: greyClr,
                  text: 'search'.tr()),
            ],
          ),
        ),
      ),
      horizontalSpace(10),

      InkWell(
          onTap: () {
            // showLogoutDialog(context, context.read<MainCubit>());
          },
          child:
              const Icon(Icons.logout_rounded, color: Colors.white, size: 24)),
      horizontalSpace(20),
    ],
  );
}
