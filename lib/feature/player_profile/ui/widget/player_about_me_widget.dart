import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../main_screen/data/model/my_profile_model.dart';

class PlayerAboutMeWidget extends StatelessWidget {
  const PlayerAboutMeWidget({super.key, required this.playerProfile});
  final MyProfileModel playerProfile;

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
                text: '${'عن'.tr()} ${playerProfile.data.firstName ?? ''}',
              ),
              verticalSpace(5),
              TextUtils(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: blackclr,
                text:
                    'الاعب ${playerProfile.data.firstName ?? ''} ${playerProfile.data.lastName ?? ''} هو لاعب محترف يلعب في مركز ${playerProfile.data.positionName ?? ''} و يتميز ب طول ${playerProfile.data.height ?? ''} سم و وزن ${playerProfile.data.weight ?? ''} كجم. يمتلك مهارات فنية عالية و رؤية ممتازة للملعب تجعله لاعباً لا غنى عنه في فريقه.'
                        .tr(),
              ),
            ],
          ),
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: SvgPicture.asset('assets/svgs/Group 385.svg'),
        ),
      ],
    );
  }
}
