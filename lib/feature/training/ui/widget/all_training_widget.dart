import 'package:cached_network_image/cached_network_image.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/training/cubit/training_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cubit/training_state.dart';
import 'all_training_load.dart';

class AllTrainingWidget extends StatelessWidget {
  const AllTrainingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.displayHeight / 1.2,
      width: context.displayWidth / 1,
      child: BlocBuilder<TrainingCubit, TrainingState>(
        buildWhen: (previous, current) =>
            current is allExercisesLoading ||
            current is allExercisesSuccess ||
            current is allExercisesError,
        builder: (context, state) {
          return state.maybeWhen(
            allExercisessuccess: (allExercisata) {
              return ListView.builder(
                itemCount: allExercisata.data.length,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () => context.pushNamed(
                          AppRoute.trainingDetailsScreen,
                          arguments: {
                            'exerciseId':
                                '${allExercisata.data[index].id ?? ''}',
                          },
                        ),
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
                                        allExercisata.data[index].photoPath,
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
                                    errorWidget: (context, url, error) =>
                                        Padding(
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
                                    text: allExercisata.data[index].title,
                                  ),
                                  verticalSpace(3),
                                  SizedBox(
                                    height: 20.h,
                                    width: context.displayWidth / 1,
                                    child: ListView.builder(
                                      itemCount: allExercisata
                                          .data[index]
                                          .skills
                                          .length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, skillsIndex) {
                                        return Row(
                                          children: [
                                            TextUtils(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: mainColor,
                                              text: allExercisata
                                                  .data[index]
                                                  .skills[skillsIndex],
                                            ),
                                            Visibility(
                                              visible:
                                                  skillsIndex !=
                                                  allExercisata
                                                          .data[index]
                                                          .skills
                                                          .length -
                                                      1,
                                              child: TextUtils(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: mainColor,
                                                text: ' - ',
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
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
                      verticalSpace(
                        index == allExercisata.data.length - 1 ? 110 : 15,
                      ),
                    ],
                  );
                },
              );
            },
            orElse: () {
              return AllTrainingLoad();
            },
          );
        },
      ),
    );
  }
}
