import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'player_all_videos_item_widget.dart';

class PlayerVideosWidget extends StatelessWidget {
  const PlayerVideosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.displayWidth / 1,
          padding: paddingUtils(),
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtils(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'اللقطات',
              ),
              verticalSpace(10),
              PlayerAllVideosItemWidget(),
            ],
          ),
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: SvgPicture.asset('assets/svgs/Group 385.svg'),
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: SvgPicture.asset('assets/svgs/Group 386-2.svg', width: 120.w),
        ),
      ],
    );
  }
}
