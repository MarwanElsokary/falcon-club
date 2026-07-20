import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/profile_avatar.dart';
import 'package:falconclubapp/feature/profile/domain/entities/player_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PlayerImageWidget extends StatelessWidget {
  const PlayerImageWidget({
    super.key,
    required this.playerProfile,
    this.favoriteButton,
  });

  final PlayerProfile playerProfile;

  /// Optional overlay pinned to the photo's bottom-start corner (the favourite
  /// heart on the player-profile screen). Null everywhere else.
  final Widget? favoriteButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //image
        Align(
          alignment: AlignmentGeometry.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ProfileAvatar(
                imageUrl: playerProfile.photoUrl,
                fallback: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
              ),
              if (favoriteButton != null)
                PositionedDirectional(
                  bottom: -4.h,
                  start: -4.w,
                  child: favoriteButton!,
                ),
            ],
          ),
        ),
        verticalSpace(5),
        CenterTextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: greyClr,
          text: 'Fteet Ai',
        ),
        verticalSpace(2),
        CenterTextUtils(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: playerProfile.firstName,
        ),
      ],
    );
  }
}
