import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/center_text_utils.dart';
import '../../data/model/trial_details_model.dart';
import 'exercisePlayersWidget.dart';

class AllTrainingAtExperianceWidget extends StatelessWidget {
  const AllTrainingAtExperianceWidget({super.key, required this.exerciseList});
  final List<Exercise> exerciseList;
  @override
  Widget build(BuildContext context) {
    List catColor = [Color(0xFF451376), blueClr, Color(0xFF0C4F45)];

    return ListView.builder(
      itemCount: exerciseList.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            SlideEnimationWidget(
              index: index,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoute.clubTrainingDetailsScreen,
                    arguments: {
                      'exerciseId': '${exerciseList[index].id ?? ''}',
                    },
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: context.displayWidth / 1,
                      padding: paddingUtils(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: catColor[index % catColor.length],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          TextUtils(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            text: exerciseList[index].title,
                                          ),
                                          verticalSpace(10),
                                          TextUtils(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            text:
                                            exerciseList[index].description,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 100.h, height: 120.h),
                                  ],
                                ),
                                verticalSpace(10),
                                SizedBox(
                                  width: context.displayWidth / 1,
                                  height: 30.h,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                    exerciseList[index].skills.length,
                                    itemBuilder: (context, currentindex) {
                                      return Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10.r),
                                              border: Border.all(
                                                color: offWhiteClr.withOpacity(
                                                  0.2,
                                                ),
                                              ),
                                              color: offWhiteClr.withOpacity(
                                                0.15,
                                              ),
                                            ),
                                            child: Center(
                                              child: CenterTextUtils(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                text: exerciseList[index]
                                                    .skills[currentindex],
                                              ),
                                            ),
                                          ),
                                          horizontalSpace(10),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PositionedDirectional(

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          16.r,
                        ), // Using .r for responsive border radius
                        child: SizedBox(
                          width: 100.h,
                          height: 120.h,
                          child: CachedNetworkImage(
                            width: 100.h,
                            height: 120.h,
                            imageUrl: exerciseList[index].photoPath ?? '',

                            fit: BoxFit.cover,
                            placeholder: (context, url) => Skeletonizer(
                              enabled: true,
                              child: Container(
                                width: 100.h,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    34.r,
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
                  ],
                ),
              ),
            ),
            // ── اللاعبين تحت كل تمرين ────────────────────────────
            if (exerciseList[index].id != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: ExercisePlayersWidget(
                  exerciseId: exerciseList[index].id.toString(),
                ),
              ),
            verticalSpace(10),
          ],
        );
      },
    );
  }
}