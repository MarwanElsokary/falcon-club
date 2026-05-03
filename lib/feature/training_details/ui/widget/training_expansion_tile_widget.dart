import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/model/exercise_details_model.dart';

class TrainingExpansionTileWidget extends StatelessWidget {
  const TrainingExpansionTileWidget({super.key, required this.exerciseDetails});
  final ExerciseDetailsModel exerciseDetails;

  @override
  Widget build(BuildContext context) {
    List catColor = [mainColor, greenClr, kCOlor5, Color(0xFF0C4F45)];

    return Column(
      children: [
        //المعدات
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(0),
            childrenPadding: EdgeInsets.all(0),
            title: TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'المعدات'.tr(),
            ),
            children: [
              ListView.builder(
                itemCount: exerciseDetails.data.equipments.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CachedNetworkImage(
                                imageUrl:
                                    exerciseDetails.data.equipments[i].image ??
                                    '',
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Skeletonizer(
                                  enabled: true,
                                  child: Container(
                                    height: 20.w,
                                    width: 20.w,
                                    decoration: const BoxDecoration(
                                      color: offWhiteClr,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  padding: EdgeInsets.all(3.w),

                                  child: SvgPicture.asset(
                                    'assets/svgs/unavailabeImage.svg',
                                    width: 16.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          horizontalSpace(5),
                          Expanded(
                            child: TextUtils(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: blackclr,
                              text: exerciseDetails.data.equipments[i].name,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(3),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(0),
            childrenPadding: EdgeInsets.all(0),
            title: TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'تعليمات التصوير'.tr(),
            ),
            children: [
              ListView.builder(
                itemCount: exerciseDetails.data.playerInstructions.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0),
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 8.w,
                            width: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: catColor[i % catColor.length],
                            ),
                          ),
                          horizontalSpace(5),
                          Expanded(
                            child: TextUtils(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: blackclr,
                              text: exerciseDetails.data.playerInstructions[i],
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(3),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
