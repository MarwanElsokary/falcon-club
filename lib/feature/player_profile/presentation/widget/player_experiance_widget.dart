import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/domain/entities/player_profile.dart';
import '../../../profile/presentation/widgets/profile_section_card.dart';

class PlayerExperianceWidget extends StatelessWidget {
  const PlayerExperianceWidget({super.key, required this.playerProfile});
  final PlayerProfile playerProfile;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: 'خبرة اللاعب',
      child: Container(
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
                child: Image.network(playerProfile.clubImageUrl ?? ' '),
              ),
            ),
            verticalSpace(10),

            CenterTextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: playerProfile.clubName ?? 'غير معروف'.tr(),
            ),
            verticalSpace(5),

            CenterTextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: playerProfile.positionName ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
