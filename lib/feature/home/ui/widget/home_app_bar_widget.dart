import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/anmiate_builder.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/helpers/shared_pref_helper.dart';

class HomeAppBarWidget extends StatelessWidget {
  final VoidCallback? onDrawerTap;

  const HomeAppBarWidget({super.key, this.onDrawerTap});

  String getWelcomeText(String role) {
    switch (role) {
      case 'MainClub':
        return 'أهلاً بنادي';

      case 'Club':
        return 'حياك الله';

      case 'Scout':
        return 'حياك الله';

      default:
        return 'حياك الله';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      width: context.displayWidth,
      height: 50.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── اسم المستخدم ─────────────────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/Mask group.png', width: 32.w),
                horizontalSpace(5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<dynamic>(
                      future: SharedPrefHelper.getSecuredString(
                        SharedPrefKeys.userType,
                      ),
                      builder: (context, snapshot) {
                        return TextUtils(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: blackclr,
                          text: getWelcomeText(
                            snapshot.data?.toString() ?? '',
                          ).tr(),
                        );
                      },
                    ),
                    verticalSpace(1),
                    BlocBuilder<MainCubit, MainState>(
                      buildWhen: (previous, current) =>
                          current is myProfileLoading ||
                          current is myProfileSuccess ||
                          current is myProfileError,
                      builder: (context, state) {
                        return state.maybeWhen(
                          myProfilesuccess: (clubProfile) {
                            return AnimateBuilder(
                              columnCount: 1,
                              position: 0,
                              child: TextUtils(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                text: clubProfile.data.firstName ?? '',
                              ),
                            );
                          },
                          orElse: () => TextUtils(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            text: '',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Notification ──────────────────────────────────────────────
          Container(
            height: 45.h,
            width: 45.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mainColor.withOpacity(0.1),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/notification_icon.svg',
                width: 18.w,
              ),
            ),
          ),

          horizontalSpace(10),

          // ── Drawer ────────────────────────────────────────────────────
          InkWell(
            onTap: () {
              if (onDrawerTap != null) {
                // ClubMainScreen — استخدم الـ ScaffoldState
                onDrawerTap!();
              } else {
                // MainScreen الأصلي — استخدم sliderDrawerKey
                final mainCubit = context.read<MainCubit?>();
                final drawerState = mainCubit?.sliderDrawerKey.currentState;
                if (drawerState?.isDrawerOpen == true) {
                  drawerState?.closeDrawer();
                } else {
                  drawerState?.openDrawer();
                }
              }
            },
            child: Container(
              height: 45.h,
              width: 45.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mainColor.withOpacity(0.1),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/drawer_icon.svg',
                  width: 18.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
