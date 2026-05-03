import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../training_details/data/model/exercise_details_model.dart';
import '../../../../training_details/ui/widget/training_details_cat_widget.dart';
import '../../../../training_details/ui/widget/training_expansion_tile_widget.dart';

class ScoutExerciseInfoSection extends StatelessWidget {
  const ScoutExerciseInfoSection({
    super.key,
    required this.exerciseDetails,
  });

  final ExerciseDetailsModel exerciseDetails;

  @override
  Widget build(BuildContext context) {
    final data = exerciseDetails.data;

    return Container(
      color: mainColor,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(25.r),
            topEnd: Radius.circular(25.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(7),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 80.w,
                height: 5.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: greyClr.withOpacity(0.5),
                ),
              ),
            ),
            verticalSpace(12),
            TextUtils(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: data.title ?? '',
            ),
            verticalSpace(7),
            TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: blackclr,
              text: data.description ?? '',
            ),
            verticalSpace(15),
            // ✅ نفس الـ widget بالظبط زي النادي
            TrainingDetailsCatWidget(skills: data.skills),
            verticalSpace(15),
            // ✅ نفس الـ widget بالظبط زي النادي
            TrainingExpansionTileWidget(exerciseDetails: exerciseDetails),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}