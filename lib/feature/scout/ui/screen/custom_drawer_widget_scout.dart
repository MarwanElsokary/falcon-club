import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:falconclubapp/shared/domain/subscription_reader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/url-call.dart';
import 'package:falconclubapp/feature/main_screen/ui/widget/log_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widget/show_photo_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../main_screen/cubit/main_cubit.dart';
import '../../../main_screen/cubit/main_state.dart';

class CustomDrawerScout extends StatelessWidget {
  const CustomDrawerScout({super.key});

  /// The label under the scout's name.
  ///
  /// It used to be driven by the raw `isSubscribed` flag with its own inline
  /// day-counting, and it got the edge case wrong: a subscription that had been
  /// *bought* but had **zero days left** fell into the `else` and rendered
  /// "مشترك" — in green. An expired scout was told they were subscribed.
  ///
  /// `Subscription.isActive` is the single rule now, so "expired" and "never
  /// subscribed" both read "غير مشترك", which is what they both are.
  String _getSubscriptionStatusText(Subscription subscription) {
    if (!subscription.isActive) return 'غير مشترك'.tr();

    final int? days = subscription.remainingDays;
    if (days == null) return 'مشترك'.tr();
    return '${'الأيام المتبقية'.tr()}: $days ${'يوم'.tr()}';
  }

  Color _getSubscriptionColor(Subscription subscription) =>
      subscription.isActive ? Colors.green : redClr;

