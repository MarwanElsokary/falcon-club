import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/constants.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../cubit/club_team_cubit.dart';
import 'club_my_team_screen.dart';
import 'club_profile_screen.dart';
import 'placeholder_screen.dart';

class ClubMainScreen extends StatefulWidget {
  const ClubMainScreen({super.key});

  @override
  State<ClubMainScreen> createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClubTeamCubit>().emitMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout, color: mainColor, size: 24.w),
          onPressed: () => _showLogoutDialog(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 16.w),
            child: CenterTextUtils(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'صقر'.tr(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: context.read<ClubTeamCubit>().currentIndex,
            builder: (context, currentIndex, _) {
              return IndexedStack(
                index: currentIndex,
                children: [
                  const ClubProfileScreen(),
                  const ClubMyTeamScreen(),
                  PlaceholderScreen(title: 'قريباً'.tr()),
                  PlaceholderScreen(title: 'قريباً'.tr()),
                  PlaceholderScreen(title: 'قريباً'.tr()),
                ],
              );
            },
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: ValueListenableBuilder(
              valueListenable: context.read<ClubTeamCubit>().currentIndex,
              builder: (context, currentIndex, _) {
                return ValueListenableBuilder(
                  valueListenable: context.read<ClubTeamCubit>().show,
                  builder: (context, show, _) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: context.displayWidth / 1,
                      height: show ? 130.h : 0,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SlideEnimationWidget(
                              index: 0,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      verticalSpace(50),
                                      Container(
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              'assets/images/Subtract.png',
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children:
                                              List.generate(5, (index) {
                                            bool isSelected =
                                                currentIndex == index;

                                            return Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    context
                                                        .read<ClubTeamCubit>()
                                                        .currentIndex
                                                        .value = index;
                                                  });
                                                },
                                                splashColor:
                                                    Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    SizedBox(
                                                      height: isSelected
                                                          ? 26.h
                                                          : 24.h,
                                                      width: isSelected
                                                          ? 26.h
                                                          : 24.h,
                                                      child: isSelected
                                                          ? _activeIcons[
                                                              index]
                                                          : _inactiveIcons[
                                                              index],
                                                    ),
                                                    CenterTextUtils(
                                                      fontSize: 10,
                                                      fontWeight: isSelected
                                                          ? FontWeight.w700
                                                          : FontWeight.w500,
                                                      color: isSelected
                                                          ? mainColor
                                                          : mainColor
                                                              .withOpacity(
                                                                  0.5),
                                                      text: _titles[index],
                                                    ),
                                                    verticalSpace(5),
                                                    AnimatedContainer(
                                                      duration:
                                                          const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      height: isSelected
                                                          ? 7.h
                                                          : 0.h,
                                                      width: 7.w,
                                                      decoration:
                                                          BoxDecoration(
                                                        color: mainColor,
                                                        shape:
                                                            BoxShape.circle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: CenterTextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'هل تريد تسجيل الخروج؟'.tr(),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await SharedPrefHelper.clearSpecificSecureData(
                        SharedPrefKeys.userToken,
                      );
                      await SharedPrefHelper.clearAllData();
                      Navigator.of(dialogContext).pop();
                      context.pushNamedAndRemoveUntil(
                        AppRoute.loginScreen,
                        predicate: (route) => false,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CenterTextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        text: 'نعم'.tr(),
                      ),
                    ),
                  ),
                ),
                horizontalSpace(15),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: primerymainColor,
                      ),
                      child: CenterTextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: 'لا'.tr(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(10),
          ],
        );
      },
    );
  }

  List<Widget> get _inactiveIcons => [
        Icon(Icons.person_outline, color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.groups_outlined, color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.analytics_outlined, color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.calendar_today_outlined, color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.settings_outlined, color: mainColor.withOpacity(0.5), size: 24.h),
      ];

  List<Widget> get _activeIcons => [
        Icon(Icons.person, color: mainColor, size: 26.h),
        Icon(Icons.groups, color: mainColor, size: 26.h),
        Icon(Icons.analytics, color: mainColor, size: 26.h),
        Icon(Icons.calendar_today, color: mainColor, size: 26.h),
        Icon(Icons.settings, color: mainColor, size: 26.h),
      ];

  List<String> get _titles => [
        'ملفي'.tr(),
        'فريقي'.tr(),
        'قريباً'.tr(),
        'قريباً'.tr(),
        'قريباً'.tr(),
      ];
}
