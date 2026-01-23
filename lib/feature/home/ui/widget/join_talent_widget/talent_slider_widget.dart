import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cache/cach_Helper.dart'; // ✅ استيراد CacheHelper
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
                // ✅ الحصول على حالة الاشتراك من الكاش مباشرة
                final myProfile = CacheHelper.getmyProfile();
                final isSubscribed = myProfile?.data.isSubscribed == true;

                // ✅ تصفية التمارين بناءً على حالة الاشتراك
                final exercisesToShow = allExercisata.data.where((exercise) {
                  // إذا كان المستخدم مشتركًا، نعرض كل التمارين
                  if (isSubscribed) {
                    return true;
                  }
                  // إذا لم يكن مشتركًا، نعرض فقط التمارين المجانية
                  return exercise.isPaid == false;
                }).toList();

                // ✅ إذا لم يكن هناك تمارين للعرض (للمستخدم غير المشترك)
                if (exercisesToShow.isEmpty) {
                  return SizedBox.shrink(); // لا نعرض أي شيء
                }

                // ✅ تحديد عدد التمارين المعروضة (بحد أقصى 4)
                final displayCount = exercisesToShow.length > 4 ? 4 : exercisesToShow.length;

                return Column(
                  children: [
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: displayCount,
                      options: CarouselOptions(
                        height: 170.w,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        autoPlayInterval: const Duration(seconds: 7),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 2500,
                        ),
                        viewportFraction: 0.90,
                        padEnds: false,
                        onPageChanged: (index, reason) {
                          currentIndex = index;
                          setState(() {});
                        },
                      ),

                      itemBuilder: (context, index, realIndex) {
                        final exercise = exercisesToShow[index];
                        final isLocked = exercise.isPaid == true && !isSubscribed;

                        return GestureDetector(
                          onTap: () {
                            if (isLocked) {
                              // ✅ عرض رسالة الاشتراك إذا كان التمرين مقفولاً
                              _showSubscriptionDialog(context);
                            } else {
                              // ✅ الانتقال لصفحة التفاصيل
                              context.pushNamed(
                                AppRoute.trainingDetailsScreen,
                                arguments: {
                                  'exerciseId': exercise.id?.toString() ?? '',
                                },
                              );
                            }
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
                                            exercise.title ?? '',
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
                                          exercise.categoryName ?? '',
                                        ),
                                        ClipOval(
                                          child: SizedBox(
                                            width: 16.w,
                                            height: 16.w,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              exercise.categoryIcon ?? '',
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
                                        itemCount: exercise.skills.length,
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
                                                    text: exercise
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

                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        child: SizedBox(
                                          width: 100.h,
                                          height: 120.h,
                                          child: CachedNetworkImage(
                                            width: 100.h,
                                            height: 120.h,
                                            imageUrl: exercise.photoPath,
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
                                                      ),
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
                                      if (isLocked)
                                        Container(
                                          width: 100.h,
                                          height: 120.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16.r),
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.lock_outline_rounded,
                                                  color: Colors.white,
                                                  size: 24.w,
                                                ),
                                                verticalSpace(4),
                                                Text(
                                                  'مقفل'.tr(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
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
                        count: displayCount,
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

  // ✅ دالة لعرض رسالة الاشتراك
  void _showSubscriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ أيقونة القفل في دائرة متدرجة
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [mainColor.withOpacity(0.1), mainColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 40.w,
                  ),
                ),
              ),
              verticalSpace(20),

              // ✅ العنوان
              TextUtils(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                text: 'هذا التمرين متاح للمشتركين فقط'.tr(),
              ),
              verticalSpace(12),

              // ✅ الوصف
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                text: 'اشترك الآن للوصول إلى جميع التمارين المدفوعة والمحتوى الحصري'.tr(),
                maxlines: 3,
              ),
              verticalSpace(20),

              // ✅ الميزات
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: mainColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem('عرض جميع التمارين المدفوعة'),
                    verticalSpace(8),
                    _buildFeatureItem('وصول غير محدود للتدريبات'),
                    verticalSpace(8),
                    _buildFeatureItem('احصائيات تقدم مفصلة'),
                    verticalSpace(8),
                    _buildFeatureItem('محتوى حصري للمشتركين'),
                  ],
                ),
              ),
              verticalSpace(25),

              // ✅ زر الاشتراك
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pushNamed(AppRoute.packageScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        text: 'اشترك الآن'.tr(),
                      ),
                      horizontalSpace(8),
                      Icon(
                        Icons.arrow_back_ios_new,
                        size: 16.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(10),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ دالة لبناء عنصر ميزة
  Widget _buildFeatureItem(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: mainColor,
          size: 18.w,
        ),
        horizontalSpace(10),
        Expanded(
          child: TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            text: text.tr(),
          ),
        ),
      ],
    );
  }
}