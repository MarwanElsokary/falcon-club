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
import 'package:falconclubapp/shared/domain/entities/exercise.dart';

/// The exercises inside a trial, as tappable cards.
///
/// Migrated onto the shared [Exercise] entity — the old version used a *second*
/// `Exercise` class declared inside `trial_details_model.dart` that shadowed this
/// one. Behaviour is unchanged: the card colour comes from the backend's
/// `colorCode` (not a palette indexed by list position), and a tap opens the
/// exercise details screen.
class TrialExercisesWidget extends StatelessWidget {
  const TrialExercisesWidget({super.key, required this.exercises});

  final List<Exercise> exercises;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exercises.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final Exercise exercise = exercises[index];
        final Color cardColor = ColorCode.cardColor(
          exercise.colorCode,
          fallbackIndex: index,
        );

        return Column(
          children: [
            SlideEnimationWidget(
              index: index,
              child: GestureDetector(
                onTap: () => context.pushNamed(
                  AppRoute.exerciseDetailsScreen,
                  arguments: {'exerciseId': exercise.id},
                ),
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
                                            text: exercise.title,
                                          ),
                                          verticalSpace(10),
                                          TextUtils(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            text: exercise.description ?? '',
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
                                    itemCount: exercise.skillNames.length,
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
                                                text: exercise
                                                    .skillNames[currentindex],
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
                        borderRadius: BorderRadius.circular(16.r),
                        // The exercise photo is a transparent PNG, so the card
                        // colour shows through; painting it explicitly keeps that
                        // true even where the image is inset from the card edge.
                        child: Container(
                          color: cardColor,
                          width: 100.h,
                          height: 120.h,
                          child: CachedNetworkImage(
                            width: 100.h,
                            height: 120.h,
                            imageUrl: exercise.photoUrl ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Skeletonizer(
                              enabled: true,
                              child: Container(
                                width: 100.h,
                                height: 120.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(34.r),
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
