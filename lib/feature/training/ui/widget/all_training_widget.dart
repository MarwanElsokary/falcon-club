import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/training/cubit/training_cubit.dart';
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
                  final exercise = allExercisata.data[index];

                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () {
                          context.pushNamed(
                            AppRoute.clubTrainingDetailsScreen,
                            arguments: {
                              'exerciseId': '${exercise.id ?? ''}',
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // صورة التمرين
                                  Container(
                                    width: 112.w,
                                    height: 112.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: CachedNetworkImage(
                                        width: 112.w,
                                        height: 112.w,
                                        imageUrl: exercise.photoPath,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Skeletonizer(
                                          enabled: true,
                                          child: Container(
                                            width: 112.w,
                                            height: 112.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20.r),
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
                                  horizontalSpace(10),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12.h),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextUtils(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            text: exercise.title,
                                            maxlines: 2,
                                          ),
                                          verticalSpace(8),
                                          SizedBox(
                                            height: 20.h,
                                            width: context.displayWidth / 1,
                                            child: ListView.builder(
                                              itemCount: exercise.skills.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, skillsIndex) {
                                                return Container(
                                                  margin: EdgeInsetsDirectional.only(end: 6.w),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 4.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: mainColor.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8.r),
                                                  ),
                                                  child: TextUtils(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: mainColor,
                                                    text: exercise.skills[skillsIndex],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          verticalSpace(8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule_outlined,
                                                size: 14.w,
                                                color: Colors.black54,
                                              ),
                                              horizontalSpace(4),
                                              TextUtils(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black54,
                                                text: '${exercise.bookings} اشتراك',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Arrow in corner
                              PositionedDirectional(
                                end: 12.w,
                                bottom: 12.w,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.w,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
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
              return const AllTrainingLoad();
            },
          );
        },
      ),
    );
  }
}