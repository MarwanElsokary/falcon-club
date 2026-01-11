import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/thems/thems.dart';

class ShareIconButton extends StatelessWidget {
  const ShareIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ClipOval(
        // بدل ClipRRect
        child: Container(
          width: 45.w,
          height: 45.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.2),
            shape: BoxShape.circle, // ده كمان مهم للدائرة
          ),
          child: SvgPicture.asset('assets/svgs/share_reals.svg'),
        ),
      ),
    );
  }
}
