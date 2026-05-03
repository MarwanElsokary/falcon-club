import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../main_screen/cubit/main_state.dart';
import '../../cubit/scout_training_cubit.dart';

/// Categories widget للكشاف — نفس الشكل لكن يستخدم ScoutTrainingCubit
class ScoutTrainingCategoriesWidget extends StatefulWidget {
  const ScoutTrainingCategoriesWidget({super.key});

  @override
  State<ScoutTrainingCategoriesWidget> createState() =>
      _ScoutTrainingCategoriesWidgetState();
}

class _ScoutTrainingCategoriesWidgetState
    extends State<ScoutTrainingCategoriesWidget> {
  String? selectedFilter;
  String? iconSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth,
      height: 40.h,
      child: BlocBuilder<MainCubit, MainState>(
        buildWhen: (previous, current) =>
        current is categoriesLoading ||
            current is categoriesSuccess ||
            current is categoriesError,
        builder: (context, state) {
          return state.maybeWhen(
            categoriessuccess: (categoriesdata) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      axisAlignment: -1,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: selectedFilter == null
                        ? const SizedBox.shrink()
                        : GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = null;
                          iconSelected = null;
                        });
                        context.read<ScoutTrainingCubit>().fetchExercises(
                          categoryId: '',
                          popular: false,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        key: ValueKey(selectedFilter),
                        margin:
                        EdgeInsetsDirectional.only(start: 20.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: mainColor,
                        ),
                        child: Row(
                          children: [
                            CenterTextUtils(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              text: selectedFilter!,
                            ),
                            horizontalSpace(5),
                            ClipOval(
                              child: SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: CachedNetworkImage(
                                  imageUrl: iconSelected ?? '',
                                  fit: BoxFit.contain,
                                  placeholder: (_, __) => Skeletonizer(
                                    enabled: true,
                                    child: Container(
                                      height: 16.w,
                                      width: 16.w,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: SvgPicture.asset(
                                      'assets/svgs/unavailabeImage.svg',
                                      width: 16.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(2),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ScoutTrainingCubit>()
                                    .fetchExercises(
                                  categoryId: '',
                                  popular: false,
                                );
                                setState(() => selectedFilter = null);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  selectedFilter == null
                      ? const SizedBox.shrink()
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    height: 25.h,
                    width: 2.w,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: selectedFilter == null ? 20.w : 0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: categoriesdata.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final isSelected =
                            selectedFilter == categoriesdata.data[index].name;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedFilter = null;
                                    iconSelected = null;
                                    context
                                        .read<ScoutTrainingCubit>()
                                        .fetchExercises(
                                      categoryId: '',
                                      popular: false,
                                    );
                                  } else {
                                    selectedFilter =
                                        categoriesdata.data[index].name;
                                    iconSelected =
                                        categoriesdata.data[index].icon;
                                    context
                                        .read<ScoutTrainingCubit>()
                                        .fetchExercises(
                                      categoryId:
                                      '${categoriesdata.data[index].id ?? ''}',
                                      popular: false,
                                    );
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: isSelected
                                      ? mainColor
                                      : Colors.transparent,
                                  border: Border.all(color: mainColor),
                                ),
                                child: CenterTextUtils(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  isSelected ? Colors.white : mainColor,
                                  text: categoriesdata.data[index].name,
                                ),
                              ),
                            ),
                            horizontalSpace(5),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            orElse: () => SizedBox(height: 40.h),
          );
        },
      ),
    );
  }
}