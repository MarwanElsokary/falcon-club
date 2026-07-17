import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/color_code.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/center_text_utils.dart';
import '../../data/model/trial_details_model.dart';

class AllTrainingAtExperianceWidget extends StatelessWidget {
  const AllTrainingAtExperianceWidget({super.key, required this.exerciseList});

  final List<Exercise> exerciseList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exerciseList.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // The exercise's own colour, from the backend.
        //
        // This used to be `catColor[index % catColor.length]` over a hard-coded
        // three-colour palette — so a card's colour depended on where it landed
        // in the list, and reordering the response recoloured everything. The
        // backend has always sent `colorCode`; the client just ignored it.
        //
        // Nothing else about the card changes. The skill tag is
        // `offWhiteClr.withOpacity(0.15)` — a *translucent* overlay, which
        // composites over whatever this card is painted, so it remains exactly
        // the same lighter shade of the card colour that it is today, for any
        // colour the backend sends. No colour arithmetic is needed or wanted.
        final Color cardColor = ColorCode.cardColor(
          exerciseList[index].colorCode?.toString(),
          fallbackIndex: index,
        );

        return Column(
          children: [
            SlideEnimationWidget(
              index: index,
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoute.exerciseDetailsScreen,
                    arguments: {
                      'exerciseId': '${exerciseList[index].id}',
                      'exerciseTitle': exerciseList[index].title,
                      'exerciseDescription': exerciseList[index].description,
                      'exerciseSkills': exerciseList[index].skills,
                      'exercisePhotoPath': exerciseList[index].photoPath,
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
                        color: cardColor,
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
                      end: 20.w,
                      top: 20.w,

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          16.r,
                        ), // Using .r for responsive border radius
                        // The exercise photo is a transparent PNG, so whatever
                        // sits behind it shows through. It used to be the card
                        // itself; painting the same colour explicitly here keeps
                        // that true even where the image is inset from the card
                        // edge, and makes the dependency visible rather than
                        // incidental.
                        child: Container(
                          color: cardColor,
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
            verticalSpace(10),
          ],
        );
      },
    );
  }
}
