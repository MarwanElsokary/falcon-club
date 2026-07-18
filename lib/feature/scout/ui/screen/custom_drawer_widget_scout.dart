import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/url-call.dart';
import 'package:falconclubapp/feature/main_screen/ui/widget/log_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../profile/presentation/widgets/profile_drawer_header.dart';

class CustomDrawerScout extends StatelessWidget {
  const CustomDrawerScout({super.key});

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
        'width': 20.w,
        'icon': 'assets/svgs/profile.svg',
        'title': 'الملف الشخصي'.tr(),
        'ontap': () {
          context.pushNamed(AppRoute.scoutProfileScreen);
        },
      },
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
                      // ── الهيدر المشترك ──────────────────────────────
                      ProfileDrawerHeader(
                        showSubscriptionBadge: true,
                        onHeaderTap: () =>
                            context.pushNamed(AppRoute.packageScreen),
                        onClose: () => Scaffold.maybeOf(context)?.closeDrawer(),
                      ),

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
