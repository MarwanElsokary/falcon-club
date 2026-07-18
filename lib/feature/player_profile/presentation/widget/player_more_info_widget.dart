import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/feature/profile/domain/entities/player_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';

class PlayerMoreInfoWidget extends StatelessWidget {
  const PlayerMoreInfoWidget({super.key, required this.playerProfile});
  final PlayerProfile playerProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.displayWidth / 1,
      padding: paddingUtils(),
      decoration: BoxDecoration(
        color: secondMainColor,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(30.r),
          bottomStart: Radius.circular(30.r),
        ),
      ),
      child: Row(
        children: [
          //
          Expanded(
            child: playerinputData(
              title: 'القدم المفضلة'.tr(),
              subTitle: playerProfile.preferredFoot ?? '',
            ),
          ),

          Container(height: 40.h, width: 1, color: greyClr.withOpacity(0.3)),
          Expanded(
            child: playerinputData(
              title: 'الموقع'.tr(),
              subTitle: playerProfile.positionName ?? '',
            ),
          ),
          // ignore: deprecated_member_use
          Container(height: 40.h, width: 1, color: greyClr.withOpacity(0.3)),
          Expanded(
            child: playerinputData(
              title: 'الجنس'.tr(),
              subTitle: playerProfile.gender?.arabicLabel ?? '',
            ),
          ),
        ],
      ),
    );
  }

  Widget playerinputData({required String title, required String subTitle}) {
    return Column(
      children: [
        CenterTextUtils(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: title,
        ),
        verticalSpace(2),
        CenterTextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: subTitle,
        ),
      ],
    );
  }
}
