import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main_screen/data/model/my_profile_model.dart';

class PlayerInformationWidget extends StatelessWidget {
  const PlayerInformationWidget({super.key, required this.playerProfile});
  final MyProfileModel playerProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //phone number
          infoDataWidget(
            icon: 'assets/svgs/proicons_phone.svg',
            title:
                '${playerProfile.data.phoneNumber.toString() != 'null' ? playerProfile.data.phoneNumber.toString().substring(1) : playerProfile.data.phoneNumber ?? ''}'
                '+',
          ),
          verticalSpace(5),
          //email
          infoDataWidget(
            icon: 'assets/svgs/lets-icons_e-mail.svg',
            title: '${playerProfile.data.email ?? ''}',
          ),
          verticalSpace(5),
          //edge
          infoDataWidget(
            icon: 'assets/svgs/hugeicons_date-time.svg',
            title: '${playerProfile.data.birthDate ?? ''}',
          ),
        ],
      ),
    );
  }

  Widget infoDataWidget({required String icon, required String title}) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 16.w),
        horizontalSpace(5),
        TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          text: title,
        ),
      ],
    );
  }
}
