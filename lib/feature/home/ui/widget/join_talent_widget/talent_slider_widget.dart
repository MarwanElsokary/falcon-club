import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/training/cubit/training_cubit.dart';
import 'package:falcon/feature/training/cubit/training_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/thems/thems.dart';
import 'show_all_button_widget.dart';

class TalentSliderWidget extends StatefulWidget {
  const TalentSliderWidget({super.key});

  @override
  State<TalentSliderWidget> createState() => _TalentSliderWidgetState();
}

class _TalentSliderWidgetState extends State<TalentSliderWidget> {
  int currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<TrainingCubit, TrainingState>(
          buildWhen: (previous, current) =>
              current is allExercisesLoading ||
              current is allExercisesSuccess ||
              current is allExercisesError,
          builder: (context, state) {
            return state.maybeWhen(
              allExercisessuccess: (allExercisata) {
                return Column(
                  children: [
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: allExercisata.data.length > 4
                          ? 4
                          : allExercisata.data.length,

                      options: CarouselOptions(
                        height: 170.w,
                        autoPlay: true,
                        enlargeCenterPage:
                            false, // لو مش عايز تكبير العنصر في النص
                        enableInfiniteScroll: false,
                        autoPlayInterval: const Duration(seconds: 7),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 2500,
                        ),
                        viewportFraction:
                            0.90, // 👈 يظهر جزء من العنصر اللي بعده
                        padEnds: false, // 👈 يبدأ من أول الشاشة مش من المنتصف
                        onPageChanged: (index, reason) {
                          currentIndex = index;
                          setState(() {});
                        },
                      ),

                      itemBuilder: (context, index, realIndex) {
                        return GestureDetector(
                          onTap: () {
                            // أي أكشن عند الضغط
                            context.pushNamed(
                              AppRoute.trainingDetailsScreen,
                              arguments: {
                                'exerciseId':
                                    '${allExercisata.data[index].id ?? ''}',
                              },
                            );
                          },
                          child: Container(
                            height: 170.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.w,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: Color(0xFF0C4F45),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextUtils(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            text:
                                                allExercisata
                                                    .data[index]
                                                    .title ??
                                                '',
                                          ),
                                        ),
                                        horizontalSpace(100),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        TextUtils(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          text:
                                              allExercisata
                                                  .data[index]
                                                  .categoryName ??
                                              '',
                                        ),
                                        ClipOval(
                                          child: SizedBox(
                                            width: 16.w,
                                            height: 16.w,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  allExercisata
                                                      .data[index]
                                                      .categoryIcon ??
                                                  '',
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      height: 16.w,
                                                      width: 16.w,
                                                      decoration:
                                                          const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => Container(
                                                    padding: EdgeInsets.all(
                                                      3.w,
                                                    ),

                                                    child: SvgPicture.asset(
                                                      'assets/svgs/unavailabeImage.svg',
                                                      width: 16.w,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(),
                                    SizedBox(
                                      height: 27.h,
                                      width: context.displayWidth / 1,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: allExercisata
                                            .data[index]
                                            .skills
                                            .length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, skillIndex) {
                                          return Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 3.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: greenClr,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        10.r,
                                                      ),
                                                ),
                                                child: Center(
                                                  child: CenterTextUtils(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    text: allExercisata
                                                        .data[index]
                                                        .skills[skillIndex],
                                                  ),
                                                ),
                                              ),
                                              horizontalSpace(7),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                PositionedDirectional(
                                  end: 0,
                                  top: 0,

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
                                        imageUrl:
                                            allExercisata.data[index].photoPath,

                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Skeletonizer(
                                              enabled: true,
                                              child: Container(
                                                width: 100.h,
                                                height: 120.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        34.r,
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    verticalSpace(15),
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: currentIndex,
                        count: allExercisata.data.length > 4
                            ? 4
                            : allExercisata.data.length,
                        onDotClicked: (index) {
                          carouselController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 1500),
                            curve: Curves.easeInOut,
                          );
                        },

                        duration: Duration(milliseconds: 500),
                        axisDirection: Axis.horizontal,
                        effect: JumpingDotEffect(
                          activeDotColor: mainColor,
                          dotHeight: 10.w,
                          dotWidth: 10.w,
                          // ignore: deprecated_member_use
                          dotColor: blackclr.withOpacity(0.2),
                        ),
                      ),
                    ),
                    verticalSpace(15),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(AppRoute.trainingScreen);
                        },
                        child: ShowAllButtonWidget(title: 'عرض التدريبات'.tr()),
                      ),
                    ),
                  ],
                );
              },
              orElse: () {
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    height: 200.w,
                    width: context.displayWidth / 1,
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.w,
                    ),
                    decoration: BoxDecoration(
                      color: greyClr.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            );
          },
        ),

        verticalSpace(10),
      ],
    );
  }
}