  @override
  Widget build(BuildContext context) {
    // في ملف custom_drawer.dart
    // ابحث عن List itemData واضف العنصر ده بعد التدريبات وقبل سياسة الخصوصية:

    List itemData = [
      // {
      //   'width': 20.w,
      //   'icon': 'assets/svgs/profile.svg',
      //   'title': 'الحساب'.tr(),
      //   'ontap': () {
      //     context.pushNamed(
      //       AppRoute.playerProfile,
      //       arguments: {
      //         'isMyProfile': true,
      //         'playerId': CacheHelper.getmyProfile() == null
      //             ? ''
      //             : CacheHelper.getmyProfile()!.data.userId,
      //       },
      //     );
      //   },
      // },
      // {
      //   'width': 20.w,
      //   'icon': 'assets/svgs/svgexport-18 (1) 2.svg',
      //   'title': 'تعديل الحساب'.tr(),
      //   'ontap': () {
      //     context.pushNamed(AppRoute.signUpScreen, arguments: {'update': true});
      //   },
      // },
      {
        'width': 16.w,
        'icon': 'assets/svgs/notification_icon.svg',
        'title': 'الاشعارات'.tr(),
        'ontap': () {},
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/rank_icon.svg',
        'title': 'الترتيب'.tr(),
        'ontap': () {
          context.pushNamed(
            AppRoute.rankScreen,
            arguments: {'context': context},
          );
        },
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/Experiments_select.svg',
        'title': 'التجارب'.tr(),
        'ontap': () {
          context.pushNamed(AppRoute.allExperimentScreen);
        },
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/Training_select.svg',
        'title': 'التدريبات'.tr(),
        'ontap': () {
          context.pushNamed(AppRoute.scoutTrainingScreen);
        },
      },

      // {
      //   'width': 20.w,
      //   'icon': 'assets/svgs/ruler-angular-svgrepo-com.svg',
      //   'title': 'القياسات'.tr(),
      //   'ontap': () {
      //     context.pushNamed(AppRoute.measurementScreen);
      //   },
      // },
      {
        'width': 20.w,
        'icon': 'assets/svgs/lock-svgrepo-com.svg',
        'title': 'سياسة الخصوصية'.tr(),
        'ontap': () {
          urlCall(
            context: context,
            url: 'https://falconai.net/api/Website/GetPrivacy',
          );
        },
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/pckage-card.svg',
        'title': 'الباقات'.tr(),
        'ontap': () {
          context.pushNamed(AppRoute.packageScreen);
        },
      },
      {
        'width': 15.w,
        'icon': 'assets/svgs/logout_icon.svg',
        'title': 'تسجيل الخروج'.tr(),
        'ontap': () {
          // Capture the navigator before the drawer closes. `context.pop()`
          // dismisses the drawer, deactivating THIS build context — so the
          // callback below must not reach for `Navigator.of(context)` after that.
          final navigator = Navigator.of(context, rootNavigator: true);
          context.pop();
          showLogoutDialog(
            context,
            () => navigator.pushNamedAndRemoveUntil(
              AppRoute.loginScreen,
              (route) => false,
            ),
            'هل انت متأكد انك تريد تسجيل الخروج من هذا الحساب'.tr(),
            'assets/lottie/Log out.json',
          );
        },
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/delete-02.svg',
        'title': 'حذف الحساب'.tr(),
        'ontap': () {
          final navigator = Navigator.of(context, rootNavigator: true);
          context.pop();
          showLogoutDialog(
            context,
            () => navigator.pushNamedAndRemoveUntil(
              AppRoute.loginScreen,
              (route) => false,
            ),
            'هل انت متأكد انك تريد حذف هذا الحساب'.tr(),
            'assets/lottie/Log out.json',
          );
        },
      },
    ];
    return Drawer(
      width: context.displayWidth / 1,
      // استخدام Clip.none لتجنب قص المحتوى
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/drawer_back_ground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // استخدام Expanded بدلاً من Flexible لملء المساحة المتبقية
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //user data
                      BlocBuilder<MainCubit, MainState>(
                        builder: (context, state) {
                          // One entitlement rule, shared with the rank screen,
                          // the exercise paywall and the package screen.
                          final subscription = getIt<SubscriptionReader>()
                              .current();
                          final isSubscribed = subscription.isActive;
                          final subscriptionText = _getSubscriptionStatusText(
                            subscription,
                          );

                          return InkWell(
                            onTap: () {
                              context.pushNamed(AppRoute.packageScreen);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      showPhotoDialog(
                                        context: context,
                                        image:
                                            CacheHelper.getmyProfile() == null
                                            ? ''
                                            : CacheHelper.getmyProfile()!
                                                      .data
                                                      .photo ??
                                                  '',
                                        name: CacheHelper.getmyProfile() == null
                                            ? ''
                                            : CacheHelper.getmyProfile()!
                                                      .data
                                                      .firstName ??
                                                  '',
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.w,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 48.w,
                                          height: 48.w,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                CacheHelper.getmyProfile() ==
                                                    null
                                                ? ''
                                                : CacheHelper.getmyProfile()!
                                                          .data
                                                          .photo ??
                                                      '',
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Skeletonizer(
                                                  enabled: true,
                                                  child: Container(
                                                    height: 48.w,
                                                    width: 48.w,
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
                                                  padding: EdgeInsets.all(12.w),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: offWhiteClr,
                                                      ),
                                                  child: Image.asset(
                                                    'assets/images/Mask group.png',
                                                    width: 48.w,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextUtils(
                                          maxlines: 1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          text:
                                              'هلا ${CacheHelper.getmyProfile() == null ? '' : CacheHelper.getmyProfile()!.data.firstName ?? ''}!',
                                        ),
                                        verticalSpace(3),
                                        TextUtils(
                                          maxlines: 1,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          text:
                                              CacheHelper.getmyProfile() == null
                                              ? ''
                                              : CacheHelper.getmyProfile()!
                                                        .data
                                                        .positionName ??
                                                    '',
                                        ),
                                        verticalSpace(3),

                                        // عرض حالة الاشتراك بشكل مشابه لشاشة البروفايل
                                        if (!isSubscribed)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: redClr.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: redClr.withOpacity(0.3),
                                                width: 1.w,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.lock_outline,
                                                  color: redClr,
                                                  size: 12.w,
                                                ),
                                                horizontalSpace(4),
                                                Flexible(
                                                  child: TextUtils(
                                                    maxlines: 1,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: redClr,
                                                    text: 'غير مشترك',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        else
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: Colors.green.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1.w,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: 12.w,
                                                ),
                                                horizontalSpace(4),
                                                Flexible(
                                                  child: TextUtils(
                                                    maxlines: 1,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                    text: subscriptionText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        verticalSpace(5),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (context
                                          .read<MainCubit>()
                                          .sliderDrawerKey
                                          .currentState!
                                          .isDrawerOpen) {
                                        context
                                            .read<MainCubit>()
                                            .sliderDrawerKey
                                            .currentState
                                            ?.closeDrawer();
                                      } else {
                                        context
                                            .read<MainCubit>()
                                            .sliderDrawerKey
                                            .currentState
                                            ?.openDrawer();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: offWhiteClr.withOpacity(0.06),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 25.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      verticalSpace(7),
                      Divider(
                        color: offWhiteClr.withOpacity(0.3),
                        endIndent: 20.w,
                        indent: 20.w,
                      ),
                      verticalSpace(20),

                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: itemData.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: itemData[index]['ontap'],
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      itemData[index]['icon'],
                                      width: itemData[index]['width'],

                                      color:
                                          itemData[index]['title'] ==
                                              'حذف الحساب'.tr()
                                          ? redClr
                                          : Colors.white,
                                    ),
                                    horizontalSpace(9),
                                    Expanded(
                                      child: TextUtils(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            itemData[index]['title'] ==
                                                'حذف الحساب'.tr()
                                            ? redClr
                                            : Colors.white,
                                        text: itemData[index]['title'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              verticalSpace(10),
                              Visibility(
                                visible: index != itemData.length - 1,
                                child: Divider(
                                  color: greyClr.withOpacity(0.08),
                                ),
                              ),
                              verticalSpace(10),
                            ],
                          );
                        },
                      ),
                      // إضافة مسافة من الأسفل للتأكد من أن المحتوى لا يلتصق بالحافة
                      verticalSpace(30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
