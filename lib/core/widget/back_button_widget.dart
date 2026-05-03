import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100.r),
      onTap: () {
        context.pop();
      },
      child: Container(
        width: 38.w,
        height: 38.w,

        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: EasyLocalization.of(context)!.locale.toString() == 'en'
            ? Center(
                child: SvgPicture.asset(
                  'assets/svgs/english-arrow-right-small.svg',
                  width: 18.w,
                ),
              )
            : Center(
                child: SvgPicture.asset(
                  'assets/svgs/arabic_arrow.svg',
                  width: 18.w,
                ),
              ),
      ),
    );
  }
}
