import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/thems/thems.dart';
import '../../../../../core/widget/center_text_utils.dart';

class ShowAllButtonWidget extends StatelessWidget {
  const ShowAllButtonWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(66.r),
          ),
          child: Row(
            children: [
              CenterTextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                text: title,
              ),
              horizontalSpace(7),
              SvgPicture.asset('assets/svgs/arabic_forward.svg', width: 16.w),
            ],
          ),
        ),
      ],
    );
  }
}
