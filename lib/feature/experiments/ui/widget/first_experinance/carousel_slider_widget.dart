import 'dart:developer';

import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/feature/experiments/cubit/experiments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/thems/thems.dart';
import 'experiance_data_widget.dart';
import 'first_experiance_image_widget.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({
    super.key,
    required this.height,
    required this.padding,
    required this.heroPage,
  });
  final double height;
  final double padding;
  final String heroPage;

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int activeIndex = 0;
  double dragStartX = 0;

  void _onHorizontalDragStart(DragStartDetails details) {
    dragStartX = details.globalPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double delta = details.globalPosition.dx - dragStartX;

    // تحديد اتجاه اللغة
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    // لو عربي (RTL): سحب يمين = قدام، سحب شمال = ورا
    // لو إنجليزي (LTR): سحب يمين = ورا، سحب شمال = قدام

    if (isRTL) {
      // عربي: سحب يمين (→) يروح لل card اللي بعده
      if (delta > 50 &&
          activeIndex <
              context.read<ExperimentsCubit>().allTrialsList.length - 1) {
        setState(() {
          activeIndex++;
        });
        dragStartX = details.globalPosition.dx;
      }
      // عربي: سحب شمال (←) يرجع لل card اللي قبله
      else if (delta < -50 && activeIndex > 0) {
        setState(() {
          activeIndex--;
        });
        dragStartX = details.globalPosition.dx;
      }
    } else {
      // إنجليزي: سحب يمين (→) يرجع لل card اللي قبله
      if (delta > 50 && activeIndex > 0) {
        setState(() {
          activeIndex--;
        });
        dragStartX = details.globalPosition.dx;
      }
      // إنجليزي: سحب شمال (←) يروح لل card اللي بعده
      else if (delta < -50 &&
          activeIndex <
              context.read<ExperimentsCubit>().allTrialsList.length - 1) {
        setState(() {
          activeIndex++;
        });
        dragStartX = details.globalPosition.dx;
      }
    }
  }

  double _getWidth(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (index == activeIndex) {
      return screenWidth - 128.w - widget.padding.w;
    } else if (index < activeIndex - 1 || index > activeIndex + 2) {
      return 0;
    } else {
      return 50.w;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragUpdate: _onHorizontalDragUpdate,
          child: Container(
            height: widget.height.h,
            padding: EdgeInsetsDirectional.only(start: widget.padding.w),
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  context.read<ExperimentsCubit>().allTrialsList.length,
                  (index) {
                    return InkWell(
                      onTap: () {
                        log(
                          context
                              .read<ExperimentsCubit>()
                              .allTrialsList[index]
                              .id
                              .toString(),
                        );
                        context.pushNamed(
                          AppRoute.experianceDetailsScreen,
                          arguments: {
                            'title':
                                '${context.read<ExperimentsCubit>().allTrialsList[index].title ?? ''}',
                            'trialId':
                                '${context.read<ExperimentsCubit>().allTrialsList[index].id ?? ''}',
                            'heroTag':
                                "${widget.heroPage}_experiance_image_hero_${context.read<ExperimentsCubit>().allTrialsList[index].id}", // ✅ بدل 1 بـ index
                            'experianceImage':
                                context
                                    .read<ExperimentsCubit>()
                                    .allTrialsList[index]
                                    .photoPath ??
                                '',
                          },
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        width: _getWidth(index),
                        height: widget.height.h,
                        margin: EdgeInsets.symmetric(
                          horizontal: _getWidth(index) == 0 ? 0 : 4.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: Stack(
                          children: [
                            Hero(
                              tag:
                                  "${widget.heroPage}_experiance_image_hero_${context.read<ExperimentsCubit>().allTrialsList[index].id}",
                              child: FirstExperianceImageWidget(
                                height: widget.height.h,
                                image:
                                    context
                                        .read<ExperimentsCubit>()
                                        .allTrialsList[index]
                                        .photoPath ??
                                    '',
                              ),
                            ),

                            PositionedDirectional(
                              bottom: 0,
                              start: 0,
                              end: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(34.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    stops: const [0.0, 0.6, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              bottom: 20.w,
                              start: 10.w,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 1000),
                                child: index == activeIndex
                                    ? SizedBox(
                                        width: _getWidth(index),
                                        child: ExperianceDataWidget(
                                          title:
                                              context
                                                  .read<ExperimentsCubit>()
                                                  .allTrialsList[index]
                                                  .title ??
                                              '',
                                          cat:
                                              context
                                                  .read<ExperimentsCubit>()
                                                  .allTrialsList[index]
                                                  .categoryName ??
                                              '',
                                        ),
                                      )
                                    : const Text(''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        verticalSpace(20),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: context.read<ExperimentsCubit>().allTrialsList.length,
            onDotClicked: (index) {},

            duration: Duration(milliseconds: 500),
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              activeDotColor: mainColor,
              dotHeight: 10.w,
              dotWidth: 10.w,
              // ignore: deprecated_member_use
              dotColor: blackclr.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }
}
