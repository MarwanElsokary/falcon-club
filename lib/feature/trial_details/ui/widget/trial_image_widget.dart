import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TrialImageWidget extends StatelessWidget {
  const TrialImageWidget({
    super.key,
    required this.trialImage,
    required this.heroTag,
  });
  final String trialImage;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth / 1,
      height: 550.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Hero(
          tag: heroTag,
          child: SizedBox(
            width: context.displayWidth / 1,
            height: 550.h,
            child: CachedNetworkImage(
              width: context.displayWidth / 1,
              height: 550.h,
              imageUrl: trialImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: Container(
                  width: context.displayWidth / 1,
                  height: 550.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20.r,
                    ), // Match the border radius
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
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
    );
  }
}
