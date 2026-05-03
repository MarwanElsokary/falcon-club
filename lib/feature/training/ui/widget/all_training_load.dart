import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllTrainingLoad extends StatelessWidget {
  const AllTrainingLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Skeletonizer(
              enabled: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 112.w,
                    height: 112.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20.r,
                      ), // Using .r for responsive border radius
                      child: SizedBox(
                        width: 112.w,
                        height: 112.w,
                        child: CachedNetworkImage(
                          width: 112.w,
                          height: 112.w,
                          imageUrl:
                              'https://i.pinimg.com/736x/80/a6/1c/80a61caf4529b3b208d2184e09ce8093.jpg',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Skeletonizer(
                            enabled: true,
                            child: Container(
                              width: 112.w,
                              height: 112.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  20.r,
                                ), // Match the border radius
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Padding(
                            padding: EdgeInsets.all(20.w),
                            child: SvgPicture.asset(
                              'assets/svgs/unavailabeImage.svg',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(10),
                  //
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        verticalSpace(3),
                        TextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          text: '10 دقائق جري سريع',
                        ),
                        verticalSpace(3),
                        TextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: mainColor,
                          text: 'تحمل - توازن',
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      verticalSpace(8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpace(index == 4 ? 110 : 15),
          ],
        );
      },
    );
  }
}
