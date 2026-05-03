import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:falconclubapp/feature/training/cubit/training_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../main_screen/cubit/main_state.dart';

class TraningCatogeriesWidget extends StatefulWidget {
  const TraningCatogeriesWidget({super.key});

  @override
  State<TraningCatogeriesWidget> createState() =>
      _TraningCatogeriesWidgetState();
}

class _TraningCatogeriesWidgetState extends State<TraningCatogeriesWidget> {
  String? selectedFilter;
  String? iconSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth / 1,
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
                  // ✅ AnimatedSwitcher عشان نظهر أو نخفي الفلتر المختار بانيميشن
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          // أنيميشن جميل من البداية للنهاية
                          return SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.horizontal,
                            axisAlignment: -1,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                    child: selectedFilter == null
                        ? const SizedBox.shrink() // مفيش حاجة تظهر لو مفيش فلتر مختار
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilter = null;
                                iconSelected = null;
                              });
                              context.read<TrainingCubit>().emitallExercises(
                                categoryId: '',
                                popular: false,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              key: ValueKey(selectedFilter),
                              margin: EdgeInsetsDirectional.only(start: 20.w),
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
                                        placeholder: (context, url) =>
                                            Skeletonizer(
                                              enabled: true,
                                              child: Container(
                                                height: 16.w,
                                                width: 16.w,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
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
                                      // لما يضغط على علامة X الفلتر يختفي
                                      context
                                          .read<TrainingCubit>()
                                          .emitallExercises(
                                            categoryId: '',
                                            popular: false,
                                          );
                                      setState(() {
                                        selectedFilter = null;
                                      });
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
                      ? const SizedBox.shrink() // مفيش حاجة تظهر لو مفيش فلتر مختار
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 25.h,
                          width: 2.w,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),

                  // ✅ القائمة اللي فيها الفلاتر
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
                                    // لو ضغط عليه تاني -> يشيله
                                    selectedFilter = null;
                                    iconSelected = null;
                                    context
                                        .read<TrainingCubit>()
                                        .emitallExercises(
                                          categoryId: '',
                                          popular: false,
                                        );
                                  } else {
                                    selectedFilter =
                                        categoriesdata.data[index].name;
                                    iconSelected =
                                        categoriesdata.data[index].icon;
                                    context.read<TrainingCubit>().emitallExercises(
                                      categoryId:
                                          '${categoriesdata.data[index].id ?? ''}',
                                      popular: false,
                                    );
                                    //filter trinning data
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
                                  color: isSelected ? Colors.white : mainColor,
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
            orElse: () {
              return SizedBox(height: 40.h);
            },
          );
        },
      ),
    );
  }
}
