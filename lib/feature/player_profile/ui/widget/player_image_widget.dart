import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/feature/main_screen/data/model/my_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlayerImageWidget extends StatelessWidget {
  const PlayerImageWidget({super.key, required this.playerProfile});

  final MyProfileModel playerProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //image
        Align(
          alignment: AlignmentGeometry.center,
          child: Container(
            width: 98.w,
            height: 139.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: secondMainColor, width: 5.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                100.r,
              ), // Using .r for responsive border radius
              child: CachedNetworkImage(
                width: 98.w,
                height: 139.w,
                imageUrl: playerProfile.data.photo ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Skeletonizer(
                  enabled: true,
                  child: Container(
                    width: 98.w,
                    height: 139.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20.r,
                      ), // Match the border radius
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
                ),
              ),
            ),
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
          text: playerProfile.data.firstName ?? '',
        ),
      ],
    );
  }
}
