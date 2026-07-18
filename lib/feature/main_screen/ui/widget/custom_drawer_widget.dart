import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/feature/main_screen/ui/widget/log_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../core/widget/url-call.dart';
import '../../../profile/presentation/widgets/profile_drawer_header.dart';
import '../../cubit/main_cubit.dart';
import '../../data/model/user_role.dart';
import 'drawer_permissions.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _closeDrawer(BuildContext context) {
    // محاولة إغلاق الـ drawer بأي طريقة متاحة
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null && scaffoldState.isDrawerOpen) {
      scaffoldState.closeDrawer();
      return;
    }
    // fallback للـ MainScreen الأصلي
    final mainCubit = context.read<MainCubit?>();
    final sliderState = mainCubit?.sliderDrawerKey.currentState;
    if (sliderState?.isDrawerOpen == true) {
      sliderState?.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = UserRoleHelper.getCurrentRole(
      CacheHelper.getString('userType'),
    );

    final List<Map<String, dynamic>> itemData = [];
    if (DrawerPermissions.canShowProfile(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/profile.svg',
        'title': 'الحساب'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(AppRoute.clubProfileScreen);
        },
      });
    }
    if (DrawerPermissions.clubInfoScreen(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/profile.svg',
        'title': 'الحساب'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(AppRoute.clubInfoScreen);
        },
      });
    }
    if (DrawerPermissions.canShowNotifications(role)) {
      itemData.add({
        'width': 16.w,
        'icon': 'assets/svgs/notification_icon.svg',
        'title': 'الاشعارات'.tr(),
        'ontap': () {},
      });
    }
    if (DrawerPermissions.canShowMyTeam(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/mage_users.svg',
        'title': 'فريقي'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(
            AppRoute.clubMyTeamScreen,
            arguments: {'context': context},
          );
        },
      });
    }
    if (DrawerPermissions.canShowRequests(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/solar_clipboard-linear.svg',
        'title': 'الطلبات'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(
            AppRoute.requestsScreen,
            arguments: {'context': context},
          );
        },
      });
    }

    if (DrawerPermissions.canShowRank(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/rank_icon.svg',
        'title': 'الترتيب'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(
            AppRoute.rankScreen,
            arguments: {'context': context},
          );
        },
      });
    }
    if (DrawerPermissions.canShowExperiments(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/Experiments_select.svg',
        'title': 'التجارب'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(AppRoute.allExperimentScreen);
        },
      });
    }
    if (DrawerPermissions.canShowTraining(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/Training_select.svg',
        'title': 'التدريبات'.tr(),
        'ontap': () {
          _closeDrawer(context);
          context.pushNamed(AppRoute.trainingScreen);
        },
      });
    }
    itemData.add({
      'width': 20.w,
      'icon': 'assets/svgs/lock-svgrepo-com.svg',
      'title': 'سياسة الخصوصية'.tr(),
      'ontap': () {
        urlCall(
          context: context,
          url: 'https://falconai.net/api/Website/GetPrivacy',
        );
      },
    });
    itemData.add({
      'width': 15.w,
      'icon': 'assets/svgs/logout_icon.svg',
      'title': 'تسجيل الخروج'.tr(),
      'ontap': () {
        // Capture the navigator before the drawer closes. `_closeDrawer` removes
        // CustomDrawer from the tree, deactivating THIS build context — so the
        // callback below must not reach for `Navigator.of(context)` after that.
        final navigator = Navigator.of(context, rootNavigator: true);
        _closeDrawer(context);
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
    });
    if (DrawerPermissions.canDeleteAccount(role)) {
      itemData.add({
        'width': 20.w,
        'icon': 'assets/svgs/delete-02.svg',
        'title': 'حذف الحساب'.tr(),
        'ontap': () {
          final navigator = Navigator.of(context, rootNavigator: true);
          _closeDrawer(context);
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
      });
    }

    return Drawer(
      width: context.displayWidth,
      child: Container(
        decoration: const BoxDecoration(
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ── بيانات المستخدم (الهيدر المشترك) ─────────────
                      ProfileDrawerHeader(onClose: () => _closeDrawer(context)),

                      // ── قائمة العناصر ─────────────────────────────────
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: itemData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final isDelete =
                              itemData[index]['title'] == 'حذف الحساب'.tr();
                          return Column(
                            children: [
                              InkWell(
                                onTap: itemData[index]['ontap'],
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      itemData[index]['icon'],
                                      width: itemData[index]['width'],
                                      color: isDelete ? redClr : Colors.white,
                                    ),
                                    horizontalSpace(9),
                                    Expanded(
                                      child: TextUtils(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: isDelete ? redClr : Colors.white,
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
