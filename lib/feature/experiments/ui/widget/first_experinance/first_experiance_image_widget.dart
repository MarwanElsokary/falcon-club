import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FirstExperianceImageWidget extends StatelessWidget {
  const FirstExperianceImageWidget({
    super.key,
    required this.height,
    required this.image,
  });
  final double height;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth / 1,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          34.r,
        ), // Using .r for responsive border radius
        child: SizedBox(
          width: context.displayWidth / 1,
          height: height,
          child: CachedNetworkImage(
            width: context.displayWidth / 1,
            height: height,
            imageUrl: image,

            fit: BoxFit.cover,
            placeholder: (context, url) => Skeletonizer(
              enabled: true,
              child: Container(
                width: context.displayWidth / 1,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    34.r,
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
    );
  }
}
