import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../main_screen/data/model/my_profile_model.dart';

class PlayerExperianceWidget extends StatelessWidget {
  const PlayerExperianceWidget({super.key, required this.playerProfile});
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
                text: 'خبرة اللاعب',
              ),
              verticalSpace(15),
              Container(
                padding: paddingUtils(),
                width: context.displayWidth / 1,
                decoration: BoxDecoration(
                  border: Border.all(color: mainColor),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Column(
                  children: [
                    //
                    ClipOval(
                      child: Container(
                        color: offWhiteClr,
                        padding: EdgeInsets.all(20.w),
                        child: Image.network(
                          '${playerProfile.data.clubImage ?? ' '}',
                        ),
                      ),
                    ),
                    verticalSpace(10),

                    CenterTextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text:
                          '${playerProfile.data.clubName ?? 'غير معروف'.tr()}',
                    ),
                    verticalSpace(5),

                    CenterTextUtils(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: '${playerProfile.data.positionName ?? ''}',
                    ),
                  ],
                ),
              ),
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
