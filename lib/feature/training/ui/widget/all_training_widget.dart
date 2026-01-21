import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
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
    // ✅ الحصول على حالة الاشتراك من بيانات المستخدم
    final myProfile = CacheHelper.getmyProfile();
    final isSubscribed = myProfile?.data.isSubscribed ?? false;

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
                  final isPaid = exercise.isPaid == true;

                  // ✅ تحديد إذا كان التمرين مقفولاً
                  final isLocked = isPaid && !isSubscribed;

                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () {
                          if (isLocked) {
                            // ✅ إذا كان التمرين مقفولاً، عرض رسالة الاشتراك
                            _showSubscriptionDialog(context);
                          } else {
                            // ✅ إذا كان مفتوحاً، الانتقال لصفحة التفاصيل
                            context.pushNamed(
                              AppRoute.trainingDetailsScreen,
                              arguments: {
                                'exerciseId': '${exercise.id ?? ''}',
                              },
                            );
                          }
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
                                  // صورة التمرين مع مؤشر القفل
                                  Stack(
                                    children: [
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
                                      if (isLocked)
                                        Container(
                                          width: 112.w,
                                          height: 112.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.r),
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.lock_outline_rounded,
                                                  color: Colors.white,
                                                  size: 32.w,
                                                ),
                                                verticalSpace(4),
                                                Text(
                                                  'مقفل'.tr(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  horizontalSpace(10),
                                  //
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
                                                text: '${exercise.bookings} حجز',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // ✅ إزالة السهم من هنا
                                ],
                              ),

                              // ✅ السهم في الزاوية اليمنى
                              if (!isLocked)
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

  // ✅ دالة لعرض رسالة الاشتراك (مشابهة لتصميم الترتيب)
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
              // ✅ أيقونة القفل في دائرة متدرجة (مشابهة للترتيب)
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

              // ✅ الميزات (مثل تصميم الترتيب)
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