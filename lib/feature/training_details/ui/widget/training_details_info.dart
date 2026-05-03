import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/training_details/data/model/exercise_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'attemps_widget.dart';
import 'start_training_button.dart';
import 'training_details_cat_widget.dart';
import 'training_expansion_tile_widget.dart';

class TrainingDetailsInfo extends StatelessWidget {
  const TrainingDetailsInfo({super.key, required this.exerciseDetails});
  final ExerciseDetailsModel exerciseDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mainColor,
      child: Column(
        children: [
          Container(
            width: context.displayWidth / 1,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: whiteclr,
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
                  alignment: AlignmentGeometry.center,
                  child: Container(
                    width: 80.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      color: greyClr.withOpacity(0.5),
                    ),
                  ),
                ),
                verticalSpace(10),
                TextUtils(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: exerciseDetails.data.title,
                ),
                verticalSpace(7),
                TextUtils(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: blackclr,
                  text: exerciseDetails.data.description,
                ),
                verticalSpace(15),

                TrainingDetailsCatWidget(skills: exerciseDetails.data.skills),
                verticalSpace(
                  exerciseDetails.data.attempts.isNotEmpty ? 15 : 0,
                ),

                //atemps
                AttempsWidget(exerciseDetails: exerciseDetails),

                verticalSpace(exerciseDetails.data.skills.isEmpty ? 0 : 15),

                //ExpansionTile
                TrainingExpansionTileWidget(exerciseDetails: exerciseDetails),
                verticalSpace(15),
                StartTrainingButton(exerciseDetails: exerciseDetails),
                verticalSpace(100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
